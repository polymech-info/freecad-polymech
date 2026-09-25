"""
Utility functions for the CAM function calling tool implementations.
"""

import re
import time
import unicodedata

from collections.abc import Callable
from enum import Flag, StrEnum, auto
from typing import Any

import adsk.cam
import adsk.core
import adsk.fusion
from CAMFunctionContext import CAMFunctionContext
from CAMFunctionTasks import CAMFunctionTaskContext
from ToolDefinition import (
    TOOL_LIBRARY_SEARCH_PRIORITY,
    ToolDefinition,
    ToolLibraryDefinition,
    ToolLibraryType,
)


class MissingObjectReason(StrEnum):
    NONE = auto()
    NO_MATCHING_NAME = auto()
    NO_MATCHING_REGEX = auto()
    NO_OBJECTS = auto()


class HoleAttributes(Flag):
    SIMPLE = auto()
    COUNTERBORE = auto()
    THROUGH = auto()
    BLIND = auto()
    CHAMFER = auto()


# This enum should be in ModelInput.py, but is needed in multiple files
class ModelInputMode(StrEnum):
    """
    Enum representing different modes for model input.
    """

    NONE = "none"
    ALL = "all"
    NAMED = "named"
    MANUFACTURING_MODEL = "manufacturing_model"
    ACTIVE_SELECTION = "active_selection"


class CAMObjectType(StrEnum):
    """
    Enum representing different types of manufacturing objects.
    """

    SETUP = "setup"
    OPERATION = "operation"
    FOLDER = "folder"
    PATTERN = "pattern"
    MANUFACTURING_MODEL = "manufacturingModel"
    ANY = "any"

    def includesType(self, objectType) -> bool:
        """
        Check if this object type includes the given object type.
        ANY will also be included in the check.
        """
        return self == objectType or self == CAMObjectType.ANY

    def canBeUnderSetup(self) -> bool:
        """
        Check if this object type is a type that can be located under a setup.
        """
        match self:
            case (
                CAMObjectType.OPERATION
                | CAMObjectType.FOLDER
                | CAMObjectType.PATTERN
                | CAMObjectType.ANY
            ):
                return True
            case CAMObjectType.SETUP | CAMObjectType.MANUFACTURING_MODEL:
                return False
            case _:
                return False


# Boilerplate initialization
def init():
    """
    Boilerplate code for CAM functions to retrieve the application, document,
    and CAM workspace.
    """

    app = adsk.core.Application.get()
    ui = app.userInterface

    # Use active document
    doc = app.activeDocument

    # Get the CAM product
    products = doc.products
    cam = adsk.cam.CAM.cast(products.itemByProductType("CAMProductType"))

    return app, ui, doc, products, cam


def designProduct() -> adsk.fusion.Design:
    """Return the Design Product (workspace) of the active document."""
    _, _, _, products, _ = init()
    design = products.itemByProductType("DesignProductType")
    return adsk.fusion.Design.cast(design)


# String helpers
def isNonEmptyString(string: str | None) -> bool:
    """Check if the given string is a valid string (not None and not empty)."""
    return string is not None and string != ""


def getActionStringFromMode(mode: str) -> str:
    """
    Get the string of the operation mode ("x", "u" or "d").
    """
    function_type_map = {"x": "creating", "u": "updating", "d": "deleting"}
    return function_type_map.get(mode, "unknown")


def getOperationTypeString(operationType: adsk.cam.OperationTypes) -> str:
    """
    Get the string of the operation type.
    """
    operation_type_map = {
        adsk.cam.OperationTypes.MillingOperation: "milling",
        adsk.cam.OperationTypes.TurningOperation: "turning",
        adsk.cam.OperationTypes.JetOperation: "jet",
        adsk.cam.OperationTypes.AdditiveOperation: "additive",
    }
    return operation_type_map.get(operationType, "Unknown")


def getListAsString(list: list | None) -> str:
    """
    Get the string of a list of names from a list of strings.
    e.g. ["op1", "op2", "op3"] -> "'op1', 'op2', 'op3'"
    """
    if list is None or len(list) == 0:
        return ""
    return ", ".join([f"'{item}'" for item in list])


def extractNameAndRegexEnabled(nameArg: dict | str | None) -> tuple[str, bool]:
    """
    Extract the name string and regex_enabled flag from the given argument.
    If the argument is None, return an empty string and False.
    If the argument is a string, return it and False.
    If the argument is a dictionary, return the "name" value and the "regex"
    value (defaulting to False if not present).
    """
    if nameArg is None:
        return "", False
    elif isinstance(nameArg, str):
        return nameArg, False
    elif isinstance(nameArg, dict):
        return nameArg.get("name", ""), nameArg.get("regex_enabled", False)
    else:
        raise ValueError("Invalid argument type for nameArg.")


# Model/occurrence helpers
def containsBodies(occurrence: adsk.fusion.Occurrence) -> bool:
    """
    Given an occurrence, returns true if there are any B-Rep or Mesh bodies in
    it (without recursion to child occurrences).
    """
    return occurrence.bRepBodies.count + occurrence.component.meshBodies.count > 0


def getValidOccurrences(
    occurrence: adsk.fusion.Occurrence,
) -> list[adsk.fusion.Occurrence]:
    """
    Given an occurrence, this finds all child occurrences that contain either a
    B-Rep or Mesh body. It is recursive, so it will find all occurrences at all
    levels.
    """
    result = []
    for childOcc in occurrence.childOccurrences:
        if containsBodies(childOcc):
            result.append(childOcc)
        result.extend(getValidOccurrences(childOcc))

    return result


def getManufacturingModelBRepBodies(
    manufacturingModel: adsk.cam.ManufacturingModel,
) -> list[adsk.fusion.BRepBody]:
    """Get the bodies found in manufacturing model"""
    occurrences = getValidOccurrences(manufacturingModel.occurrence)
    result = []
    if len(occurrences) > 0:
        for occurrence in occurrences:
            bRepBodies = occurrence.bRepBodies
            if bRepBodies.count > 0:
                result.extend([bRepBodies.item(i) for i in range(bRepBodies.count)])

    return result


def getHoleSegmentBottomEdge(
    holeSegment: adsk.cam.RecognizedHoleSegment,
) -> adsk.fusion.BRepEdge | None:
    """
    Get the bottom edge of the given hole segment, if:
    - the segment is made by one face
    - the hole is aligned with Z+ (bounding box checking)
    Returns None otherwise.
    """

    if len(holeSegment.faces) != 1:
        # Expected a hole segment with a single face
        return None

    face = adsk.fusion.BRepFace.cast(holeSegment.faces[0])
    if not face:
        # Expected a BRep face
        return None

    faceEdges: adsk.fusion.BRepEdges = face.edges
    if faceEdges.count != 2:
        # Expected a hole segment with a single face made of two edges
        return None

    # Return the lower edge in Z
    if faceEdges[0].boundingBox.maxPoint.z < faceEdges[1].boundingBox.maxPoint.z:
        return faceEdges[0]
    else:
        return faceEdges[1]


def boundarySelectionNeedsFlipping(edge: adsk.fusion.BRepEdge) -> bool:
    """
    Check if the selected edge should be flipped for geometry selection (to
    mill inside counterbore).

    Returns true if it needs to be flipped.
    """
    Z_POS = adsk.core.Vector3D.create(0, 0, 1)

    geometry = edge.geometry
    if geometry:
        circle = adsk.core.Circle3D.cast(geometry)
        if circle:
            return not circle.normal.isEqualTo(Z_POS)

    return False


# Item-by-name helpers
def getNormalizedLowerCaseName(name: str) -> str:
    """
    Normalize the given name into consistent lower-case unicode characters.
    """
    return unicodedata.normalize("NFKD", name).casefold()


def areMatchingCaseInsensitiveNames(name1: str, name2: str) -> bool:
    """
    Check if two names match case-insensitively.
    """
    return getNormalizedLowerCaseName(name1) == getNormalizedLowerCaseName(name2)


def hasMatchingCaseInsensitiveName(
    item: adsk.cam.OperationBase,
    name: str,
    regexEnabled: bool = False,
) -> bool:
    """
    Check if the given item has a name that matches the given name.
    This does a case-insensitive comparison for both regular expressions and
    exact matches.
    If regexEnabled is True, `name` is treated as a regular expression.
    """
    normalizedItemName = getNormalizedLowerCaseName(item.name)
    normalizedName = getNormalizedLowerCaseName(name)

    if regexEnabled:
        return re.search(normalizedName, normalizedItemName) is not None
    else:
        return normalizedItemName == normalizedName


def findMatchingParentsFromList(
    parents: list[adsk.cam.Base],
    parentName: str | None,
    regexEnabled: bool,
) -> tuple[MissingObjectReason, list[adsk.cam.Base], bool]:
    """
    Find all parent objects (Setups, Folders, Patterns) in the list that match
    the given name.
    If parentName is None, all objects are returned.
    If regexEnabled is True, the name is treated as a regular expression.

    Returns a tuple of:
    - A MissingObjectReason indicating the reason for missing objects
      (NONE if objects were found)
    - A list of adsk.cam.Base objects that match the name
    - A boolean indicating if the search was for all objects
      (True if parentName is None or empty)
    """
    parentNameIsProvided: bool = isNonEmptyString(parentName)

    # Get the scope of parents that we want to search
    selectingAllObjects: bool = False
    if not parentNameIsProvided:
        selectingAllObjects = True
        parentName = ".*"
        regexEnabled = True

    # Get the matching parents
    matchingParents: list[adsk.cam.Base] = [
        parent
        for parent in parents
        if hasMatchingCaseInsensitiveName(parent, parentName, regexEnabled)
    ]

    # Check that we found at least one parent according to the search criteria
    reason = MissingObjectReason.NONE

    if not regexEnabled and parentNameIsProvided:
        # If exact name is provided, check we found it
        if len(matchingParents) == 0:
            reason = MissingObjectReason.NO_MATCHING_NAME
    elif not selectingAllObjects and regexEnabled and parentNameIsProvided:
        # If regex is enabled, check we found at least one parent
        if len(matchingParents) == 0:
            reason = MissingObjectReason.NO_MATCHING_REGEX
    elif len(matchingParents) == 0:
        # If no search criteria is provided, there were no parents to find
        reason = MissingObjectReason.NO_OBJECTS

    return reason, matchingParents, selectingAllObjects


