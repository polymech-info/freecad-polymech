#! python

"""
Classes for handling model inputs to Manufacturing Advisor function calling
tools.

- Construct a ModelInput instance by calling extractModelInput() with a 'model'
  dictionary argument.
- The ModelInput mode is NONE if no models are to be added to the setup.
- Call attachModelToSetupInput() to attach the model input configuration to
  a SetupInput instance. This returns True if models were successfully added
  (or nothing added with CAMFunctionContext warnings, allowing setup creation
  to continue).
"""

from adsk.cam import CAM, SetupInput
from adsk.core import Selections, UserInterface
from adsk.fusion import BRepBody, Component, Design, Occurrence
from CAMFunctionContext import CAMFunctionContext
from CAMFunctionUtils import (
    ModelInputMode,
    areMatchingCaseInsensitiveNames,
    getManufacturingModelByName,
    getValidOccurrences,
)


class ModelInput:
    """
    Represents a model input configuration.
    """

    def __init__(
        self,
        mode: ModelInputMode,
        occurrenceName: str | None = None,
        manufacturingModelName: str | None = None,
    ):
        """
        Initializes a ModelInput instance.
        """
        self.mode: ModelInputMode = mode
        self.occurrenceName: str | None = occurrenceName
        self.manufacturingModelName: str | None = manufacturingModelName

    def attachModelToSetupInput(
        self,
        ui: UserInterface,
        cam: CAM,
        errorMessage: str,
        warningMessage: str,
        setupInput: SetupInput,
    ) -> bool:
        """
        Attaches the model input configuration to the given setup input.

        - Returns True if models were successfully added (or nothing added with
          CAMFunctionContext warnings, allowing setup creation to continue).
        - Returns False otherwise (with errors added to CAMFunctionContext).
        """
        match self.mode:
            case ModelInputMode.NONE:
                return True  # No models to add
            case ModelInputMode.ALL:
                return self._addAllOccurrences(
                    cam=cam,
                    setupInput=setupInput,
                )
            case ModelInputMode.NAMED:
                return self._addNamedOccurrence(
                    cam=cam,
                    errorMessage=errorMessage,
                    warningMessage=warningMessage,
                    setupInput=setupInput,
                )
            case ModelInputMode.MANUFACTURING_MODEL:
                return self._addManufacturingModelOccurrences(
                    cam=cam,
                    errorMessage=errorMessage,
                    setupInput=setupInput,
                )
            case ModelInputMode.ACTIVE_SELECTION:
                return self._addActiveSelectionOccurrences(
                    ui=ui,
                    errorMessage=errorMessage,
                    setupInput=setupInput,
                )

        return False

    @classmethod
    def _addAllOccurrences(
        cls,
        cam: CAM,
        setupInput: SetupInput,
    ) -> bool:
        """
        Adds all models to the setup input.

        This is done by getting access to the the root component of the CAM
        product. We can get this by getting the assembly context of the design
        root occurrence - but fall back to the design root occurrence for
        safety.
        """

        rootOccurrence: Occurrence = cam.designRootOccurrence
        camRootOccurrence: Occurrence = rootOccurrence.assemblyContext
        setupInput.models = (
            [camRootOccurrence] if camRootOccurrence else [rootOccurrence]
        )
        return True

    def _addNamedOccurrence(
        self,
        cam: CAM,
        errorMessage: str,
        warningMessage: str,
        setupInput: SetupInput,
    ) -> bool:
        """
        Adds a named occurrence to the setup input.

        - Returns True if the occurrence was found and added.
        - Returns True with a warning if the occurrence was not found.
        - Returns False with an error if the occurrence name was not provided.
        """

        if not self.occurrenceName:
            CAMFunctionContext.fail(
                message=errorMessage,
                error="Name is not provided",
            )
            return False

        target: BRepBody | Occurrence | None = self._findComponentOccurrenceOrBodyByName(
            occurrence=cam.designRootOccurrence,
            name=self.occurrenceName,
        )
        if not target:
            CAMFunctionContext.warn(
                message=warningMessage,
                warning=f"Occurrence with name '{self.occurrenceName}' does not exist.",
            )
            return True  # No bodies added, but not a failure

        setupInput.models = [target]
        return True

    def _addManufacturingModelOccurrences(
        self,
        cam: CAM,
        errorMessage: str,
        setupInput: SetupInput,
    ) -> bool:
        """
        Adds occurrences from a manufacturing model to the setup input.

        - Returns True if occurrences were found and added.
        - Returns False with an error if the manufacturing model name was not
          provided.
        - Returns False with an error if the manufacturing model was not found.
        - Returns False with an error if the manufacturing model has no valid
          occurrences.
        """

        if not self.manufacturingModelName:
            CAMFunctionContext.fail(
                message=errorMessage,
                error="Manufacturing model name is not provided.",
            )
            return False

        manufacturingModel = getManufacturingModelByName(
            cam=cam,
            name=self.manufacturingModelName,
        )
        if not manufacturingModel:
            CAMFunctionContext.fail(
                message=errorMessage,
                error=f"Manufacturing model '{self.manufacturingModelName}' not found.",
            )
            return False

        occs = getValidOccurrences(manufacturingModel.occurrence)
        if len(occs) == 0:
            CAMFunctionContext.fail(
                message=errorMessage,
                error=f"Manufacturing model '{manufacturingModel.name}' has no valid occurrences.",
            )
            return False

        setupInput.models = occs
        return True

    @classmethod
    def _addActiveSelectionOccurrences(
        cls,
        ui: UserInterface,
        errorMessage: str,
        setupInput: SetupInput,
    ) -> bool:
        """
        Adds occurrences from the active selection to the setup input.

        - Returns True if models were successfully added.
        - Returns False if no active selections were found (with errors added
          to CAMFunctionContext).
        - Returns True if no valid bodies or components were found in the
          active selection.
        """

        selections: Selections = ui.activeSelections
        if selections.count == 0:
            CAMFunctionContext.fail(
                message=errorMessage,
                error="No active selections found.",
            )
            return False

        selectedObjects = []
        for selection in selections:
            entity = selection.entity
            if isinstance(entity, (BRepBody, Occurrence)):
                selectedObjects.append(entity)

        if len(selectedObjects) == 0:
            CAMFunctionContext.warn(
                message=errorMessage,
                warning="No valid bodies or components found in active selections.",
            )
            return True  # No occurrences/bodies added from selection, but not a failure

        setupInput.models = selectedObjects
        return True

    @classmethod
    def _findBodyByName(cls, component: Component, name: str) -> BRepBody | None:
        """
        Finds a body by (case-insensitive) name within a component.
        """
        for body in component.bRepBodies:
            if areMatchingCaseInsensitiveNames(body.name, name):
                return body

        return None

    @classmethod
    def _findComponentOccurrenceOrBodyByName(
        cls,
        occurrence: Occurrence,
        name: str,
    ) -> BRepBody | Occurrence | None:
        """
        Find the occurrence of a component or a body by (case-insensitive) name
        within the given occurrence recursively.
        """

        component: Component = occurrence.component
        if areMatchingCaseInsensitiveNames(component.name, name):
            return occurrence

        body: BRepBody | None = cls._findBodyByName(component, name)
        if body:
            return body

        for childOccurrence in occurrence.childOccurrences:
            result = cls._findComponentOccurrenceOrBodyByName(
                occurrence=childOccurrence,
                name=name,
            )
            if result:
                return result

        return None


def extractModelInput(modelInputDict: dict | None) -> ModelInput:
    """
    Extracts a ModelInput instance from the given dictionary.

    Returns a ModelInput instance with mode NONE if the dictionary is invalid,
    or if the mode is invalid.
    """

    mode: ModelInputMode = ModelInputMode.NONE
    occurrenceName: str | None = None
    manufacturingModelName: str | None = None

    if isinstance(modelInputDict, dict):
        modeStr: str = modelInputDict.get("mode", "none")
        try:
            mode = ModelInputMode(modeStr)
        except ValueError:
            mode = ModelInputMode.NONE

        if mode != ModelInputMode.NONE:
            occurrenceName = modelInputDict.get("occurrence_name")
            manufacturingModelName = modelInputDict.get("manufacturing_model_name")

    return ModelInput(
        mode=mode,
        occurrenceName=occurrenceName,
        manufacturingModelName=manufacturingModelName,
    )