def findMatchingSetups(
    setupName: str | None,
    regexEnabled: bool,
    cam: adsk.cam.CAM,
    errorMessage: str,
) -> tuple[bool, list[adsk.cam.Setup], bool]:
    """
    Find all setups in the CAM document that match the given name.
    If setupName is None, all setups are returned.
    If regexEnabled is True, the name is treated as a regular expression.

    Returns a tuple of:
    - A boolean indicating if setups were found that match the name
    - A list of adsk.cam.Setup objects that match the name
    - A boolean indicating if the search was for all setups
      (True if setupName is None or empty)

    If no setups are found according to the search criteria, the function will
    add an error message to the CAMFunctionContext.
    """

    reason, matchingObjects, selectingAllObjects = findMatchingParentsFromList(
        parents=cam.setups,
        parentName=setupName,
        regexEnabled=regexEnabled,
    )

    if reason == MissingObjectReason.NO_MATCHING_NAME:
        CAMFunctionContext.fail(
            message=errorMessage,
            error=f"Setup '{setupName}' not found.",
        )
    elif reason == MissingObjectReason.NO_MATCHING_REGEX:
        CAMFunctionContext.fail(
            message=errorMessage,
            error=f"No matching setups for the name: '{setupName}'.",
        )
    elif reason == MissingObjectReason.NO_OBJECTS:
        CAMFunctionContext.fail(
            message=errorMessage,
            error="No setups found.",
        )

    return reason == MissingObjectReason.NONE, matchingObjects, selectingAllObjects


def findMatchingParents(
    parentName: str | None,
    regexEnabled: bool,
    cam: adsk.cam.CAM,
    errorMessage: str,
) -> tuple[bool, list[adsk.cam.Base], bool]:
    """
    Find all objects in the CAM document that can contain operations
    (Setups, Folders, Patterns), that match the given name.
    If parentName is None, all parents are returned.
    If regexEnabled is True, the name is treated as a regular expression.

    Returns a tuple of:
    - A boolean indicating if parents were found that match the name
    - A list of adsk.cam.Base objects that match the name
    - A boolean indicating if the search was for all parents
      (True if parentName is None or empty)

    If no parents are found according to the search criteria, the function will
    add an error message to the CAMFunctionContext.
    """

    # Get all objects that could contain an operation
    objects: list[adsk.cam.Base] = []

    def addNestedParentObjects(
        parent: adsk.cam.CAMFolder | adsk.cam.CAMPattern | adsk.cam.Setup,
    ):
        objects.append(parent)
        for child in parent.children:
            if (
                child.objectType == adsk.cam.CAMFolder.classType()
                or child.objectType == adsk.cam.CAMPattern.classType()
            ):
                addNestedParentObjects(child)

    for setup in cam.setups:
        addNestedParentObjects(setup)

    # Find the matching parents
    reason, matchingParents, selectingAllParents = findMatchingParentsFromList(
        parents=objects,
        parentName=parentName,
        regexEnabled=regexEnabled,
    )

    if reason == MissingObjectReason.NO_MATCHING_NAME:
        CAMFunctionContext.fail(
            message=errorMessage,
            error=f"Parent '{parentName}' not found.",
        )
    elif reason == MissingObjectReason.NO_MATCHING_REGEX:
        CAMFunctionContext.fail(
            message=errorMessage,
            error=f"No matching parents for the name: '{parentName}'.",
        )
    elif reason == MissingObjectReason.NO_OBJECTS:
        CAMFunctionContext.fail(
            message=errorMessage,
            error="No parents found.",
        )

    return reason == MissingObjectReason.NONE, matchingParents, selectingAllParents


def findMatchingSetupsByType(
    setupName: str | None,
    regexEnabled: bool,
    cam: adsk.cam.CAM,
    operationType: adsk.cam.OperationTypes,
    errorMessage: str,
) -> tuple[bool, list[adsk.cam.Setup], bool]:
    """
    Find all setups in the CAM document that match the given name and operation
    type.
    If setupName is None, all setups are returned.
    If regexEnabled is True, the name is treated as a regular expression.

    Returns a tuple of:
    - A boolean indicating if setups were found that match the name
    - A list of adsk.cam.Setup objects that match the name
    - A boolean indicating if the search was for all setups
      (True if setupName is None or empty)

    If no setups are found according to the search criteria, the function will
    add an error message to the CAMFunctionContext.
    """

    # Find all setups that match the name
    foundSetups, setups, selectingAllSetups = findMatchingSetups(
        setupName=setupName,
        regexEnabled=regexEnabled,
        cam=cam,
        errorMessage=errorMessage,
    )
    if not foundSetups:
        # If no setups were found, return False
        return False, [], selectingAllSetups

    # Check if the setups are the right type
    def isCorrectOperationType(setup):
        return setup.operationType == operationType

    matchingSetups = [setup for setup in setups if isCorrectOperationType(setup)]
    differentSetups = [setup for setup in setups if not isCorrectOperationType(setup)]
    if (len(differentSetups) > 0) and not (regexEnabled or selectingAllSetups):
        CAMFunctionContext.fail(
            message=errorMessage,
            error=f"Setup '{setups[0].name}' is not the correct type '{getOperationTypeString(operationType)}'.",
        )
        foundSetups = False
    elif len(matchingSetups) == 0:
        if selectingAllSetups:
            CAMFunctionContext.fail(
                message=errorMessage,
                error=f"No {getOperationTypeString(operationType)} setups found.",
            )
        else:
            CAMFunctionContext.fail(
                message=errorMessage,
                error=f"No matching {getOperationTypeString(operationType)} setups for the name: '{setupName}'.",
            )
        foundSetups = False

    return foundSetups, matchingSetups, selectingAllSetups


def findMatchingAdditiveSetups(
    setupName: str | None,
    regexEnabled: bool,
    cam: adsk.cam.CAM,
    errorMessage: str,
) -> tuple[bool, list[adsk.cam.Setup]]:
    """
    Find all additive setups in the CAM document that match the given name.
    If setupName is None, all setups are returned.
    If regexEnabled is True, the name is treated as a regular expression.

    Returns a tuple of:
    - A boolean indicating if additive setups were found that match the name
    - A list of adsk.cam.Setup objects that match the name and are additive
      setups
    """

    foundSetups, matchingSetups, _ = findMatchingSetupsByType(
        setupName=setupName,
        regexEnabled=regexEnabled,
        cam=cam,
        operationType=adsk.cam.OperationTypes.AdditiveOperation,
        errorMessage=errorMessage,
    )
    return foundSetups, matchingSetups


def findAdditiveArrangeInSetup(setup: adsk.cam.Setup):
    operations = setup.operations
    for i in range(operations.count):
        operation = operations.item(i)
        if operation.strategy == "additive_arrange":
            return operation
    return None


def searchChildrenForName(
    children: adsk.cam.ChildOperationList,
    name: str,
    objectType: CAMObjectType,
    parentTask: CAMFunctionTaskContext,
) -> tuple[adsk.cam.OperationBase | None, str | None]:
    """
    Iterate through all child objects in the given collection and search for
    an object with the given name.
    """

    # If the children collection is empty, return None
    if children.count == 0:
        return None, None

    with parentTask.makeSubTask(numberOfTasks=children.count) as task:
        for i in range(children.count):
            with task.makeSubTaskByIndex(index=i) as childTask:
                child = children.item(i)
                if child.objectType == adsk.cam.CAMFolder.classType():
                    if objectType.includesType(
                        CAMObjectType.FOLDER
                    ) and hasMatchingCaseInsensitiveName(child, name):
                        return child, CAMObjectType.FOLDER.value
                    # Recursively search within folder children
                    found, typeStr = searchChildrenForName(
                        child.children, name, objectType, childTask
                    )
                    if found:
                        return found, typeStr
                elif child.objectType == adsk.cam.CAMPattern.classType():
                    if objectType.includesType(
                        CAMObjectType.PATTERN
                    ) and hasMatchingCaseInsensitiveName(child, name):
                        return child, CAMObjectType.PATTERN.value
                    # Recursively search within pattern children
                    found, typeStr = searchChildrenForName(
                        child.children, name, objectType, childTask
                    )
                    if found:
                        return found, typeStr
                elif (
                    objectType.includesType(CAMObjectType.OPERATION)
                    and child.objectType == adsk.cam.Operation.classType()
                    and hasMatchingCaseInsensitiveName(child, name)
                ):
                    return child, CAMObjectType.OPERATION.value

        return None, None


def findObjectByName(
    cam: adsk.cam.CAM,
    name: str,
    object_type: str,
    parentTask: CAMFunctionTaskContext,
) -> tuple[adsk.cam.OperationBase | None, str | None]:
    """
    Returns the first object found in the CAM document with the given name and
    a string of its type.
    """

    objectType = CAMObjectType.ANY
    if object_type is not None:
        try:
            objectType = CAMObjectType(object_type)
        except ValueError:
            CAMFunctionContext.warn(
                message="Manufacturing object type is not recognized.",
                warning=f"Unrecognized manufacturing object type: '{object_type}'. All manufacturing objects will be used for searching.",
            )

    if objectType.includesType(CAMObjectType.MANUFACTURING_MODEL):
        manufacturingModels = cam.manufacturingModels
        if manufacturingModels.count > 0:
            for i in range(manufacturingModels.count):
                manufacturingModel = manufacturingModels.item(i)
                if hasMatchingCaseInsensitiveName(manufacturingModel, name):
                    return manufacturingModel, "manufacturing model"

    if objectType != CAMObjectType.MANUFACTURING_MODEL:
        # Only when we have a manufacturing model we don't want to look through the setups
        setups = cam.setups
        if setups.count == 0:
            # If there are no setups, return None
            return None, None

        with parentTask.makeSubTask(numberOfTasks=setups.count) as task:
            for i, setup in enumerate(setups):
                with task.makeSubTaskByIndex(index=i) as setupTask:
                    if objectType.includesType(
                        CAMObjectType.SETUP
                    ) and hasMatchingCaseInsensitiveName(setup, name):
                        return setup, "setup"

                    # Search within setup children for the named object if the setup name does not match
                    if objectType.canBeUnderSetup():
                        found, typeStr = searchChildrenForName(
                            setup.children, name, objectType, setupTask
                        )
                        if found:
                            return found, typeStr

    return None, None


# CAM operation helpers
def createManufacturingModel(
    cam: adsk.cam.CAM,
    task: CAMFunctionTaskContext,
    name: str = None,
) -> adsk.cam.ManufacturingModel:
    """
    Create a new manufacturing model in the CAM document.
    """

    manufacturingModels = cam.manufacturingModels
    mmInput = manufacturingModels.createInput()

    # Change the name if it is defined
    if isNonEmptyString(name):
        mmInput.name = name

    # Async worker to create the manufacturing model
    #
    # This can be a long operation, so we run it asynchronously and
    # indeterminately increment the progress bar
    async def worker() -> adsk.cam.ManufacturingModel:
        return manufacturingModels.add(mmInput)

    manufacturingModel = task.runAsyncWorker(worker=worker)

    # Creating a new manufacturing model will schedule an idle task for invalidating 
    # any CAD reference cache. Since we need to use the manufacturing model right away, 
    # we need to ensure that the cache is valid before proceeding and not rely on 
    # adsk.doEvents() calls that might execute the idle task we need or not.
    # Calling cam.checkValidity() will force the cache to be updated as necessary and 
    # the manufacturing model can be used as a CAD reference as normal.
    cam.checkValidity()

    # Check that the manufacturing model was created with the correct name
    if isinstance(name, str) and name != manufacturingModel.name:
        CAMFunctionContext.blockFutureExecution(
            warning=f"Created manufacturing model named '{manufacturingModel.name}' (instead of '{name}')."
        )
    else:
        CAMFunctionContext.succeed(
            message=f"Created manufacturing model '{manufacturingModel.name}'."
        )
    return manufacturingModel


def getManufacturingModelByName(
    cam: adsk.cam.CAM, name: str
) -> adsk.cam.ManufacturingModel | None:
    """
    Returns the first manufacturing model matching the given name, or None.
    """
    manufacturingModels = [
        model
        for model in cam.manufacturingModels
        if hasMatchingCaseInsensitiveName(model, name)
    ]
    return next(iter(manufacturingModels), None)


def setAdditiveSetup(
    cam: adsk.cam.CAM,
    additiveTechnology: str,
    setupInput: adsk.cam.SetupInput,
    task: CAMFunctionTaskContext,
    manufacturingModelName: str = None,
) -> bool:
    """
    Helper function to set machine, print setting, and model in the inputs for
    a new additive setup.
    """

    # Check the chosen technology, determine the machine and print setting
    printSettingRegex = None
    if additiveTechnology == "FFF":
        machineModel = "Generic FFF Machine"
        printSettingName = "PLA (Direct Drive)"
    elif additiveTechnology == "DED":
        machineModel = "Generic DED"
        printSettingName = None
    elif additiveTechnology == "MPBF":
        machineModel = "Generic MPBF"
        printSettingName = "MPBF 10 micron"
        printSettingRegex = re.compile("MPBF 10 micron")
    elif additiveTechnology == "MJF":
        machineModel = "Jet Fusion 5000"
        printSettingName = "HP - MJF"
    elif additiveTechnology == "Binder Jetting":
        machineModel = "Metal Jet S100"
        printSettingName = "HP - BinderJet"
    elif additiveTechnology == "SLA/DLP":
        machineModel = "Generic SLA/DLP Printer"
        printSettingName = "Autodesk Generic SLA"
    elif additiveTechnology == "SLS":
        machineModel = "Generic SLS Machine"
        printSettingName = "Generic SLS"
    else:
        CAMFunctionContext.fail(
            message="Error setting additive setup:",
            error="Additive technology not specified or unknown.",
        )
        return False

    # Find the machine model and print setting from Fusion library
    camManager = adsk.cam.CAMManager.get()
    libraryManager = camManager.libraryManager

    machine = None
    machineTask = task.makeSubTask(
        message="Getting machine",
        progressRange=(0, 70),
    )
    with machineTask:
        machineLibrary = libraryManager.machineLibrary
        machineUrl = machineLibrary.urlByLocation(
            adsk.cam.LibraryLocations.Fusion360LibraryLocation
        )  ## .Fusion360LibraryLocation vs .LocalLibraryLocation etc.

        # Get the machines from this location
        #
        # This can be a long operation, so we run it asynchronously and
        # indeterminately increment the progress bar
        async def worker() -> list[adsk.cam.Machine]:
            return machineLibrary.childMachines(machineUrl)

        machines = machineTask.runAsyncWorker(worker=worker)

        for m in machines:
            if m.model == machineModel:
                machine = m
                break

    if not machine:
        CAMFunctionContext.fail(
            message="Error setting additive setup:",
            error=f"Machine '{machineModel}' not found.",
        )
        return False

    # Find the print setting, if the machine model requires one
    printSettingTask = task.makeSubTask(
        message="Getting print setting",
        progressRange=(70, 90),
    )
    with printSettingTask:
        if printSettingName is not None:
            printSettingLibrary = libraryManager.printSettingLibrary
            printSettingUrl = printSettingLibrary.urlByLocation(
                adsk.cam.LibraryLocations.Fusion360LibraryLocation
            )  ## .Fusion360LibraryLocation vs .LocalLibraryLocation etc.

            # Get the print settings from this location
            #
            # This can be a long operation, so we run it asynchronously and
            # indeterminately increment the progress bar
            async def worker() -> list[adsk.cam.PrintSetting]:
                return printSettingLibrary.childPrintSettings(printSettingUrl)

            printSettings = printSettingTask.runAsyncWorker(worker=worker)

            printSetting = None
            if printSettingRegex is None:
                printSettingRegex = re.compile(f"^{re.escape(printSettingName)}$")
            for ps in printSettings:
                if printSettingRegex.search(ps.name):
                    printSetting = ps
                    break
            if not printSetting:
                CAMFunctionContext.fail(
                    message="Error setting additive setup:",
                    error=f"Print setting matching '{printSettingName}' not found.",
                )
                return False
        else:
            printSetting = None

    # Determine the manufacturing model to use
    # If name is given, use the first matching model with that name
    # If not given, use the first available manufacturing model
    # If we don't find a model, create one
    manufacturingModels = cam.manufacturingModels
    manufacturingModel = None

    manufacturingModelTask = task.makeSubTask(
        message="Getting manufacturing model",
        progressRange=(90, 95),
    )
    with manufacturingModelTask:
        if isNonEmptyString(manufacturingModelName):
            manufacturingModel = getManufacturingModelByName(
                cam=cam,
                name=manufacturingModelName,
            )
            if not manufacturingModel:
                CAMFunctionContext.fail(
                    message="Error setting additive setup:",
                    error=f"Manufacturing model '{manufacturingModelName}' not found.",
                )
                return False
        elif manufacturingModels.count > 0:
            manufacturingModel = manufacturingModels.item(0)

        # Check that we have models to use for the models of the setup
        if manufacturingModel is None:
            validModel = (
                containsBodies(cam.designRootOccurrence)
                or len(getValidOccurrences(cam.designRootOccurrence)) > 0
            )
        else:
            models = getValidOccurrences(manufacturingModel.occurrence)
            validModel = len(models) > 0

        manufacturingModelTask.updateUI()

        if not validModel:
            CAMFunctionContext.fail(
                message="Error creating additive setup:",
                error="No available components exist to select as the Models of the setup.",
            )
            return False

        if not manufacturingModel:
            manufacturingModel = createManufacturingModel(
                cam=cam,
                task=manufacturingModelTask,
            )
            models = getValidOccurrences(manufacturingModel.occurrence)

    # Fill in the SetupInput with the inputs for an additive setup
    with task.makeSubTask(progressRange=(95, 100)):
        setupInput.machine = machine
        setupInput.printSetting = printSetting
        setupInput.models = models

        # DED machines require the Stock solids to be set
        if additiveTechnology == "DED":
            setupInput.stockSolids = models

    if printSetting is not None:
        CAMFunctionContext.succeed(
            message=f"Selected the '{machine.model}' machine and '{printSetting.name}' print setting for the new additive setup with {additiveTechnology} technology."
        )
    else:
        CAMFunctionContext.succeed(
            message=f"Selected the '{machine.model}' machine for the new additive setup with {additiveTechnology} technology."
        )

    return True


def setTurningSetup(
    cam: adsk.cam.CAM,
    modelInputMode: ModelInputMode,
    setupInput: adsk.cam.SetupInput,
) -> bool:
    """
    Helper function to set the inputs for a new turning setup.
    """

    # Turning setups require a valid model
    #
    # If the model input mode is "none", then the model inputs do not need to
    # be set but we still need to check that there is a valid model in the
    # scene to create the setup.
    #
    # Otherwise, the ModelInput object would have set up the models on the setup
    # input already.
    if modelInputMode == ModelInputMode.NONE:
        # If the model input mode is "none", then the model inputs do not need to
        # be set but we still need to check that there is a valid model in the
        # scene to create the setup.
        if not containsBodies(cam.designRootOccurrence):
            CAMFunctionContext.fail(
                message="Error setting turning setup:",
                error="No component has been added to the scene",
            )
            return False
    else:
        if len(setupInput.models) == 0:
            CAMFunctionContext.fail(
                message="Error setting turning setup:",
                error="No models have been set for the setup",
            )
            return False

    return True


def setCAMParameters(
    inputParameters: dict[str, any],
    camParameters: adsk.cam.CAMParameters,
    task: CAMFunctionTaskContext,
) -> list[str]:
    """
    Set the input parameters on the given CAM parameters collection.
    Values in the input are expressions to be set.
    Returns a list of parameters that raised an exception while setting.
    """

    warningParams: list[str] = []

    for i, (key, value) in enumerate(inputParameters.items()):
        task.updateTaskProgress(i, len(inputParameters))
        try:
            camParameters.itemByName(key).expression = value
        except Exception:
            warningParams.append(key)

    return warningParams


def createDrillOperation(
    setup: adsk.cam.Setup,
    tool: adsk.cam.Tool | None,
    holeGroup: adsk.cam.RecognizedHoleGroup,
    drillTipThroughBottom: bool,
) -> adsk.cam.Operation:
    """
    Create a drilling operation for the given hole group using the specified tool.
    If drillTipThroughBottom is True, the drill tip will go through the bottom of
    the hole. Otherwise, it will stop at the bottom of the hole.
    """

    # Select the hole faces to drill from the hole group, excluding flats
    faces: list[adsk.fusion.BRepFace] = []
    for hole in holeGroup:
        for i in range(hole.segmentCount):
            segment: adsk.cam.RecognizedHoleSegment = hole.segment(i)
            if segment.holeSegmentType != adsk.cam.HoleSegmentType.HoleSegmentTypeFlat:
                faces.extend(segment.faces)

    # Create the operation input for drilling
    input: adsk.cam.OperationInput = setup.operations.createInput("drill")
    input.parameters.itemByName(
        "drillTipThroughBottom"
    ).value.value = drillTipThroughBottom
    input.parameters.itemByName("breakThroughDepth").expression = "2 mm"
    input.parameters.itemByName("holeFaces").value.value = faces
    if tool:
        input.tool = tool

    # Create and return the drilling operation
    op: adsk.cam.Operation = setup.operations.add(input)
    return op


def createCounterboreMillOperation(
    setup: adsk.cam.Setup,
    tool: adsk.cam.Tool | None,
    holeGroup: adsk.cam.RecognizedHoleGroup,
) -> adsk.cam.Operation:
    """
    Create a counterbore milling operation for the given hole group using the
    specified tool.
    """

    # Select the counterbore bottom edge to mill
    edges: list[adsk.fusion.BRepEdge] = []
    for hole in holeGroup:
        # Find the first cylinder (skipping cone/chamfer)
        seg0: adsk.cam.RecognizedHoleSegment = hole.segment(0)
        seg1: adsk.cam.RecognizedHoleSegment = hole.segment(1)
        if seg0.holeSegmentType == adsk.cam.HoleSegmentType.HoleSegmentTypeCylinder:
            counterboreSegment: adsk.cam.RecognizedHoleSegment = seg0
        elif seg1.holeSegmentType == adsk.cam.HoleSegmentType.HoleSegmentTypeCylinder:
            counterboreSegment = seg1
        else:
            continue

        edge: adsk.fusion.BRepEdge | None = getHoleSegmentBottomEdge(counterboreSegment)
        if edge:
            edges.append(edge)

    # Create the operation input for counterbore milling
    input: adsk.cam.OperationInput = setup.operations.createInput("contour2d")
    input.parameters.itemByName("doLeadIn").expression = "false"
    input.parameters.itemByName("doRamp").expression = "true"
    input.parameters.itemByName("rampAngle").expression = "2 deg"
    input.parameters.itemByName("exit_verticalRadius").expression = "0 mm"
    input.parameters.itemByName("exit_radius").expression = "0 mm"
    if tool:
        input.tool = tool

    # Add each edge to the contours chains as separate selections, since they are owned by different holes
    holeSelection: adsk.cam.CadContours2dParameterValue = input.parameters.itemByName(
        "contours"
    ).value
    chains: adsk.cam.CurveSelections = holeSelection.getCurveSelections()

    for edge in edges:
        chain: adsk.cam.ChainSelection = chains.createNewChainSelection()
        chain.isReverted = boundarySelectionNeedsFlipping(edge)
        chain.inputGeometry = [edge]
    holeSelection.applyCurveSelections(chains)

    # Create and return the milling operation
    op: adsk.cam.Operation = setup.operations.add(input)
    return op


def createChamferOperation(
    setup: adsk.cam.Setup,
    tool: adsk.cam.Tool | None,
    holeGroup: adsk.cam.RecognizedHoleGroup,
) -> adsk.cam.Operation:
    """
    Create an operation for the top chamfer of the given hole group.
    """

    # Select the counterbore chamfer's bottom edge to mill
    edges: list[adsk.fusion.BRepEdge] = []
    for hole in holeGroup:
        # Index 0 is the chamfer segment
        firstSegment: adsk.cam.RecognizedHoleSegment = hole.segment(0)
        edge: adsk.fusion.BRepEdge | None = getHoleSegmentBottomEdge(firstSegment)
        if edge:
            edges.append(edge)

    # Create the operation input for chamfer milling
    input: adsk.cam.OperationInput = setup.operations.createInput("chamfer2d")
    input.parameters.itemByName("chamferClearance").expression = "0 mm"
    input.parameters.itemByName("chamferTipOffset").expression = "1 mm"
    input.parameters.itemByName("entry_distance").expression = "5 mm"
    if tool:
        input.tool = tool

    # Add each edge to the contours chains as separate selections, since they are owned by different holes
    holeSelection: adsk.cam.CadContours2dParameterValue = input.parameters.itemByName(
        "contours"
    ).value
    chains: adsk.cam.CurveSelections = holeSelection.getCurveSelections()

    for edge in edges:
        chain: adsk.cam.ChainSelection = chains.createNewChainSelection()
        chain.isReverted = True
        chain.inputGeometry = [edge]
    holeSelection.applyCurveSelections(chains)

    # Add to the setup
    op: adsk.cam.Operation = setup.operations.add(input)
    return op


def regenerateToolpaths(
    cam: adsk.cam.CAM,
    task: CAMFunctionTaskContext,
    operations: list[adsk.cam.Operation] | None = None,
    skipValid: bool = True,
) -> list[adsk.cam.Operation]:
    """
    Regenerate the toolpath(s) according to the provided arguments.

    :param operations: If provided, only these operations will be regenerated.
    :param skipValid: If True, only operations that are not valid will be regenerated.
                      If False, all operations will be regenerated.
                      Only applicable if operations is None.

    Returns a list of operations that were regenerated.
    """

    generatedOperations: list[adsk.cam.Operation] = []

    if operations is None:
        future: adsk.cam.GenerateToolpathFuture = cam.generateAllToolpaths(skipValid)
    else:
        future: adsk.cam.GenerateToolpathFuture = cam.generateToolpath(
            adsk.core.ObjectCollection.createWithArray(operations),
        )

    try:
        generatedOperations.extend(future.operations)

        while not future.isGenerationCompleted:
            task.updateTaskProgress(future.numberOfCompletedTasks, future.numberOfTasks)
            time.sleep(0.1)

    except Exception as e:
        # Gracefully handle "Generation not started" errors, re-raise other exceptions
        if "Generation not started" not in str(e):
            raise e

    # Return the generated operations
    return generatedOperations


def selectOperations(
    ui: adsk.core.UserInterface,
    operations: list[adsk.cam.Operation],
    task: CAMFunctionTaskContext,
):
    """
    Select the given operations in the CAM workspace.
    """

    ui.activeSelections.clear()

    if len(operations) == 0:
        return

    with task.makeSubTask(numberOfTasks=len(operations)) as selectTask:
        for i, operation in enumerate(operations):
            selectTask.updateTaskProgress(i, len(operations))
            ui.activeSelections.add(operation)


# Tool Library helpers
def getToolLibrary(
    toolLibraryDefinition: ToolLibraryDefinition,
    task: CAMFunctionTaskContext,
) -> adsk.cam.ToolLibrary | None:
    """
    Return a tool library from a tool library definition.
    """

    if not isNonEmptyString(toolLibraryDefinition.name):
        return None

    locationsToSearch: list[adsk.cam.LibraryLocations] = []
    libraryLocation = adsk.cam.LibraryLocations.LocalLibraryLocation
    match toolLibraryDefinition.type:
        case ToolLibraryType.SAMPLES:
            locationsToSearch.append(adsk.cam.LibraryLocations.Fusion360LibraryLocation)
        case ToolLibraryType.LOCAL:
            locationsToSearch.append(adsk.cam.LibraryLocations.LocalLibraryLocation)
        case ToolLibraryType.CLOUD:
            locationsToSearch.append(adsk.cam.LibraryLocations.CloudLibraryLocation)
        case ToolLibraryType.ALL:
            # Search both local and Sample libraries in that order
            locationsToSearch.append(adsk.cam.LibraryLocations.LocalLibraryLocation)
            locationsToSearch.append(adsk.cam.LibraryLocations.Fusion360LibraryLocation)
            locationsToSearch.append(adsk.cam.LibraryLocations.CloudLibraryLocation)
        case ToolLibraryType.DOCUMENT:
            # We should have already have grabbed the document library and set it in the tool library definition
            return toolLibraryDefinition.toolLibrary
        case _:
            return None

    if len(locationsToSearch) == 0:
        return None

    camManager = adsk.cam.CAMManager.get()
    libraryManager: adsk.cam.CAMLibraryManager = camManager.libraryManager
    toolLibraries: adsk.cam.ToolLibraries = libraryManager.toolLibraries

    with task.makeSubTask(numberOfTasks=len(locationsToSearch)) as searchTask:
        for i, libraryLocation in enumerate(locationsToSearch):
            with searchTask.makeSubTaskByIndex(index=i) as libraryTask:
                try:
                    libraryFolder = toolLibraries.urlByLocation(libraryLocation)
                    url = libraryFolder.join(f"{toolLibraryDefinition.name}.json")

                    # This can be a long operation, so we run it asynchronously and
                    # indeterminately increment the progress bar
                    async def worker() -> adsk.cam.ToolLibrary:
                        return toolLibraries.toolLibraryAtURL(url)

                    toolLibrary: adsk.cam.ToolLibrary = libraryTask.runAsyncWorker(
                        worker=worker
                    )
                    if toolLibrary:
                        return toolLibrary
                except Exception:
                    continue

    return None


def getToolsByQueryForAllLibraries(
    toolLibraryDefinition: ToolLibraryDefinition | None,
    addCriteriaToQueryFunction: Callable[[adsk.cam.ToolQuery], None],
    task: CAMFunctionTaskContext,
) -> list[adsk.cam.Tool]:
    """
    Get the tools that fulfill the given criteria searching through all types of libraries.
    The order of libraries is:
    - Local Library
    - Fusion Sample Tool Libraries
    - Document Library
    """
    for libraryType in TOOL_LIBRARY_SEARCH_PRIORITY:
        possibleToolLibraryDefinition = ToolLibraryDefinition(
            name=toolLibraryDefinition.name
            if toolLibraryDefinition and isNonEmptyString(toolLibraryDefinition.name)
            else None,
            type=libraryType,
            toolLibrary=toolLibraryDefinition.toolLibrary
            if toolLibraryDefinition
            else None,
        )
        tools = getToolsByQuery(
            toolLibraryDefinition=possibleToolLibraryDefinition,
            addCriteriaToQueryFunction=addCriteriaToQueryFunction,
            task=task,
        )
        if len(tools) > 0:
            return tools

    return []


def getToolsByQuery(
    toolLibraryDefinition: ToolLibraryDefinition | None,
    addCriteriaToQueryFunction: Callable[[adsk.cam.ToolQuery], None],
    task: CAMFunctionTaskContext,
) -> list[adsk.cam.Tool]:
    """
    Return the tools that match the given criteria from the specified tool definition.
    """

    # Define the query to find the tool by name
    query: adsk.cam.ToolQuery | None = None

    if toolLibraryDefinition:
        if toolLibraryDefinition.toolLibrary:
            query = toolLibraryDefinition.toolLibrary.createQuery()
        elif isNonEmptyString(toolLibraryDefinition.name):
            # If a tool library name is provided, try to get the library
            toolLibrary = getToolLibrary(
                toolLibraryDefinition=toolLibraryDefinition,
                task=task,
            )
            if toolLibrary is None:
                return []

            query = toolLibrary.createQuery()
        else:
            camManager = adsk.cam.CAMManager.get()
            libraryManager: adsk.cam.CAMLibraryManager = camManager.libraryManager
            toolLibraries: adsk.cam.ToolLibraries = libraryManager.toolLibraries
            match toolLibraryDefinition.type:
                case ToolLibraryType.ALL:
                    return getToolsByQueryForAllLibraries(
                        toolLibraryDefinition=toolLibraryDefinition,
                        addCriteriaToQueryFunction=addCriteriaToQueryFunction,
                        task=task,
                    )

                case ToolLibraryType.SAMPLES:
                    query = toolLibraries.createQuery(
                        adsk.cam.LibraryLocations.Fusion360LibraryLocation
                    )
                case ToolLibraryType.LOCAL:
                    query = toolLibraries.createQuery(
                        adsk.cam.LibraryLocations.LocalLibraryLocation
                    )
                case ToolLibraryType.CLOUD:
                    query = toolLibraries.createQuery(
                        adsk.cam.LibraryLocations.CloudLibraryLocation
                    )
                case ToolLibraryType.DOCUMENT:
                    if toolLibraryDefinition.toolLibrary is not None:
                        # We should have already grabbed the document library and set it in the tool definition
                        query = toolLibraryDefinition.toolLibrary.createQuery()

    else:
        # If no tool library definition is provided, search all tool libraries
        return getToolsByQueryForAllLibraries(
            toolLibraryDefinition=toolLibraryDefinition,
            addCriteriaToQueryFunction=addCriteriaToQueryFunction,
            task=task,
        )

    if query is None:
        return []

    addCriteriaToQueryFunction(query)

    # Get the query results
    #
    # This can be a long operation, so we run it asynchronously and
    # indeterminately increment the progress bar
    async def worker() -> list[adsk.cam.ToolQueryResult]:
        try:
            return query.execute()
        except Exception:
            return []

    results = task.runAsyncWorker(worker=worker)

    # Get the tools from the query
    tools: list[adsk.cam.Tool] = [result.tool for result in results]
    return tools


def getToolByName(
    toolDefinition: ToolDefinition,
    task: CAMFunctionTaskContext,
) -> adsk.cam.Tool | None:
    """
    Return a tool from the given tool definition by name.
    """
    if not isNonEmptyString(toolDefinition.name):
        # If no name is specified, return None
        return None

    def addCriteriaToQueryFunction(query: adsk.cam.ToolQuery):
        """
        Function to add criteria to the query.
        This is passed as a parameter to getToolsByQuery.
        """
        # Add criteria for tool description (name)
        query.criteria.add(
            "tool_description",
            adsk.core.ValueInput.createByString(toolDefinition.name),
        )

    # Get the tools from the query
    tools: list[adsk.cam.Tool] = getToolsByQuery(
        toolLibraryDefinition=toolDefinition.toolLibraryDefinition,
        addCriteriaToQueryFunction=addCriteriaToQueryFunction,
        task=task,
    )

    # Return the first tool that matches the name
    if len(tools) > 0:
        return tools[0]

    # If no tool was found, return None
    return None


def getFilteredTools(
    toolLibraryDefinition: ToolLibraryDefinition | None,
    task: CAMFunctionTaskContext,
    toolType: str | None = None,
    minDiameter: float | None = None,
    maxDiameter: float | None = None,
) -> list[adsk.cam.Tool]:
    """
    Return a list of tools from the given tool definition that match the given
    criteria. If no criteria are provided, all tools are returned.
    """

    def addCriteriaToQueryFunction(query: adsk.cam.ToolQuery):
        """
        Function to add criteria to the query.
        This is passed as a parameter to getToolsByQuery.
        """
        # Add criteria for tool type, if specified
        if toolType is not None:
            query.criteria.add(
                "tool_type", adsk.core.ValueInput.createByString(toolType)
            )

        # Add criteria for diameter, if specified
        if minDiameter is not None:
            query.criteria.add(
                "tool_diameter.min", adsk.core.ValueInput.createByReal(minDiameter)
            )
        if maxDiameter is not None:
            query.criteria.add(
                "tool_diameter.max", adsk.core.ValueInput.createByReal(maxDiameter)
            )

    return getToolsByQuery(
        toolLibraryDefinition=toolLibraryDefinition,
        addCriteriaToQueryFunction=addCriteriaToQueryFunction,
        task=task,
    )


def getToolsToMakeHole(
    hole: adsk.cam.RecognizedHole,
    holeAttributes: HoleAttributes,
    drillingToolLibraryDefinition: ToolLibraryDefinition | None,
    millingToolLibraryDefinition: ToolLibraryDefinition | None,
    task: CAMFunctionTaskContext,
) -> tuple[
    adsk.cam.Tool | None,
    adsk.cam.Tool | None,
    adsk.cam.Tool | None,
]:
    """
    Return a set of tools to be used to make the given hole.

    The tools are returned in the following order:
    - Drill tool (for drilling the hole)
    - Counterbore tool (for counterboring the hole, if applicable)
    - Chamfer tool (for chamfering the hole, if applicable)
    """

    # Ratios of the counterbore diameter to define minimum and maximum tools to cut the counterbore
    COUNTERBORE_TOOL_DIAMETER_RATIO_MIN: float = 1.00
    COUNTERBORE_TOOL_DIAMETER_RATIO_MAX: float = 1.25

    drillTool: adsk.cam.Tool | None = None
    counterboreTool: adsk.cam.Tool | None = None
    chamferTool: adsk.cam.Tool | None = None

    # Get features of the hole and what tools are needed
    drillingDiameter: float = -1.0
    counterboreRadius: float = -1.0
    needChamfer: bool = False

    if holeAttributes & HoleAttributes.SIMPLE:
        if holeAttributes & HoleAttributes.CHAMFER:
            # Simple hole with top chamfer
            drillingDiameter = hole.segment(1).bottomDiameter
            needChamfer = True
        else:
            # Simple hole
            drillingDiameter = hole.segment(0).bottomDiameter
    elif holeAttributes & HoleAttributes.COUNTERBORE:
        if holeAttributes & HoleAttributes.CHAMFER:
            # Counterbore hole with top chamfer
            drillingDiameter = hole.segment(3).bottomDiameter
            counterboreRadius = hole.segment(1).bottomDiameter / 2.0
            needChamfer = True
        else:
            # Counterbore hole
            drillingDiameter = hole.segment(2).bottomDiameter
            counterboreRadius = hole.segment(0).bottomDiameter / 2.0

    # Get drill tool matching the drilling diameter
    with task.makeSubTask(progressRange=(0, 40)) as drillToolTask:
        if drillingDiameter > 0:
            drillingTools: list[adsk.cam.Tool] = getFilteredTools(
                toolLibraryDefinition=drillingToolLibraryDefinition,
                toolType="drill",
                minDiameter=drillingDiameter,
                maxDiameter=drillingDiameter,
                task=drillToolTask,
            )
            drillTool = next(iter(drillingTools), None)

    # Get counterbore tool matching the counterbore diameter
    with task.makeSubTask(progressRange=(40, 80)) as counterboreToolTask:
        if counterboreRadius > 0:
            minToolDiameter: float = (
                counterboreRadius * COUNTERBORE_TOOL_DIAMETER_RATIO_MIN
            )
            maxToolDiameter: float = (
                counterboreRadius * COUNTERBORE_TOOL_DIAMETER_RATIO_MAX
            )

            counterboreTools: list[adsk.cam.Tool] = getFilteredTools(
                toolLibraryDefinition=millingToolLibraryDefinition,
                toolType="flat end mill",
                minDiameter=minToolDiameter,
                maxDiameter=maxToolDiameter,
                task=counterboreToolTask,
            )
            counterboreTool = next(iter(counterboreTools), None)

    # Get chamfer tool if required
    with task.makeSubTask(progressRange=(80, 100)) as chamferToolTask:
        if needChamfer:
            chamferToolDefinition = ToolDefinition(
                name="6mm x 45 Engraving Tool",
                toolLibraryDefinition=ToolLibraryDefinition(
                    toolLibrary=millingToolLibraryDefinition.toolLibrary
                    if millingToolLibraryDefinition
                    else None,
                    name=millingToolLibraryDefinition.name
                    if millingToolLibraryDefinition
                    else None,
                    type=millingToolLibraryDefinition.type
                    if millingToolLibraryDefinition
                    else None,
                ),
            )
            chamferTool = getToolByName(
                toolDefinition=chamferToolDefinition,
                task=chamferToolTask,
            )

    # Return the tools in the order: drilling, counterbore, chamfer
    return drillTool, counterboreTool, chamferTool


# Hole and Pocket Recognition helpers
def isCircularPocket(pocket: adsk.cam.RecognizedPocket) -> bool:
    """Returns true if this is a circular pocket (= a hole) made of boundaries with circular segments only"""
    isCircleFound: bool = False
    for boundary in pocket.boundaries:
        for segment in boundary:
            if segment.classType() == adsk.core.Circle3D.classType():
                isCircleFound = True
            else:
                return False

    return isCircleFound


def recognizePockets(
    collections: list[adsk.fusion.BRepBody | adsk.fusion.Occurrence],
    parentTask: CAMFunctionTaskContext,
) -> list[adsk.cam.RecognizedPocket]:
    """
    Recognize pockets (from top Z view) in bodies.
    Return a list of recognized pockets.
    """

    POCKET_SEARCH_VECTOR = adsk.core.Vector3D.create(0, 0, -1)

    bodies: list[adsk.fusion.BRepBody] = []

    for collection in collections:
        if isinstance(collection, adsk.fusion.BRepBody):
            bodies.append(collection)
        elif isinstance(collection, adsk.fusion.Occurrence):
            # If the occurrence has a BRepBody, add it to the list
            bRepBodies: adsk.fusion.BRepBodies = collection.bRepBodies
            bodies.extend([bRepBodies.item(i) for i in range(bRepBodies.count)])

    pockets: list[adsk.cam.RecognizedPocket] = []
    if len(bodies) == 0:
        return pockets

    with parentTask.makeSubTask(numberOfTasks=len(bodies)) as task:
        for i, body in enumerate(bodies):
            with task.makeSubTaskByIndex(index=i) as bodyTask:
                # Recognize pockets in the body using the search vector
                #
                # This can be a long operation, so we run it asynchronously and
                # indeterminately increment the progress bar
                async def worker() -> adsk.cam.RecognizedPockets:
                    return adsk.cam.RecognizedPocket.recognizePockets(
                        body,
                        POCKET_SEARCH_VECTOR,
                    )

                recognizedPockets = bodyTask.runAsyncWorker(worker=worker)

                for pocket in recognizedPockets:
                    if isCircularPocket(pocket):
                        pass  # ignore circular pockets
                    else:
                        pockets.append(pocket)
    return pockets


def recognizeHoleGroups(
    bodies: list[adsk.fusion.BRepBody],
    task: CAMFunctionTaskContext,
) -> adsk.cam.RecognizedHoleGroups:
    """
    Recognize hole groups in 'bodies'.
    Returns the collection of recognized hole groups.
    """

    # This can be a long operation, so we run it asynchronously and
    # indeterminately increment the progress bar
    async def worker() -> adsk.cam.RecognizedHoleGroups:
        recognizedHolesInput = adsk.cam.RecognizedHolesInput.create()
        return adsk.cam.RecognizedHoleGroup.recognizeHoleGroupsWithInput(
            bodies=bodies,
            input=recognizedHolesInput,
        )

    return task.runAsyncWorker(worker=worker)


def classifyHoleGroup(
    holeGroup: adsk.cam.RecognizedHoleGroup,
) -> HoleAttributes:
    """
    Examine the hole group and return a set of attributes that describe its
    profile and depth.

    Returns HoleAttributes(0) if the profile is not recognized.
    """

    referenceHole: adsk.cam.RecognizedHole = holeGroup.item(0)
    includeHole: bool = True

    if referenceHole.isThrough:
        attributes: HoleAttributes = HoleAttributes.THROUGH

        match referenceHole.segmentCount:
            case 1:  # Simple through hole
                attributes |= HoleAttributes.SIMPLE
            case 2:  # Simple through hole with top chamfer
                attributes |= HoleAttributes.SIMPLE | HoleAttributes.CHAMFER
            case 3:  # Counterbore through hole
                attributes |= HoleAttributes.COUNTERBORE
            case 4:  # Counterbore through hole with top chamfer
                attributes |= HoleAttributes.COUNTERBORE | HoleAttributes.CHAMFER
            case _:
                includeHole = False  # Unrecognized hole profile
    else:
        attributes: HoleAttributes = HoleAttributes.BLIND

        match referenceHole.segmentCount:
            case 2:  # Simple blind hole
                attributes |= HoleAttributes.SIMPLE
            case 3:  # Simple blind hole with top chamfer
                attributes |= HoleAttributes.SIMPLE | HoleAttributes.CHAMFER
            case 4:  # Counterbore blind hole
                attributes |= HoleAttributes.COUNTERBORE
            case 5:  # Counterbore blind hole with top chamfer
                attributes |= HoleAttributes.COUNTERBORE | HoleAttributes.CHAMFER
            case _:
                includeHole = False  # Unrecognized hole profile

    return attributes if includeHole else HoleAttributes(0)


def classifyHoleGroups(
    holeGroups: adsk.cam.RecognizedHoleGroups,
    task: CAMFunctionTaskContext,
) -> list[tuple[adsk.cam.RecognizedHoleGroup, HoleAttributes]]:
    """
    Classify the hole groups and return a list of tuples containing the hole
    group and its attributes.

    Each tuple contains:
    - adsk.cam.RecognizedHoleGroup: The recognized hole group
    - HoleAttributes: The attributes of the hole group (SIMPLE, COUNTERBORE,
      THROUGH, BLIND, CHAMFER)
    """

    classifiedHoles: list[tuple[adsk.cam.RecognizedHoleGroup, HoleAttributes]] = []

    for i, holeGroup in enumerate(holeGroups):
        task.updateTaskProgress(i, holeGroups.count)
        attributes: HoleAttributes = classifyHoleGroup(holeGroup)
        if attributes != HoleAttributes(0):
            classifiedHoles.append((holeGroup, attributes))

    return classifiedHoles


def getAppearanceByColorName(
    design: adsk.fusion.Design,
    name: str,
    color_code: tuple[int],
) -> adsk.core.Appearance | None:
    """Return a Fusion appearance from a color name. color_code is a tuple that defines the RGB code (0-255). Returns None if appearance cannot be created because of invalid color"""

    # Look for the color
    appearance: adsk.core.Appearance = design.appearances.itemByName(name)

    if not appearance:
        # first check if the color is valid
        try:
            color = adsk.core.Color.create(
                color_code[0], color_code[1], color_code[2], 255
            )
        except Exception:
            return None

        # get the application
        app: adsk.core.Application = design.parentDocument.parent

        # Get the existing Red appearance.
        fusionMaterials: adsk.core.MaterialLibrary = app.materialLibraries.itemById(
            "BA5EE55E-9982-449B-9D66-9F036540E140"
        )
        redAppearance: adsk.core.Appearance = fusionMaterials.appearances.itemById(
            "Prism-093"
        )
        # Copy it to the design, giving it a new name.
        appearance: adsk.core.Appearance = design.appearances.addByCopy(
            redAppearance, name
        )
        # Change the color of the default appearance to the provided one.
        theColor: adsk.core.ColorProperty = appearance.appearanceProperties.itemById(
            "opaque_albedo"
        )
        theColor.value = color

    return appearance


def colorFaces(
    app: adsk.core.Application,
    faces: list[adsk.fusion.BRepFace],
    appearance: adsk.core.Appearance,
    task: CAMFunctionTaskContext,
):
    """
    Color the given faces with the given appearance.
    """

    if len(faces) == 0:
        # If no faces are provided, return early
        return

    for i, face in enumerate(faces):
        task.updateTaskProgress(i, len(faces))

        # Set the appearance of the face
        face.appearance = appearance

    # Refresh the UI to apply the changes
    app.activeViewport.refresh()


# Milling holes in a setup
def millHoleGroup(
    setup: adsk.cam.Setup,
    holeGroup: adsk.cam.RecognizedHoleGroup,
    holeAttributes: HoleAttributes,
    drillingToolLibraryDefinition: ToolLibraryDefinition | None,
    millingToolLibraryDefinition: ToolLibraryDefinition | None,
    task: CAMFunctionTaskContext,
) -> list[adsk.cam.Operation]:
    """
    Create operations in the given setup for the holes in the given group.
    Operations will be created based on the hole attributes.
    Tools will be picked automatically from the given tool libraries.
    """

    assert holeAttributes & (HoleAttributes.SIMPLE | HoleAttributes.COUNTERBORE)

    referenceHole: adsk.cam.RecognizedHole = holeGroup.item(0)

    with task.makeSubTask(message="Finding tools", progressRange=(0, 40)) as toolTask:
        drill, counterbore, chamfer = getToolsToMakeHole(
            hole=referenceHole,
            holeAttributes=holeAttributes,
            drillingToolLibraryDefinition=drillingToolLibraryDefinition,
            millingToolLibraryDefinition=millingToolLibraryDefinition,
            task=toolTask,
        )

    operations: list[adsk.cam.Operation] = []

    numberOfOperations: int = sum(
        [
            True,  # Always drill the hole
            bool(holeAttributes & HoleAttributes.COUNTERBORE),
            bool(holeAttributes & HoleAttributes.CHAMFER),
        ]
    )

    opTask = task.makeSubTask(
        message="Creating operations",
        progressRange=(40, 100),
        numberOfTasks=numberOfOperations,
    )
    with opTask:
        # Drill hole at the bottom
        opTask.updateTaskProgress(len(operations), numberOfOperations)
        drillOp: adsk.cam.Operation = createDrillOperation(
            setup=setup,
            tool=drill,
            holeGroup=holeGroup,
            drillTipThroughBottom=bool(holeAttributes & HoleAttributes.THROUGH),
        )
        operations.append(drillOp)

        if holeAttributes & HoleAttributes.COUNTERBORE:
            # If the hole is a counterbore, create a counterbore operation for the
            # larger diameter hole above it
            opTask.updateTaskProgress(len(operations), numberOfOperations)
            counterboreOp: adsk.cam.Operation = createCounterboreMillOperation(
                setup=setup,
                tool=counterbore,
                holeGroup=holeGroup,
            )
            operations.append(counterboreOp)

        if holeAttributes & HoleAttributes.CHAMFER:
            # If the hole has a top chamfer, create a chamfer operation
            opTask.updateTaskProgress(len(operations), numberOfOperations)
            chamferOp: adsk.cam.Operation = createChamferOperation(
                setup=setup,
                tool=chamfer,
                holeGroup=holeGroup,
            )
            operations.append(chamferOp)

    return operations


def sketchLine(
    sketch: adsk.fusion.Sketch,
    startPoint: adsk.core.Point3D,
    endPoint: adsk.core.Point3D,
) -> adsk.fusion.SketchLine:
    """Sketch a straight line based on the starting and ending points"""
    lines: adsk.fusion.SketchLines = sketch.sketchCurves.sketchLines
    line: adsk.fusion.SketchLine = lines.addByTwoPoints(startPoint, endPoint)
    return line


def sketchTwoPointArc(
    sketch: adsk.fusion.Sketch,
    centerPoint: adsk.core.Point3D,
    startPoint: adsk.core.Point3D,
    sweepAngle: float,
    normal: adsk.core.Vector3D,
) -> adsk.fusion.SketchArc:
    """Sketch an arc based on center, radius and sweep angle"""
    arcs: adsk.fusion.SketchArcs = sketch.sketchCurves.sketchArcs
    arc: adsk.fusion.SketchArc = arcs.addByCenterStartSweep(
        centerPoint, startPoint, sweepAngle
    )
    arcNormal: adsk.core.Vector3D = arc.geometry.normal
    # Check whether the arc is drawn in the right direction
    if (
        not arcNormal.z - normal.z < 0.000001
        and arcNormal.y - normal.y < 0.000001
        and arcNormal.x - normal.x < 0.000001
    ):
        arc.deleteMe()
        arc = arcs.addByCenterStartSweep(centerPoint, startPoint, -sweepAngle)
    return arc


def sketchCircles(
    sketch: adsk.fusion.Sketch, centerPoint: adsk.core.Point3D, radius: float
) -> adsk.fusion.SketchCircle:
    """Create a circle based on the points"""
    circles: adsk.fusion.SketchCircles = sketch.sketchCurves.sketchCircles
    circle: adsk.fusion.SketchCircle = circles.addByCenterRadius(centerPoint, radius)
    return circle


def sketchNurbsCurve(sketch: adsk.fusion.Sketch, nurbsCurve: adsk.core.NurbsCurve3D):
    """Sketch a spline"""
    splines = sketch.sketchCurves.sketchFixedSplines.addByNurbsCurve(nurbsCurve)
    return splines


def drawSketchCurves(
    sketch: adsk.fusion.Sketch, boundary: list[adsk.core.Curve3D]
) -> None:
    """Create a sketch from given pocket boundary or island"""
    for segment in boundary:
        # Cast to get the actual segment type (casting returns None if the wrong object is passed)
        line3D = adsk.core.Line3D.cast(segment)
        arc3D = adsk.core.Arc3D.cast(segment)
        circle3D = adsk.core.Circle3D.cast(segment)
        ellipse3D = adsk.core.Ellipse3D.cast(segment)
        nurbsCurve3D = adsk.core.NurbsCurve3D.cast(segment)
        ellipticalArc3D = adsk.core.EllipticalArc3D.cast(segment)

        if line3D:
            startPoint: adsk.core.Point3D = line3D.startPoint
            endPoint: adsk.core.Point3D = line3D.endPoint
            sketchLine(sketch, startPoint, endPoint)
        elif arc3D:
            startPoint: adsk.core.Point3D = arc3D.startPoint
            centerPoint: adsk.core.Point3D = arc3D.center
            sweepAngle: float = arc3D.endAngle
            normal: adsk.core.Vector3D = arc3D.normal
            sketchTwoPointArc(sketch, centerPoint, startPoint, sweepAngle, normal)
        elif circle3D:
            centerPoint: adsk.core.Point3D = circle3D.center
            radius: float = circle3D.radius
            sketchCircles(sketch, centerPoint, radius)
        elif ellipse3D:
            nurbsCurve = ellipse3D.asNurbsCurve
            sketchNurbsCurve(sketch, nurbsCurve)
        elif nurbsCurve3D:
            sketchNurbsCurve(sketch, nurbsCurve3D)
        elif ellipticalArc3D:
            nurbsCurve = ellipticalArc3D.asNurbsCurve
            sketchNurbsCurve(sketch, nurbsCurve)
        else:
            classType = segment.classType()
            raise Exception("Unsupported curve type: " + classType)


def sketchPocketBoundary(
    component: adsk.fusion.Component, pocket: adsk.cam.RecognizedPocket
):
    """Create a sketch from the recognized pocket boundary under a component tree"""
    sketches = component.sketches
    sketch: adsk.fusion.Sketch = sketches.add(component.xYConstructionPlane)
    sketch.isVisible = False
    sketch.isComputeDeferred = True
    for boundary in pocket.boundaries:
        drawSketchCurves(sketch, boundary)
    for island in pocket.islands:
        drawSketchCurves(sketch, island)
    sketch.isComputeDeferred = False
    return sketch


def millPocket(
    operation_type: str,
    pocket: adsk.cam.RecognizedPocket,
    setup: adsk.cam.Setup,
    tool: adsk.cam.Tool,
    sketch: adsk.fusion.Sketch,
):
    input: adsk.cam.OperationInput = setup.operations.createInput(operation_type)
    if tool:
        input.tool = tool
    input.parameters.itemByName("doMultipleDepths").expression = "true"
    input.parameters.itemByName("maximumStepdown").expression = (
        str(round(pocket.depth / 2, 3) * 10) + " mm"
    )  # Divide total height by 2 to get 2 passes
    input.parameters.itemByName("topHeight_mode").expression = "'from contour'"
    input.parameters.itemByName("topHeight_offset").expression = (
        str(pocket.depth * 10) + " mm"
    )

    # Apply the sketch boundary to the operation input
    pocketSelection: adsk.cam.CadContours2dParameterValue = input.parameters.itemByName(
        "pockets"
    ).value
    chains: adsk.cam.CurveSelections = pocketSelection.getCurveSelections()
    chain: adsk.cam.SketchSelection = chains.createNewSketchSelection()
    chain.inputGeometry = [sketch]
    # chain.loopType = adsk.cam.LoopTypes.OnlyOutsideLoops
    chain.loopType = adsk.cam.LoopTypes.AllLoops
    chain.sideType = adsk.cam.SideTypes.AlwaysInsideSideType
    # chain.sideType = adsk.cam.SideTypes.StartInsideSideType
    pocketSelection.applyCurveSelections(chains)

    # Add to the setup
    op: adsk.cam.OperationBase = setup.operations.add(input)
    return [op]


def millPockets(
    operation_type: str,
    pockets: list[adsk.cam.RecognizedPocket],
    setup: adsk.cam.Setup,
    tool: adsk.cam.Tool,
    task: CAMFunctionTaskContext,
):
    """create operation in the given pockets, in a given setup with given tool"""
    modelItem: adsk.fusion.BRepBody | adsk.fusion.Occurrence = setup.models.item(0)
    component = None
    if type(modelItem) is adsk.fusion.BRepBody:
        component = modelItem.parentComponent
    elif type(modelItem) is adsk.fusion.Occurrence:
        component = modelItem.component
    else:
        CAMFunctionContext.warn(
            message="Warning milling pockets:",
            warning="Component is not a BRepBody or a Occurrence.",
        )
        return

    operations: list[adsk.cam.Operation] = []

    for i, pocket in enumerate(pockets):
        task.updateTaskProgress(i, len(pockets))
        sketch = sketchPocketBoundary(component, pocket)
        ops = millPocket(operation_type, pocket, setup, tool, sketch)
        operations.extend(ops)

    return operations


# Additive helpers
def getDefaultOrientationStudyParameters(
    additiveMachineType: adsk.cam.AdditiveTechnologies,
) -> dict[str, Any]:
    """
    Return the default parameters for a new additive orientation study in a
    setup using a machine of the given additive type.
    """

    # Determine if the default values of parameters should be SLA style as
    # opposed to FFF style
    useSLAStyleParams = additiveMachineType in [
        adsk.cam.AdditiveTechnologies.SLATechnology,
        adsk.cam.AdditiveTechnologies.BinderJettingTechnology,
        adsk.cam.AdditiveTechnologies.MFJTechnology,
        adsk.cam.AdditiveTechnologies.SLSTechnology,
    ]

    criticalAngle = "35 deg" if useSLAStyleParams else "45 deg"
    distanceToPlatform = "7 mm" if useSLAStyleParams else "0 mm"
    frameWidth = "0 mm" if useSLAStyleParams else "5 mm"
    ceilingClearance = "0 mm" if useSLAStyleParams else "5 mm"
    rankingSupportVolume = "'2'" if useSLAStyleParams else "'10'"
    rankingSupportArea = "'10'" if useSLAStyleParams else "'0'"
    rankingBoundingBoxVolume = "'0'" if useSLAStyleParams else "'2'"
    rankingPartHeight = "'0'" if useSLAStyleParams else "'6'"
    rankingCOGHeight = "'0'" if useSLAStyleParams else "'6'"

    orientation_params = {
        "optimizeOrientationSmallestRotation": "180 deg",
        "optimizeOrientationUsePreciseCalculation": "true",
        "optimizeOrientationCriticalAngle": criticalAngle,
        "optimizeOrientationDistanceToPlatform": distanceToPlatform,
        "optimizeOrientationMoveToCenter": "true",
        "optimizeOrientationFrameWidth": frameWidth,
        "optimizeOrientationCeilingClearance": ceilingClearance,
        "optimizeOrientationRankingSupportVolume": rankingSupportVolume,
        "optimizeOrientationRankingSupportArea": rankingSupportArea,
        "optimizeOrientationRankingBoundingBoxVolume": rankingBoundingBoxVolume,
        "optimizeOrientationRankingPartHeight": rankingPartHeight,
        "optimizeOrientationRankingCOGHeight": rankingCOGHeight,
    }

    return orientation_params


def createAutomaticOrientationStudy(
    cam: adsk.cam.CAM,
    setup: adsk.cam.Setup,
    orientationName: str | None,
    camParameters: dict[str, Any] | None,
    task: CAMFunctionTaskContext,
) -> list[adsk.cam.Operation]:
    """
    Create an automatic orientation study for each model occurrence in the
    given setup.

    If 'orientationName' is not an empty string, it will be used as the prefix
    of the new orientation studies (as "<name>: <occurrence_name>"). Otherwise,
    the prefix will be "Automatic Orientation: ".
    """

    # Collect the created orientations for this setup
    orientations: list[adsk.cam.Operation] = []

    # Activate the setup to find the active manufacturing model
    setup.activate()
    activeMfgModel = None
    for mfgModel in cam.manufacturingModels:
        if mfgModel.isActive:
            activeMfgModel = mfgModel
            break

    if activeMfgModel is None:
        # Error if there is no active manufacturing model
        CAMFunctionContext.fail(
            message="Error creating automatic orientation study:",
            error=f"No manufacturing model is active for '{setup.name}'.",
        )
        return orientations

    task.updatePercentageProgress(10)

    # Find all bodies and components for each model in the setup
    setupBodies = []
    setupComps = []
    models = setup.models
    for i in range(models.count):
        model_item = models.item(i)
        if model_item.objectType == adsk.fusion.Occurrence.classType():
            setupComps.append(model_item.component)
            validOccs = getValidOccurrences(model_item)
            for occ in validOccs:
                for k in range(occ.bRepBodies.count):
                    setupBodies.append(occ.bRepBodies.item(k))
        else:
            setupBodies.append(model_item)
            setupComps.append(model_item.parentComponent)

    task.updatePercentageProgress(30)

    # Find all occurrences from the mfg model that reference a component or a body in the setup
    occs = []
    mfgModelOccs = getValidOccurrences(activeMfgModel.occurrence)
    for occ in mfgModelOccs:
        if occ.component in setupComps:
            occs.append(occ)
            continue
        hasMatchedBody = any(
            b in setupBodies
            for b in [occ.bRepBodies.item(j) for j in range(occ.bRepBodies.count)]
        )
        if hasMatchedBody:
            occs.append(occ)

    if len(occs) == 0:
        CAMFunctionContext.fail(
            message="Error creating automatic orientation study:",
            error=f"No component has been added to the scene in '{setup.name}'.",
        )
        return orientations

    task.updatePercentageProgress(40)

    # Get the machine from the setup
    machine = setup.machine
    if machine is None:
        CAMFunctionContext.fail(
            message="Error creating automatic orientation study:",
            error=f"No machine found for '{setup.name}'.",
        )
        return orientations

    additiveType = machine.capabilities.additiveTechnology
    if additiveType == adsk.cam.AdditiveTechnologies.NATechnology:
        CAMFunctionContext.fail(
            message="Error creating automatic orientation study:",
            error=f"Machine '{machine.name}' is not an additive machine for '{setup.name}'.",
        )
        return orientations

    occsTask = task.makeSubTask(
        progressRange=(40, 100),
        numberOfTasks=len(occs),
    )
    with occsTask:
        # Create the automatic orientation study for each occurrence in the
        # active manufacturing model
        for i, occ in enumerate(occs):
            studyTask = occsTask.makeSubTaskByIndex(
                index=i,
                message=f"Creating orientation for '{occ.name}'",
                numberOfTasks=2,
            )
            with studyTask:
                operationInput = setup.operations.createInput("automatic_orientation")
                operationInput.isAutoCalculating = False
                orientationTarget = operationInput.parameters.itemByName(
                    "optimizeOrientationTarget"
                )
                orientationTarget.value.value = [occ]

                # Use provided name for the new orientation, or default to
                # "Automatic Orientation: <occurrence name>"
                if isNonEmptyString(orientationName):
                    operationInput.displayName = orientationName
                else:
                    operationInput.displayName = f"Automatic Orientation: {occ.name}"

                # Get the default values for parameters
                orientation_params = getDefaultOrientationStudyParameters(additiveType)

                # Override default values with CAMParameters if provided
                if camParameters:
                    orientation_params.update(camParameters)

                # Set parameters for the orientation study
                with studyTask.makeSubTaskByIndex(index=0) as paramTask:
                    warningParams = setCAMParameters(
                        inputParameters=orientation_params,
                        camParameters=operationInput.parameters,
                        task=paramTask,
                    )

                async def worker() -> adsk.cam.Operation:
                    return setup.operations.add(operationInput)

                with studyTask.makeSubTaskByIndex(index=1) as createTask:
                    orientation = createTask.runAsyncWorker(worker=worker)

                orientations.append(orientation)

                # Base success message, based on the name inputs
                if isNonEmptyString(orientationName):
                    successMessage = f"Created an automatic orientation study named '{orientation.name}' for the body '{occ.name}' in '{setup.name}'"
                else:
                    successMessage = f"Created an automatic orientation study named '{orientation.name}' in '{setup.name}'"

                # Log warnings or success
                if len(warningParams) > 0:
                    CAMFunctionContext.warn(
                        message=f"{successMessage} with warnings:",
                        warning=f"Cannot set parameter(s): {getListAsString(warningParams)}. It may imply that the parameter(s) do not exist for orientation studies.",
                    )
                else:
                    # If the orientation name is different from the actual name
                    # of the created orientation, interrupt the execution
                    if isNonEmptyString(orientationName) and orientation.name != orientationName:
                        CAMFunctionContext.blockFutureExecution(
                            warning=f"{successMessage} (instead of {orientationName})."
                        )
                    else:
                        CAMFunctionContext.succeed(
                            message=f"{successMessage}."
                        )

    return orientations
