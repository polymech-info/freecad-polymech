import re
import time

import adsk.cam
import adsk.core
import adsk.fusion
from CAMFunctionContext import CAMFunctionContext
from CAMFunctionTasks import CAMFunctionTaskManager
from CAMFunctionUtils import (
    HoleAttributes,
    areMatchingCaseInsensitiveNames,
    classifyHoleGroups,
    colorFaces,
    createAutomaticOrientationStudy,
    createManufacturingModel,
    designProduct,
    extractNameAndRegexEnabled,
    findAdditiveArrangeInSetup,
    findMatchingAdditiveSetups,
    findMatchingParents,
    findMatchingSetups,
    findMatchingSetupsByType,
    findObjectByName,
    getActionStringFromMode,
    getAppearanceByColorName,
    getListAsString,
    getManufacturingModelBRepBodies,
    getManufacturingModelByName,
    getToolByName,
    getToolLibrary,
    getValidOccurrences,
    hasMatchingCaseInsensitiveName,
    init,
    isNonEmptyString,
    millHoleGroup,
    millPockets,
    recognizeHoleGroups,
    recognizePockets,
    regenerateToolpaths,
    selectOperations,
    setAdditiveSetup,
    setCAMParameters,
    setTurningSetup,
)
from ModelInput import ModelInput, ModelInputMode, extractModelInput
from ToolDefinition import (
    ToolLibraryType,
    extractToolDefinition,
    extractToolLibraryDefinition,
)


@CAMFunctionContext.execute_if_unblocked
def set_milling_operation(
    mode: str,
    operation_name: dict | None = None,
    operation_type: str | None = None,
    parent_name: dict | None = None,
    tool_definition: dict | None = None,
    **kwargs,
):
    action: str = getActionStringFromMode(mode)

    with CAMFunctionTaskManager.nextTask(f"{action.capitalize()} operations") as task:
        _, _, _, _, cam = init()

        # Get the specifics of the input name arguments
        parent_name_str, parent_name_regex_enabled = extractNameAndRegexEnabled(parent_name)
        operation_name_str, operation_name_regex_enabled = extractNameAndRegexEnabled(operation_name)

        toolDefinition = extractToolDefinition(
            toolDefinitionInput=tool_definition, cam=cam
        )

        # Get the list of parent objects to work with
        foundParents, parents, _ = findMatchingParents(
            parentName=parent_name_str,
            regexEnabled=parent_name_regex_enabled,
            cam=cam,
            errorMessage=f"Error {action} operation:",
        )
        if not foundParents:
            return

        task.updateUI()

        # Get the tool library if provided
        toolLibraryDefinition = (
            toolDefinition.toolLibraryDefinition if toolDefinition else None
        )
        with task.makeSubTask("Finding library", progressRange=(0, 40)) as libraryTask:
            if toolLibraryDefinition and isNonEmptyString(toolLibraryDefinition.name):
                toolDefinition.toolLibraryDefinition.toolLibrary = getToolLibrary(
                    toolLibraryDefinition=toolLibraryDefinition,
                    task=libraryTask,
                )
                if toolLibraryDefinition.toolLibrary is None:
                    CAMFunctionContext.warn(
                        message=f"Warning {action} operation:",
                        warning=f"Tool library '{toolLibraryDefinition.name}' not found. Tool will not be set.",
                    )

        # Get the tool to set, if provided
        tool: adsk.cam.Tool | None = None
        toolMissingWarning: bool = False
        with task.makeSubTask("Finding tool", progressRange=(40, 50)) as toolTask:
            if toolDefinition:
                if not isNonEmptyString(toolDefinition.name):
                    if toolLibraryDefinition:
                        warningMsg = None
                        if isNonEmptyString(toolDefinition.toolLibraryDefinition.name):
                            warningMsg = f"Tool library '{toolDefinition.toolLibraryDefinition.name}'"
                        elif (
                            toolDefinition.toolLibraryDefinition.type
                            != ToolLibraryType.ALL
                        ):
                            warningMsg = f"Tool library type '{toolDefinition.toolLibraryDefinition.type.value}'"

                        if isNonEmptyString(warningMsg):
                            toolMissingWarning = True
                            CAMFunctionContext.warn(
                                message=f"Warning {action} operation:",
                                warning=f"{warningMsg} is specified but no tool name is provided. Tool will not be set.",
                            )
                else:
                    tool = getToolByName(
                        toolDefinition=toolDefinition,
                        task=toolTask,
                    )

                    if tool is None:
                        toolMissingWarning = True
                        CAMFunctionContext.warn(
                            message=f"Warning {action} operation:",
                            warning=f"Tool '{toolDefinition.name}' not found. Tool will not be set.",
                        )

        # Check something has been provided to update if updating
        if mode == "u":
            if (not tool) and ("CAMParameters" not in kwargs):
                # If a tool information was specified, but no tool was found,
                # we have already warned about it.
                if not toolMissingWarning:
                    CAMFunctionContext.warn(
                        message=f"Warning {action} operation:",
                        warning="No tool or parameters provided to update.",
                    )
                return

        # getting all required operations
        if mode == "x":
            if not isNonEmptyString(operation_type):
                CAMFunctionContext.fail(
                    message="Error creating operation:",
                    error=f"Operation type not specified for new operation in '{parents[0].name}'."
                )
                return

            # Check that the operation type refers to a valid strategy
            try:
                strategy = adsk.cam.OperationStrategy.createFromString(operation_type)
            except Exception:
                CAMFunctionContext.fail(
                    message="Error creating operation:",
                    error=f"Invalid operation type '{operation_type}' specified."
                )
                return

            createTask = task.makeSubTask(
                message="Creating operations",
                progressRange=(50, 100),
                numberOfTasks=len(parents)
            )
            with createTask:
                for i, parent in enumerate(parents):
                    with createTask.makeSubTaskByIndex(index=i, numberOfTasks=2) as opTask:
                        # Check if the strategy is compatible with the parent setup
                        # This check must be done by internal name
                        setup: adsk.cam.Setup = parent.parentSetup
                        compatibleStrategies: list[str] = [strategy.name for strategy in setup.operations.compatibleStrategies if strategy.isGenerationAllowed]
                        if strategy.name not in compatibleStrategies:
                            CAMFunctionContext.fail(
                                message="Error creating operation:",
                                error=f"{strategy.title} strategy not available in '{parent.name}'. It may imply that this operation requires the manufacturing extension, a feature flag, or does not exist."
                            )
                            return

                        # Create the operation
                        operationInput: adsk.cam.OperationInput = parent.operations.createInput(operation_type)
                        if isNonEmptyString(operation_name_str):
                            operationInput.displayName = operation_name_str
                        if tool is not None:
                            operationInput.tool = tool

                        warningParams = []
                        with opTask.makeSubTaskByIndex(index=0) as paramTask:
                            if "CAMParameters" in kwargs:
                                warningParams = setCAMParameters(
                                    inputParameters=kwargs["CAMParameters"],
                                    camParameters=operationInput.parameters,
                                    task=paramTask,
                                )

                        async def worker() -> adsk.cam.Operation:
                            return parent.operations.add(operationInput)

                        with opTask.makeSubTaskByIndex(index=1) as workerTask:
                            operation = workerTask.runAsyncWorker(worker=worker)

                        if len(warningParams) > 0:
                            CAMFunctionContext.warn(
                                message=f"Created the {strategy.title} operation named '{operation.name}' in '{parent.name}' with warnings:",
                                warning=f"Cannot set parameter(s): {getListAsString(warningParams)}. It may imply that the parameter(s) do not exist for this operation.",
                            )
                        else:
                            # If the operation name is different from the actual name of the created operation, interrupt the execution
                            if isNonEmptyString(operation_name_str) and operation_name_str != operation.name:
                                CAMFunctionContext.blockFutureExecution(
                                    warning=f"Created the {strategy.title} operation named '{operation.name}' in '{parent.name}' (instead of '{operation_name_str}')."
                                )
                            else:
                                CAMFunctionContext.succeed(message=f"Created the {strategy.title} operation named '{operation.name}' in '{parent.name}'.")

        elif mode == "u" or mode == "d":
            selectedOperations = []

            # Get all operations inside the selected setups that match the criteria
            def isCandidateOperation(operation: adsk.cam.Operation) -> bool:
                if isNonEmptyString(operation_name_str):
                    if not hasMatchingCaseInsensitiveName(
                        item=operation,
                        name=operation_name_str,
                        regexEnabled=operation_name_regex_enabled,
                    ):
                        return False
                if isNonEmptyString(operation_type):
                    if operation.strategy != operation_type:
                        return False
                return True

            for parent in parents:
                for operation in parent.operations:
                    if isCandidateOperation(operation):
                        selectedOperations.append(operation)

            task.updateUI()

            if len(selectedOperations) == 0:
                if parent_name_str is None:
                    CAMFunctionContext.fail(
                        message=f"Error {action} operation:",
                        error="Operation not found.",
                    )
                else:
                    CAMFunctionContext.fail(
                        message=f"Error {action} operation:",
                        error=f"Operation not found in '{parents[0].name}'.",
                    )
                return

            updateTask = task.makeSubTask(
                message=f"{action.capitalize()} operations",
                progressRange=(50, 100),
                numberOfTasks=len(selectedOperations),
            )
            with updateTask:
                for i, operation in enumerate(selectedOperations):
                    with updateTask.makeSubTaskByIndex(index=i) as operationTask:
                        operation_name_str = operation.name
                        if mode == "d":
                            parent_name = operation.parent.name
                            operation.deleteMe()
                            CAMFunctionContext.succeed(message=f"Deleted '{operation_name_str}' from '{parent_name}'.")
                        if mode == "u":
                            warningParams: list[str] = []
                            if "CAMParameters" in kwargs:
                                warningParams = setCAMParameters(
                                    inputParameters=kwargs["CAMParameters"],
                                    camParameters=operation.parameters,
                                    task=operationTask,
                                )

                            if tool is not None:
                                operation.tool = tool

                            if len(warningParams) > 0:
                                CAMFunctionContext.warn(
                                    message=f"Updated '{operation_name_str}' in '{operation.parent.name}' with warnings:",
                                    warning=f"Cannot set parameter(s): {getListAsString(warningParams)}. It may imply that the parameter(s) do not exist for this operation.",
                                )
                            else:
                                CAMFunctionContext.succeed(message=f"Updated '{operation_name_str}' in '{operation.parent.name}'.")


@CAMFunctionContext.execute_if_unblocked
def set_empty_toolpath(
    mode: str = "s",
    parent_name: dict | None = None,
    **kwargs,
):
    # Action verb according to the mode
    if mode == "s":
        action = "suppressing"
    elif mode == "d":
        action = "deleting"
    else:
        CAMFunctionContext.fail(message="Error setting empty toolpaths:", error="Invalid mode. Use 's' for suppressing or 'd' for deleting.")
        return

    with CAMFunctionTaskManager.nextTask(f"{action.capitalize()} toolpaths") as task:
        _, _, _, _, cam = init()

        # Get the specifics of the input name arguments
        parent_name_str, regex_enabled = extractNameAndRegexEnabled(parent_name)

        # Find parent objects matching the inputs
        foundParents, parents, selectingAllParents = findMatchingParents(
            parentName=parent_name_str,
            regexEnabled=regex_enabled,
            cam=cam,
            errorMessage=f"Error {action} empty toolpaths:",
        )
        if not foundParents:
            return

        task.updateUI()

        # Loop through the parents and find empty toolpaths, following the rules:
        # - Protected toolpaths are not modified
        # - A toolpath is considered empty if:
        #   - it is valid and has no moves (isToolpathValid and not hasToolpath)
        #   - it is not valid and has no moves
        #     (not isToolpathValid and operationState == NoToolpathOperationState)
        #
        # Toolpath can be suppressed if:
        # - it is not protected
        # - it is empty
        # - it is not suppressed
        #
        # Toolpath can be deleted if:
        # - it is not protected
        # - it is empty or suppressed
        #   in API documentation, "Toolpaths do not exist for suppressed operations."
        #
        # Determine candidate toolpaths based on the mode
        def isCandidateOperation(operation):
            if operation.isProtected:
                return False

            isEmpty = (
                (operation.isToolpathValid and not operation.hasToolpath) or
                (not operation.isToolpathValid and operation.operationState == adsk.cam.OperationStates.NoToolpathOperationState)
            )
            if mode == "s":
                return isEmpty and not operation.isSuppressed
            elif mode == "d":
                return isEmpty or operation.isSuppressed
            else:
                return False

        emptyToolpaths = []
        for parent in parents:
            operations = parent.operations
            for i in range(operations.count):
                operation = operations.item(i)
                if isCandidateOperation(operation):
                    emptyToolpaths.append(operation)

        # If no empty toolpaths are found, show a warning as there is nothing to do
        if len(emptyToolpaths) == 0:
            if selectingAllParents:
                CAMFunctionContext.warn(message=f"Warning {action} empty toolpaths:", warning="No empty toolpaths found.")
            else:
                for parent in parents:
                    CAMFunctionContext.warn(
                        message=f"Warning {action} empty toolpaths:",
                        warning=f"No empty toolpaths found in '{parent.name}'.",
                    )
            return

        # Perform the action on the empty toolpaths
        for i, operation in enumerate(emptyToolpaths):
            task.updateTaskProgress(i, len(emptyToolpaths))
            name = operation.name
            parentName = operation.parent.name
            if mode == "s":
                operation.isSuppressed = True
                CAMFunctionContext.succeed(message=f"Suppressed empty toolpath '{name}' in '{parentName}'.")
            elif mode == "d":
                operation.deleteMe()
                CAMFunctionContext.succeed(message=f"Deleted empty toolpath '{name}' in '{parentName}'.")


@CAMFunctionContext.execute_if_unblocked
def protect_toolpath(
    parent_name: dict | None = None,
    **kwargs,
):
    with CAMFunctionTaskManager.nextTask("Protecting toolpaths") as task:
        _, _, _, _, cam = init()

        # Get the specifics of the input name arguments
        parent_name_str, regex_enabled = extractNameAndRegexEnabled(parent_name)

        # Get the scope of parent objects that we want to look for toolpaths to protect
        foundParents, parents, selectingAllParents = findMatchingParents(
            parentName=parent_name_str,
            regexEnabled=regex_enabled,
            cam=cam,
            errorMessage="Error protecting toolpaths:",
        )
        if not foundParents:
            return

        task.updateUI()

        # Check that the parent setups are applicable for protection
        def isApplicableSetupType(parent):
            setup: adsk.cam.Setup = parent.parentSetup
            return setup.parameters.itemByName("job_type").expression in ["'milling'", "'turning'", "'jet'"]

        nonApplicableParents = [parent for parent in parents if not isApplicableSetupType(parent)]
        for parent in nonApplicableParents:
            CAMFunctionContext.warn(
                message="Warning protecting toolpaths:",
                warning=f"Toolpath(s) in '{parent.name}' are not supported for protection.",
            )

        # Loop through the applicable parent objects and find toolpaths with no warnings or errors, and are not protected
        applicableParents = [parent for parent in parents if isApplicableSetupType(parent)]
        if len(applicableParents) == 0:
            # No applicable parents found, which has already been warned about
            return

        task.updateUI()

        def isCandidateOperation(operation):
            return not operation.hasWarning and not operation.hasError and not operation.isProtected

        toolpathsToProtect = []
        for setup in applicableParents:
            operations = setup.operations
            for i in range(operations.count):
                operation = operations.item(i)
                if isCandidateOperation(operation):
                    toolpathsToProtect.append(operation)

        # If no toolpaths are found that don't have problems, show a warning as there is nothing to do
        if len(toolpathsToProtect) == 0:
            if selectingAllParents:
                CAMFunctionContext.warn(message="Warning protecting toolpaths:", warning="No applicable toolpaths found.")
            else:
                for setup in parents:
                    CAMFunctionContext.warn(
                        message="Warning protecting toolpaths:",
                        warning=f"No applicable toolpaths found in '{setup.name}'.",
                    )
            return

        # Perform the action on the applicable toolpaths
        for i, operation in enumerate(toolpathsToProtect):
            task.updateTaskProgress(i, len(toolpathsToProtect))
            operation.isProtected = True
            CAMFunctionContext.succeed(message=f"Protected toolpath '{operation.name}' in '{operation.parent.name}'.")


@CAMFunctionContext.execute_if_unblocked
def regenerate_toolpath(
    mode: str = "invalid",
    select_toolpaths: bool = False,
    **kwargs,
):
    # Check mode argument, and determine the target string accordingly
    if mode == "invalid":
        targetStr = "all invalid toolpaths"
    elif mode == "all":
        targetStr = "all toolpaths"
    else:
        CAMFunctionContext.fail(
            message="Error regenerating toolpaths:",
            error="Invalid mode. Use 'invalid' for invalid toolpaths or 'all' for all toolpaths.",
        )
        return

    with CAMFunctionTaskManager.nextTask("Regenerating toolpaths") as task:
        _, ui, _, _, cam = init()

        # Generate all toolpaths, getting the list of operations that were generated
        regenRange = (0, 90 if select_toolpaths else 100)
        with task.makeSubTask(progressRange=regenRange) as regenTask:
            operations: list[adsk.cam.Operation] = regenerateToolpaths(
                cam=cam,
                task=regenTask,
                skipValid=mode == "invalid",
        )

        if select_toolpaths:
            # Select all generated toolpaths
            with task.makeSubTask("Selecting toolpaths", progressRange=(90, 100)) as selectTask:
                selectOperations(ui=ui, operations=operations, task=selectTask)

        actionStr = "Regenerated and selected" if select_toolpaths else "Regenerated"

        CAMFunctionContext.succeed(message=f"{actionStr} {targetStr}.")


@CAMFunctionContext.execute_if_unblocked
def set_tool(old_tool_number, new_tool_number):
    with CAMFunctionTaskManager.nextTask(message="Setting tool") as task:
        _, _, _, _, cam = init()

        if cam.setups.count < 1:
            CAMFunctionContext.fail(
                message="Error setting tool:",
                error="No setups available.",
            )
            return

        if cam.allOperations.count < 1:
            CAMFunctionContext.fail(
                message="Error setting tool:",
                error="No operations available.",
            )
            return

        # Look for the new tool in document tool library
        tool_lib = cam.documentToolLibrary
        new_tool = None
        with task.makeSubTask("Finding tool", progressRange=(0, 10)) as findToolTask:
            for i, tool in enumerate(tool_lib):
                findToolTask.updateTaskProgress(i, tool_lib.count)
                toolNumber = tool.parameters.itemByName("tool_number").value.value
                if toolNumber == new_tool_number:
                    new_tool = tool
                    break

        # Error handling for if the new tool isn't found
        if not new_tool:
            CAMFunctionContext.fail(
                message="Error setting tool:",
                error=f"Cannot find tool with tool number {new_tool_number}.",
            )
            return

        # Get all operations that use the old tool number
        operations = [
            op
            for op in cam.allOperations
            if op.tool.parameters.itemByName("tool_number").value.value
            == old_tool_number
        ]
        if len(operations) == 0:
            CAMFunctionContext.warn(
                message="Warning setting tool:",
                warning=f"No operations found using tool number {old_tool_number}.",
            )
            return

        # Replace old tool with new tool in all operations
        # Note that this will make old toolpaths invalid, and they will need to be regenerated
        with task.makeSubTask("Setting tool", progressRange=(10, 100)) as setToolTask:
            for i, op in enumerate(operations):
                setToolTask.updateTaskProgress(i, len(operations))
                toolNumber = op.tool.parameters.itemByName("tool_number").value.value
                if toolNumber == old_tool_number:
                    op.tool = new_tool
                    CAMFunctionContext.succeed(message=f"Set tool number {old_tool_number} to {new_tool_number} in operation '{op.name}'.")


@CAMFunctionContext.execute_if_unblocked
def set_setup(
    operation_type: adsk.cam.OperationTypes,
    setup_name: dict | None = None,
    mode: str = "x",
    additive_technology: str | None = None,
    model: dict | None = None,
    **kwargs,
):
    action: str = getActionStringFromMode(mode)

    with CAMFunctionTaskManager.nextTask(f"{action.capitalize()} setup") as task:
        _, ui, _, _, cam = init()

        # Get the specifics of the input name arguments
        setup_name_str, regex_enabled = extractNameAndRegexEnabled(setup_name)

        # Get the model inputs from the optional argument
        modelInput: ModelInput = extractModelInput(model)

        # select setups
        setups = []
        if mode == "d" or mode == "u":
            if operation_type != -1:
                foundSetups, setups, _ = findMatchingSetupsByType(
                    setupName=setup_name_str,
                    regexEnabled=regex_enabled,
                    cam=cam,
                    operationType=operation_type,
                    errorMessage=f"Error {action} setup:",
                )
            else:
                foundSetups, setups, _ = findMatchingSetups(
                    setupName=setup_name_str,
                    regexEnabled=regex_enabled,
                    cam=cam,
                    errorMessage=f"Error {action} setup:",
                )

            if not foundSetups:
                return

        if mode == "u" and "CAMParameters" not in kwargs:
            CAMFunctionContext.fail(
                message=f"Error {action} setup:",
                error="No parameters are updated.",
            )
            return

        if mode == "d":  # delete
            for i, setup in enumerate(setups):
                task.updateTaskProgress(i, len(setups))
                name = setup.name
                setup.deleteMe()
                CAMFunctionContext.succeed(message=f"Deleted '{name}'.")

        elif mode == "u":  # update
            with task.makeSubTask(numberOfTasks=len(setups)) as paramTask:
                for i, setup in enumerate(setups):
                    with paramTask.makeSubTaskByIndex(i, message=f"Updating '{setup.name}'") as setTask:
                        warningParams = setCAMParameters(
                            inputParameters=kwargs["CAMParameters"],
                            camParameters=setup.parameters,
                            task=setTask,
                        )

                    if len(warningParams) > 0:
                        CAMFunctionContext.warn(
                            message=f"Updated '{setup.name}' with warnings:",
                            warning=f"Cannot set parameter(s): {getListAsString(warningParams)}. It may imply that the parameter(s) do not exist for this setup.",
                        )
                    else:
                        CAMFunctionContext.succeed(message=f"Updated '{setup.name}'.")

        elif mode == "x":  # create
            setupInput = cam.setups.createInput(operation_type)

            # Fusion will take care of setup name if it doesn't exist
            if isNonEmptyString(setup_name_str):
                setupInput.name = setup_name_str

            # Allow up to 60% in case of creating an additive setup
            inputTask = task.makeSubTask(
                message="Gathering inputs",
                progressRange=(0, 60),
            )
            with inputTask:
                # Set the model inputs if provided
                if not modelInput.attachModelToSetupInput(
                    ui=ui,
                    cam=cam,
                    errorMessage=f"Error {action} setup:",
                    warningMessage=f"Warning {action} setup:",
                    setupInput=setupInput,
                ):
                    return

                # Set additional inputs for specific operation types
                if operation_type == adsk.cam.OperationTypes.TurningOperation:
                    if not setTurningSetup(
                        cam=cam,
                        modelInputMode=modelInput.mode,
                        setupInput=setupInput,
                    ):
                        return
                elif operation_type == adsk.cam.OperationTypes.AdditiveOperation:
                    # Machine, print setting, and models are required for additive setups
                    if not setAdditiveSetup(
                        cam=cam,
                        additiveTechnology=additive_technology,
                        manufacturingModelName=modelInput.manufacturingModelName,
                        setupInput=setupInput,
                        task=inputTask,
                    ):
                        return

            # Create the setup
            with task.makeSubTask(progressRange=(60, 90)) as createTask:
                async def worker() -> adsk.cam.Setup:
                    return cam.setups.add(setupInput)

                setup = createTask.runAsyncWorker(worker=worker)

            setups.append(setup)

            # Set CAM parameters if provided
            #
            # This is purposefully done after the setup is created as many
            # parameters relating to stock will fail to be validated in the
            # setup inputs if some of them are missing/have default values
            warningParams: list[str] = []
            with task.makeSubTask(progressRange=(90, 100)) as paramTask:
                if "CAMParameters" in kwargs:
                    warningParams = setCAMParameters(
                        inputParameters=kwargs["CAMParameters"],
                        camParameters=setup.parameters,
                        task=paramTask,
                    )

            if isNonEmptyString(setup_name_str) and setup_name_str != setup.name:
                CAMFunctionContext.blockFutureExecution(
                    warning=f"Created '{setup.name}' instead of '{setup_name_str}'.",
                )

            if len(warningParams) > 0:
                CAMFunctionContext.warn(
                    message=f"Created '{setup.name}' with warnings:",
                    warning=f"Cannot set parameter(s): {getListAsString(warningParams)}. It may imply that the parameter(s) do not exist for this setup.",
                )
            else:
                CAMFunctionContext.succeed(message=f"Created '{setup.name}'.")


@CAMFunctionContext.execute_if_unblocked
def set_additive_arrange(
    setup_name: dict | None = None,
    mode: str = "x",
    **kwargs,
):
    action: str = getActionStringFromMode(mode)

    with CAMFunctionTaskManager.nextTask(message=f"{action.capitalize()} arrange") as task:
        _, _, _, _, cam = init()

        # Get the specifics of the input name arguments
        setup_name_str, regex_enabled = extractNameAndRegexEnabled(setup_name)

        # Select additive setups to work with
        foundSetups, setups = findMatchingAdditiveSetups(
            setupName=setup_name_str,
            regexEnabled=regex_enabled,
            cam=cam,
            errorMessage=f"Error {action} additive arrange:",
        )
        if not foundSetups:
            return

        task.updateUI()

        # Get all additive arranges inside the selected setups
        # This is a list of (setup, arrange) tuples, where arrange is None if
        # no arrange is found in the setup
        setupArranges = [(setup, findAdditiveArrangeInSetup(setup)) for setup in setups]

        # List of existing arranges, which will be used for deletion or update
        existingArranges = [arrange for _, arrange in setupArranges if arrange is not None]

        # List of setups that do not have an arrange, which will be used for creation
        setupsWithoutArranges = [setup for setup, arrange in setupArranges if arrange is None]

        task.updateUI()

        if (mode == "u" or mode == "d") and len(existingArranges) == 0:
            CAMFunctionContext.fail(
                message=f"Error {action} additive arrange:",
                error="No additive arrange found in the selected setups.",
            )
            return

        if mode == "u" and "CAMParameters" not in kwargs:
            CAMFunctionContext.fail(
                message="Error updating additive arrange:",
                error="No parameters are updated.",
            )
            return

        if mode == "d": # delete
            for i, arrange in enumerate(existingArranges):
                task.updateTaskProgress(i, len(existingArranges))
                parentSetup = arrange.parentSetup
                arrange.deleteMe()
                CAMFunctionContext.succeed(message=f"Deleted additive arrange for '{parentSetup.name}'.")
            return

        # Determine the number of shared steps to perform for the task mode
        numberOfNewArranges: int = 0
        numberOfUpdatingArranges: int = 0
        if mode == "x":  # create
            numberOfNewArranges = len(setupsWithoutArranges)
            if "CAMParameters" in kwargs:
                numberOfUpdatingArranges = numberOfNewArranges
        elif mode == "u":  # update, and we know there are CAMParameters
            numberOfUpdatingArranges = len(existingArranges)

        numberOfSteps: int = numberOfNewArranges + numberOfUpdatingArranges

        with task.makeSubTask(numberOfTasks=numberOfSteps) as arrangeTask:
            arrangesToUpdate = []
            if mode == "x": # create
                for i, setup in enumerate(setupsWithoutArranges):
                    with arrangeTask.makeSubTaskByIndex(index=i, message="Creating arrange") as createTask:
                        operationInput = setup.operations.createInput('additive_arrange')
                        arrange = setup.operations.add(operationInput)
                        arrangesToUpdate.append(arrange)
                        CAMFunctionContext.succeed(message=f"Created additive arrange for '{setup.name}'.")
            elif mode == "u": # update
                arrangesToUpdate = existingArranges

            if (mode == "u" or mode == "x") and "CAMParameters" in kwargs:
                for i, arrange in enumerate(arrangesToUpdate):
                    updateTask = arrangeTask.makeSubTaskByIndex(
                        index=i + numberOfNewArranges,
                        message=f"Updating '{arrange.name}'",
                    )
                    with updateTask:
                        warningParams = setCAMParameters(
                            inputParameters=kwargs["CAMParameters"],
                            camParameters=arrange.parameters,
                            task=updateTask,
                        )

                        updatedOrCreated = "Updated" if mode == "u" else "Created"
                        if len(warningParams) > 0:
                            CAMFunctionContext.warn(
                                message=f"{updatedOrCreated} '{arrange.name}' with warnings:",
                                warning=f"Cannot set parameter(s): {getListAsString(warningParams)}. It may imply that the parameter(s) do not exist for this operation.",
                            )
                        else:
                            CAMFunctionContext.succeed(message=f"{updatedOrCreated} '{arrange.name}'.")


@CAMFunctionContext.execute_if_unblocked
def set_additive_orientation_study(
    mode: str,
    setup_name: dict | None = None,
    orientation_name: dict | None = None,
    **kwargs,
):
    action: str = getActionStringFromMode(mode)
    errorMessage = f"Error {action} automatic orientation study:"
    warningMessage = f"Warning {action} automatic orientation study:"

    with CAMFunctionTaskManager.nextTask(f"{action.capitalize()} study") as task:
        _, _, _, _, cam = init()

        # Get the specifics of the input name arguments
        setup_name_str, regex_enabled = extractNameAndRegexEnabled(setup_name)
        orientation_name_str, orientation_name_regex_enabled = extractNameAndRegexEnabled(orientation_name)

        # Find the additive setup(s) from setup_name in the document
        foundSetups, setups = findMatchingAdditiveSetups(
            setupName=setup_name_str,
            regexEnabled=regex_enabled,
            cam=cam,
            errorMessage=errorMessage,
        )
        if not foundSetups:
            return

        # Check something has been provided to update if updating
        if mode == "u":
            if not kwargs.get("CAMParameters"):
                CAMFunctionContext.warn(
                    message=warningMessage,
                    warning="No parameters provided to update.",
                )
                return

        # Collect the created/updated orientations so they can be
        # (re-)generated in one go
        orientations: list[adsk.cam.Operation] = []

        if mode == "x":
            # Create automatic orientation studies for each setup
            with task.makeSubTask(numberOfTasks=len(setups), progressRange=(0, 70)) as setupTask:
                for i, setup in enumerate(setups):
                    with setupTask.makeSubTaskByIndex(index=i) as studyTask:
                        createdOrientations = createAutomaticOrientationStudy(
                            cam=cam,
                            setup=setup,
                            orientationName=orientation_name_str,
                            camParameters=kwargs.get("CAMParameters"),
                            task=studyTask,
                        )
                        orientations.extend(createdOrientations)
        elif mode == "u" or mode == "d":
            # Collect existing orientation studies (with their setups) for
            # update/deletion from the respective Orientations container
            existingOrientations: list[tuple[adsk.cam.Setup, adsk.cam.Operation]] = []

            def isCandidateOrientation(orientation: adsk.cam.Operation) -> bool:
                if isNonEmptyString(orientation_name_str):
                    return hasMatchingCaseInsensitiveName(
                        item=orientation,
                        name=orientation_name_str,
                        regexEnabled=orientation_name_regex_enabled,
                    )
                return True

            for setup in setups:
                container: adsk.cam.CAMAdditiveContainer = setup.additiveContainerByType(
                    adsk.cam.CAMAdditiveContainerTypes.OptimizedOrientationCAMAdditiveContainerType
                )
                if container:
                    for operation in container.allOperations:
                        if isCandidateOrientation(operation):
                            existingOrientations.append((setup, operation))

            if len(existingOrientations) == 0:
                if setup_name_str is None:
                    CAMFunctionContext.fail(
                        message=errorMessage,
                        error="Orientation study not found in setups.",
                    )
                else:
                    CAMFunctionContext.fail(
                        message=errorMessage,
                        error=f"Orientation study not found in setup '{setups[0].name}'.",
                    )
                return

            if mode == "d":
                deleteTask = task.makeSubTask(progressRange=(0, 100), numberOfTasks=len(existingOrientations))
                with deleteTask:
                    for i, (setup, orientation) in enumerate(existingOrientations):
                        with deleteTask.makeSubTaskByIndex(index=i) as studyTask:
                            orientation_name_str = orientation.name
                            orientation.deleteMe()
                            CAMFunctionContext.succeed(
                                message=f"Deleted '{orientation_name_str}' from '{setup.name}'."
                            )
                return

            updateTask = task.makeSubTask(numberOfTasks=len(existingOrientations), progressRange=(0, 70))
            with updateTask:
                for i, (setup, orientation) in enumerate(existingOrientations):
                    orientations.append(orientation)
                    with updateTask.makeSubTaskByIndex(index=i) as studyTask:
                        warningParams = setCAMParameters(
                            inputParameters=kwargs["CAMParameters"],
                            camParameters=orientation.parameters,
                            task=studyTask,
                        )

                        if len(warningParams) > 0:
                            CAMFunctionContext.warn(
                                message=f"Updated '{orientation.name}' in '{setup.name}' with warnings:",
                                warning=f"Cannot set parameter(s): {getListAsString(warningParams)}. It may imply that the parameter(s) do not exist for this operation.",
                            )
                        else:
                            CAMFunctionContext.succeed(
                                message=f"Updated '{orientation.name}' in '{setup.name}'."
                            )

        # Generate all orientation studies
        if len(orientations) > 0:
            with task.makeSubTask(message="Generating orientations", progressRange=(70, 100)) as generateTask:
                regenerateToolpaths(
                    cam=cam,
                    operations=orientations,
                    task=generateTask,
                )


@CAMFunctionContext.execute_if_unblocked
def create_manufacturing_model(name:str = None):
    """
    Create a new manufacturing model, with given name if provided.

    Future CAM functions will be blocked if the model was created with a
    different name than the one provided.
    """
    with CAMFunctionTaskManager.nextTask("Creating manufacturing model") as task:
        _, _, _, _, cam = init()
        createManufacturingModel(cam=cam, name=name, task=task)


@CAMFunctionContext.execute_if_unblocked
def color_holes(manufacturing_model_name: str, color_name: str, color_code: tuple[int]):
    with CAMFunctionTaskManager.nextTask("Coloring holes") as task:
        app, _, _, _, cam = init()

        # Get the appearance
        appearance = getAppearanceByColorName(designProduct(), color_name, color_code)
        if appearance is None:
            CAMFunctionContext.fail(
                message="Error coloring holes:",
                error=f"Cannot create appearance with color {color_code}",
            )
            return

        task.updateUI()

        # Get the manufacturing model
        manufacturingModel = None
        with task.makeSubTask(message="Getting manufacturing model", progressRange=(0, 10)) as getModelTask:
            if isNonEmptyString(manufacturing_model_name):
                manufacturingModel = getManufacturingModelByName(cam, manufacturing_model_name)
                if manufacturingModel is None:
                    CAMFunctionContext.fail(
                        message="Error coloring holes:",
                        error=f"Manufacturing model '{manufacturing_model_name}' not found",
                    )
                    return
            elif cam.manufacturingModels.count > 0:
                manufacturingModel = cam.manufacturingModels.item(0)
            else:
                manufacturingModel = createManufacturingModel(cam=cam, task=getModelTask)

        # Get the Bodies from model
        manufacturingModelBody = getManufacturingModelBRepBodies(manufacturingModel)
        if len(manufacturingModelBody) == 0:
            CAMFunctionContext.warn(
                message="Warning coloring holes:",
                warning=f"No bodies found for '{manufacturingModel.name}'",
            )
            return

        task.updateUI()

        # Recognize holes
        with task.makeSubTask(progressRange=(10, 90), message="Recognizing holes") as recognizeTask:
            holeGroups: adsk.cam.RecognizedHoleGroups = recognizeHoleGroups(
                bodies=manufacturingModelBody,
                task=recognizeTask,
            )
        if holeGroups.count == 0:
            CAMFunctionContext.warn(message="Warning coloring holes:", warning=f"No holes found in the bodies of '{manufacturingModel.name}'")
            return

        # Collect the faces to color
        facesToColor: list[adsk.fusion.BRepFace] = [
            face
            for holeGroup in holeGroups
            for hole in holeGroup
            for i in range(hole.segmentCount)
            for face in hole.segment(i).faces
        ]
        task.updateUI()

        # Color the hole faces
        with task.makeSubTask(progressRange=(90, 100)) as colorTask:
            colorFaces(
                app=app,
                faces=facesToColor,
                appearance=appearance,
                task=colorTask,
            )

        CAMFunctionContext.succeed(f"Colored holes of '{manufacturingModel.name}' in {color_name}.")


@CAMFunctionContext.execute_if_unblocked
def color_pockets(manufacturing_model_name: str, color_name: str, color_code: tuple[float]):
    with CAMFunctionTaskManager.nextTask("Coloring pockets") as task:
        app, _, _, _, cam = init()

        # Get the appearance
        appearance = getAppearanceByColorName(designProduct(), color_name, color_code)
        if appearance is None:
            CAMFunctionContext.fail(
                message="Error coloring pockets:",
                error=f"Cannot create appearance with color {color_code}",
            )
            return

        task.updateUI()

        # Get the manufacturing model
        manufacturingModel = None
        with task.makeSubTask(message="Getting manufacturing model", progressRange=(0, 10)) as getModelTask:
            if isNonEmptyString(manufacturing_model_name):
                manufacturingModel = getManufacturingModelByName(cam, manufacturing_model_name)
                if manufacturingModel is None:
                    CAMFunctionContext.fail(
                        message="Error coloring pockets:",
                        error=f"Manufacturing model '{manufacturing_model_name}' not found",
                    )
                    return
            elif cam.manufacturingModels.count > 0:
                manufacturingModel = cam.manufacturingModels.item(0)
            else:
                manufacturingModel = createManufacturingModel(cam=cam, task=getModelTask)

        # Get the Bodies from model
        manufacturingModelBodies = getManufacturingModelBRepBodies(manufacturingModel)
        if len(manufacturingModelBodies) == 0:
            CAMFunctionContext.warn(message="Warning coloring pockets:", warning=f"No bodies found for '{manufacturingModel.name}'")
            return

        task.updateUI()

        # Recognize Pockets
        with task.makeSubTask(progressRange=(10, 90), message="Recognizing pockets") as recognizeTask:
            pockets: adsk.cam.RecognizedPockets = recognizePockets(
                collections=manufacturingModelBodies,
                parentTask=recognizeTask,
            )
        if len(pockets) == 0:
            CAMFunctionContext.warn(
                message="Warning coloring pockets:",
                warning=f"No pockets found in the bodies of '{manufacturingModel.name}'",
            )
            return

        # Collect the faces to color
        facesToColor: list[adsk.fusion.BRepFace] = [
            face for pocket in pockets for face in pocket.faces
        ]
        task.updateUI()

        # Color the pocket faces
        with task.makeSubTask(progressRange=(90, 100)) as colorTask:
            colorFaces(
                app=app,
                faces=facesToColor,
                appearance=appearance,
                task=colorTask,
            )

        CAMFunctionContext.succeed(f"Colored pockets of '{manufacturingModel.name}' in {color_name}.")


@CAMFunctionContext.execute_if_unblocked
def select_orientation_rank(
    setup_name: dict | None = None,
    rank: int = 1
):
    with CAMFunctionTaskManager.nextTask("Selecting results") as task:
        _, _, _, _, cam = init()

        if not isinstance(rank, int) or rank < 0:
            CAMFunctionContext.fail(
                message="Error selecting orientation result:",
                error=f"Invalid rank chosen: {rank}.",
            )
            return

        # Get the specifics of the input name arguments
        setup_name_str, regex_enabled = extractNameAndRegexEnabled(setup_name)

        # Find the additive setup(s) from setup_name in the document
        foundSetups, setups = findMatchingAdditiveSetups(
            setupName=setup_name_str,
            regexEnabled=regex_enabled,
            cam=cam,
            errorMessage="Error selecting orientation result:",
        )
        if not foundSetups:
            return

        # Select orientation results for each orientation study in each setup
        with task.makeSubTask(numberOfTasks=len(setups)) as setupsTask:
            for i, setup in enumerate(setups):
                operations = setup.allOperations

                orientations = []
                for operation in operations:
                    # if it is an operation of type 'automatic_orientation', add it to the list
                    if isinstance(operation, adsk.cam.Operation) and operation.strategy == 'automatic_orientation':
                        orientations.append(operation)

                if len(orientations) == 0:
                    CAMFunctionContext.fail(
                        message="Error selecting orientation result:",
                        error=f"No automatic orientation found in setup '{setup.name}'.",
                    )
                    return

                with setupsTask.makeSubTaskByIndex(index=i, numberOfTasks=len(orientations)) as setupTask:
                    for j, orientation in enumerate(orientations):
                        with setupTask.makeSubTaskByIndex(index=j, numberOfTasks=3) as orientationTask:
                            # Wait until the orientation study is generated
                            with orientationTask.makeSubTaskByIndex(index=0, message="Generating orientation"):
                                while orientation.isGenerating:
                                    time.sleep(0.1)

                                # Check if the orientation study is valid and the results exist
                                if orientation.operationState != adsk.cam.OperationStates.IsValidOperationState:
                                    CAMFunctionContext.fail(
                                        message="Error selecting orientation result:",
                                        error=f"No results available for selection in orientation study '{orientation.name}' in setup '{setup.name}'.",
                                    )
                                    continue

                            # Find the orientation results from the generated data collection
                            with orientationTask.makeSubTaskByIndex(index=1, message="Finding result"):
                                generatedData = orientation.generatedDataCollection
                                orientationResults = None
                                orientationResultsData = generatedData.itemByIdentifier(adsk.cam.GeneratedDataType.OptimizedOrientationGeneratedDataType)
                                if not isinstance(orientationResultsData, adsk.cam.OptimizedOrientationResults):
                                    CAMFunctionContext.fail(
                                        message="Error selecting orientation result:",
                                        error=f"No optimized orientation results found for '{orientation.name}' in setup '{setup.name}'.",
                                    )
                                    continue

                            # Select the orientation result by rank
                            with orientationTask.makeSubTaskByIndex(index=2, message="Selecting result"):
                                orientationResults: adsk.cam.OptimizedOrientationResults = orientationResultsData

                                if rank == 0:
                                    # Select the initial result if rank is 0
                                    orientationResults.currentOrientationResult = orientationResults.initialOrientationResult
                                    CAMFunctionContext.succeed(
                                        message=f"Selected the initial orientation for '{orientation.name}' in setup '{setup.name}'."
                                    )
                                else:
                                    # Select the orientation result by rank
                                    rankIndex = rank - 1
                                    if rankIndex >= orientationResults.count:
                                        CAMFunctionContext.fail(
                                            message="Error selecting orientation result:",
                                            error=f"Rank {rank} is not available for '{orientation.name}' in setup '{setup.name}'.",
                                        )
                                        continue

                                    orientationResults.currentOrientationResult = orientationResults.item(rankIndex)
                                    CAMFunctionContext.succeed(
                                        message=f"Selected the orientation result ranked {rank} for '{orientation.name}' in setup '{setup.name}'."
                                    )


@CAMFunctionContext.execute_if_unblocked
def create_drilling_operations_for_holes(
    setup_name: str,
    hole_type: str = "all",
    drilling_tool_library_definition: dict | None = None,
    milling_tool_library_definition: dict | None = None,
):
    """
    Create drilling operations for all/simple/counterbore holes in the
    specified setup.

    If tool libraries are provided, tools will be chosen from those libraries,
    otherwise the document tool library will be used.
    """

    with CAMFunctionTaskManager.nextTask("Drilling holes") as task:
        _, _, _, _, cam = init()

        drillingToolLibraryDefinition = extractToolLibraryDefinition(
            toolLibraryDefinitionInput=drilling_tool_library_definition, cam=cam
        )
        millingToolLibraryDefinition = extractToolLibraryDefinition(
            toolLibraryDefinitionInput=milling_tool_library_definition, cam=cam
        )

        # Validate the hole_type input
        if hole_type not in ["all", "simple", "counterbore"]:
            CAMFunctionContext.fail(
                message="Error creating drilling operations for holes:",
                error=f"Invalid hole type '{hole_type}'. Valid values are 'all', 'simple', or 'counterbore'."
            )
            return

        # Get the setup
        foundSetups, setups, _ = findMatchingSetups(
            setupName=setup_name,
            cam=cam,
            regexEnabled=False,
            errorMessage="Error creating drilling operations for holes:",
        )
        if not foundSetups:
            return

        task.updateUI()

        setup: adsk.cam.Setup = setups[0]

        # Get the tool libraries if specified, otherwise use the document tool library
        with task.makeSubTask(
            "Finding drilling library", progressRange=(0, 25)
        ) as drillLibraryTask:
            if drillingToolLibraryDefinition and isNonEmptyString(
                drillingToolLibraryDefinition.name
            ):
                drillingToolLibraryDefinition.toolLibrary = getToolLibrary(
                    toolLibraryDefinition=drillingToolLibraryDefinition,
                    task=drillLibraryTask,
                )
                if drillingToolLibraryDefinition.toolLibrary is None:
                    CAMFunctionContext.fail(
                        message="Error creating drilling operations for holes:",
                        error=f"Drilling tool library '{drillingToolLibraryDefinition.name}' not found.",
                    )
                    return

        with task.makeSubTask(
            "Finding milling library", progressRange=(25, 35)
        ) as millLibraryTask:
            if millingToolLibraryDefinition and isNonEmptyString(
                millingToolLibraryDefinition.name
            ):
                millingToolLibraryDefinition.toolLibrary = getToolLibrary(
                    toolLibraryDefinition=millingToolLibraryDefinition,
                    task=millLibraryTask,
                )
                if millingToolLibraryDefinition.toolLibrary is None:
                    CAMFunctionContext.fail(
                        message="Error creating drilling operations for holes:",
                        error=f"Milling tool library '{millingToolLibraryDefinition.name}' not found.",
                    )
                    return

        # Get the BRep bodies used by the setup
        setupBodies: list[adsk.fusion.BRepBody] = []
        for model in setup.models:
            if model.objectType == adsk.fusion.Occurrence.classType():
                # Include bodies in the model itself
                setupBodies.extend(body for body in model.bRepBodies)

                # Include bodies in the child occurrences of the model
                occs: list[adsk.fusion.Occurrence] = getValidOccurrences(model)
                setupBodies.extend(body for occ in occs for body in occ.bRepBodies)
            else:
                setupBodies.append(model)

        if len(setupBodies) == 0:
            CAMFunctionContext.fail(
                message="Error creating drilling operations for holes:",
                error=f"No bodies found in setup '{setup.name}'."
            )
            return

        # Recognize holes in the bodies
        with task.makeSubTask(progressRange=(35, 50), message="Recognizing holes") as recognizeTask:
            holeGroups: adsk.cam.RecognizedHoleGroups = recognizeHoleGroups(
                bodies=setupBodies,
                task=recognizeTask,
            )
        if holeGroups.count == 0:
            CAMFunctionContext.fail(
                message="Error creating drilling operations for holes:",
                error=f"No holes found in the bodies of setup '{setup.name}'."
            )
            return

        # Classify the holes by their profile and type
        with task.makeSubTask(progressRange=(50, 60), message="Classifying holes") as classifyTask:
            classifiedHoles: list[tuple[adsk.cam.RecognizedHoleGroup, HoleAttributes]] = classifyHoleGroups(
                holeGroups=holeGroups,
                task=classifyTask,
            )

        # Split into simple and counterbore hole groups into separate lists
        simpleHoles = [(hole, attrs) for hole, attrs in classifiedHoles if attrs & HoleAttributes.SIMPLE]
        counterboreHoles = [(hole, attrs) for hole, attrs in classifiedHoles if attrs & HoleAttributes.COUNTERBORE]

        createSimple: bool = hole_type in ["all", "simple"]
        createCounterbore: bool = hole_type in ["all", "counterbore"]

        numberOfSimpleHoles: int = 0
        if createSimple:
            numberOfSimpleHoles = len(simpleHoles)
            if numberOfSimpleHoles == 0:
                CAMFunctionContext.warn(
                    message="Warning creating drilling operations for holes:",
                    warning=f"No simple holes found in the bodies of setup '{setup.name}'."
                )

        numberOfCounterboreHoles: int = 0
        if createCounterbore:
            numberOfCounterboreHoles = len(counterboreHoles)
            if numberOfCounterboreHoles == 0:
                CAMFunctionContext.warn(
                message="Warning creating drilling operations for holes:",
                warning=f"No counterbore holes found in the bodies of setup '{setup.name}'."
            )

        numberOfHolesToMill: int = numberOfSimpleHoles + numberOfCounterboreHoles
        if numberOfHolesToMill == 0:
            # No holes to mill, exit early
            return

        with task.makeSubTask(progressRange=(60, 100), message="Creating operations", numberOfTasks=numberOfHolesToMill) as millTask:
            # Create drilling operations for simple holes
            if createSimple and len(simpleHoles) > 0:
                for i, (holeGroup, attrs) in enumerate(simpleHoles):
                    with millTask.makeSubTaskByIndex(index=i) as holeTask:
                        millHoleGroup(
                            setup=setup,
                            holeGroup=holeGroup,
                            holeAttributes=attrs,
                            drillingToolLibraryDefinition=drillingToolLibraryDefinition,
                            millingToolLibraryDefinition=millingToolLibraryDefinition,
                            task=holeTask,
                        )

                CAMFunctionContext.succeed(
                    message=f"Created drilling operations for {len(simpleHoles)} simple hole groups in setup '{setup.name}'."
                )

            # Create drilling operations for counterbore holes
            if createCounterbore and len(counterboreHoles) > 0:
                for i, (holeGroup, attrs) in enumerate(counterboreHoles):
                    with millTask.makeSubTaskByIndex(index=i + numberOfSimpleHoles) as holeTask:
                        millHoleGroup(
                            setup=setup,
                            holeGroup=holeGroup,
                            holeAttributes=attrs,
                            drillingToolLibraryDefinition=drillingToolLibraryDefinition,
                            millingToolLibraryDefinition=millingToolLibraryDefinition,
                            task=holeTask,
                        )

                CAMFunctionContext.succeed(
                    message=f"Created drilling operations for {len(counterboreHoles)} counterbore hole groups in setup '{setup.name}'."
                )


@CAMFunctionContext.execute_if_unblocked
def create_milling_operations_for_pockets(
    setup_name: str,
    operation_type: str,
    tool_definition: dict | None = None,
    pocket_type: str = "all",
):
    with CAMFunctionTaskManager.nextTask("Milling pockets") as task:
        _, _, _, _, cam = init()
        ERROR_MESSAGE = "Error creating operations to mill pockets:"
        WARN_MESSAGE = "Warning creating operations to mill pockets:"

        toolDefinition = extractToolDefinition(
            toolDefinitionInput=tool_definition, cam=cam
        )

        foundSetups, setups, _ = findMatchingSetups(setup_name, False, cam, ERROR_MESSAGE)
        if not foundSetups:
            return

        task.updateUI()

        setup = setups[0]
        if setup.models.count == 0:
            CAMFunctionContext.fail(
                message=ERROR_MESSAGE, error=f"Setup '{setup.name}' has no models."
            )
            return

        toolLibraryDefinition = (
            toolDefinition.toolLibraryDefinition if toolDefinition else None
        )
        with task.makeSubTask("Finding library", progressRange=(0, 30)) as libraryTask:
            if toolLibraryDefinition and isNonEmptyString(toolLibraryDefinition.name):
                toolDefinition.toolLibraryDefinition.toolLibrary = getToolLibrary(
                    toolLibraryDefinition=toolLibraryDefinition,
                    task=libraryTask,
                )
                if toolLibraryDefinition.toolLibrary is None:
                    CAMFunctionContext.warn(
                        message=WARN_MESSAGE,
                        warning=f"Tool library '{toolLibraryDefinition.name}' not found.",
                    )

        # Get the tool to set, if provided
        tool: adsk.cam.Tool | None = None
        with task.makeSubTask("Finding tool", progressRange=(30, 40)) as toolTask:
            if toolDefinition:
                if not isNonEmptyString(toolDefinition.name):
                    if toolLibraryDefinition:
                        warningMsg = None
                        if isNonEmptyString(toolLibraryDefinition.name):
                            warningMsg = f"Tool library '{toolLibraryDefinition.name}'"
                        elif toolLibraryDefinition.type != ToolLibraryType.ALL:
                            warningMsg = f"Tool library type '{toolLibraryDefinition.type.value}'"
                        if isNonEmptyString(warningMsg):
                            CAMFunctionContext.warn(
                                message=WARN_MESSAGE,
                                warning=f"{warningMsg} is specified but no tool name is provided. Tool will not be set.",
                            )
                else:
                    tool = getToolByName(
                        toolDefinition=toolDefinition,
                        task=toolTask,
                    )

                    if tool is None:
                        CAMFunctionContext.warn(
                            message=WARN_MESSAGE,
                            warning=f"Tool '{toolDefinition.name}' not found. Tool will not be set.",
                        )

        with task.makeSubTask(progressRange=(40, 50), message="Recognizing pockets") as recognizeTask:
            allPockets: adsk.cam.RecognizedPockets = recognizePockets(
                collections=setup.models,
                parentTask=recognizeTask,
            )

        targetPockets = []
        if pocket_type == "all":
            targetPockets = allPockets
        else:
            for pocket in allPockets:
                if (
                    (pocket_type == "open" and not pocket.isClosed)
                    or (pocket_type == "closed" and pocket.isClosed)
                    or (pocket_type == "blind" and not pocket.isThrough)
                    or (
                        pocket_type == "blind closed"
                        and not pocket.isThrough
                        and pocket.isClosed
                    )
                    or (pocket_type == "through" and pocket.isThrough)
                ):
                    targetPockets.append(pocket)

        if len(targetPockets) == 0:
            CAMFunctionContext.warn(
                message=f"Warning creating {operation_type} toolpath:",
                warning=f"No {pocket_type if pocket_type != 'all' else ''} pockets found in setup '{setup.name}'.",
            )
            return

        with task.makeSubTask(progressRange=(50, 100), message="Creating operations") as millTask:
            millPockets(operation_type, targetPockets, setup, tool, millTask)

        CAMFunctionContext.succeed(
            f"Successfully created operations to mill {pocket_type} pockets in Setup '{setup.name}'."
        )



@CAMFunctionContext.execute_if_unblocked
def get_parameters(item_name: str):
    with CAMFunctionTaskManager.nextTask("Getting parameters") as task:
        _, _, _, _, cam = init()

        foundItem = None

        # Look for a setup that matches the given name
        with task.makeSubTask(progressRange=(0, 45)) as findTask:
            setups = cam.setups
            for i, setup in enumerate(setups):
                findTask.updateTaskProgress(i, setups.count)
                if hasMatchingCaseInsensitiveName(setup, item_name):
                    foundItem = setup
                    break

        # If not found in setups, check operations
        with task.makeSubTask(progressRange=(45, 90)) as findTask:
            if foundItem is None:
                allOperations = cam.allOperations
                for i, operation in enumerate(allOperations):
                    findTask.updateTaskProgress(i, allOperations.count)
                    if hasMatchingCaseInsensitiveName(operation, item_name):
                        foundItem = operation
                        break

        if foundItem is None:
            CAMFunctionContext.fail(
                message="Error getting parameters:",
                error=f"Item with name '{item_name}' could not be found.",
            )
            return

        params = foundItem.parameters
        paramsToShow = []
        with task.makeSubTask(progressRange=(90, 100)) as paramTask:
            for i, param in enumerate(params):
                paramTask.updateTaskProgress(i, params.count)
                if (
                    param.isValid
                    and not param.isDeprecated
                    and param.isVisible
                    and param.isEditable
                    and param.isEnabled
                ):
                    paramsToShow.append(param.fullTitle)

        if not paramsToShow:
            CAMFunctionContext.warn(
                message="Warning getting parameters:",
                warning=f"No valid parameters found for '{foundItem.name}'.",
            )
        else:
            CAMFunctionContext.succeed(
                message=f"Retrieved parameters for '{foundItem.name}': <list_placeholder>",
                list=paramsToShow,
            )


@CAMFunctionContext.execute_if_unblocked
def rename_object(
    current_name: str,
    new_name: str,
    object_type: str
):
    _, _, _, _, cam = init()

    with CAMFunctionTaskManager.nextTask("Renaming object") as task:
        if not isNonEmptyString(new_name):
            CAMFunctionContext.fail(
                message="Error renaming object:",
                error="Cannot determine the new name.",
            )
            return

        with task.makeSubTask(progressRange=(0, 95)) as findTask:
            # Find the object by name
            matchingObject, typeStr = findObjectByName(cam, current_name, object_type, findTask)

        with task.makeSubTask(progressRange=(95, 100)):
            if matchingObject:
                oldName: str = matchingObject.name
                matchingObject.name = new_name
                if matchingObject.name != new_name:
                    CAMFunctionContext.blockFutureExecution(
                        warning=f"Renamed {typeStr} '{oldName}' to '{matchingObject.name}' instead of '{new_name}'."
                    )
                    return

                CAMFunctionContext.succeed(
                    message=f"Renamed {typeStr} '{oldName}' to '{new_name}'."
                )
            else:
                CAMFunctionContext.fail(
                    message="Error renaming object:",
                    error=f"No objects found with name '{current_name}'.",
                )


@CAMFunctionContext.execute_if_unblocked
def apply_template_to_parent(
    template_name: str,
    template_library_location: str,
    parent_name: str,
    template_library_folder_name: str | None = None,
):
    """
    Applies a template from the template library to the specified parent object.
    """
    ERROR_MESSAGE = "Error applying template:"
    folderMessageString = (
        f" the '{template_library_folder_name}' folder in"
        if isNonEmptyString(template_library_folder_name)
        else ""
    )

    with CAMFunctionTaskManager.nextTask("Applying template") as task:
        _, _, _, _, cam = init()

        # Convert the template_library_location string to an adsk.cam.LibraryLocations enum
        # https://help.autodesk.com/view/fusion360/ENU/?guid=GUID-EB5D852F-3EC5-4B95-9A34-AA373E01E043
        possibleLocationStrings = [
            "LocalLibraryLocation",  # Represents the local folder in the library.
            # "CloudLibraryLocation", # Represents the cloud folder in the library.
            # "NetworkLibraryLocation", # For internal use only.
            # "OnlineSamplesLibraryLocation", # For internal use only.
            # "ExternalLibraryLocation", # Represents an external folder that is not in the library.
            "Fusion360LibraryLocation",  # Represents the fusion 360 folder in the library.
        ]
        libraryLocation = None
        if template_library_location == "LocalLibraryLocation":
            libraryLocation = adsk.cam.LibraryLocations.LocalLibraryLocation
        elif template_library_location == "Fusion360LibraryLocation":
            libraryLocation = adsk.cam.LibraryLocations.Fusion360LibraryLocation
        else:
            CAMFunctionContext.fail(
                message=ERROR_MESSAGE,
                error=f"Invalid template library location '{template_library_location}'. Valid values are {possibleLocationStrings}.",
            )
            return

        # Get the library manager to find the template
        with task.makeSubTask(
            message="Loading template", progressRange=(0, 30)
        ) as loadTask:
            libraryManager = adsk.cam.CAMManager.get().libraryManager
            templateLibrary = libraryManager.templateLibrary
            libraryURL = templateLibrary.urlByLocation(libraryLocation)

            # Get all asset names
            #
            # This can be a long operation, so we run it asynchronously and
            # indeterminately increment the progress bar
            async def worker() -> list[adsk.core.URL]:
                return templateLibrary.childAssetURLs(libraryURL)

            assetURLs = loadTask.runAsyncWorker(worker=worker)

            # Create a dict of Template URL string to object containing information about the template
            assetInfoDict = {
                assetURL.toString(): {
                    "name": templateLibrary.templateAtURL(assetURL).name,
                    "assetURL": assetURL,
                    "parentLeafName": assetURL.parent.leafName,
                }
                for assetURL in assetURLs
            }

            # Find the template by name. There may be multiple templates with the same name in different folders.
            candidateTemplateInfos = []
            for _, assetInfo in assetInfoDict.items():
                if areMatchingCaseInsensitiveNames(template_name, assetInfo["name"]):
                    # If no folder name is provided, store the template.
                    if not isNonEmptyString(template_library_folder_name):
                        candidateTemplateInfos.append(assetInfo)
                        continue

                    # If a folder name is provided, check it matches the parent leaf name.
                    if (
                        # For (root) level templates, the parent leaf name is empty
                        areMatchingCaseInsensitiveNames(
                            template_library_folder_name, "(root)"
                        )
                        and not assetInfo["parentLeafName"]
                    ) or (
                        # Otherwise, check if the folder name matches the parent leaf name
                        areMatchingCaseInsensitiveNames(
                            template_library_folder_name, assetInfo["parentLeafName"]
                        )
                    ):
                        candidateTemplateInfos.append(assetInfo)
                        continue

        if len(candidateTemplateInfos) == 0:
            CAMFunctionContext.fail(
                message=ERROR_MESSAGE,
                error=f"Template '{template_name}' not found in{folderMessageString} the {template_library_location} library.",
            )
            return
        elif len(candidateTemplateInfos) > 1:
            # Get the names of all the parent folders of these matched templates
            # This will help the user to pick the correct template without having to search through the library
            parentFolderNames = []
            for templateInfo in candidateTemplateInfos:
                if templateInfo["parentLeafName"] == "":  # Root folder
                    parentFolderNames.append("(root)")
                else:
                    parentFolderNames.append(templateInfo["parentLeafName"])
            CAMFunctionContext.fail(
                message=ERROR_MESSAGE,
                error=f"Multiple templates found for name '{template_name}'. Please specify the containing folder. Folders found with this template: {getListAsString(parentFolderNames)}",
            )
            return

        # Construct the URL of the template that we are looking for
        template = templateLibrary.templateAtURL(candidateTemplateInfos[0]["assetURL"])

        # Find the parent object to apply the template to
        foundParents, parents, _ = findMatchingParents(
            parentName=parent_name,
            cam=cam,
            regexEnabled=False,
            errorMessage=ERROR_MESSAGE,
        )
        if not foundParents:
            return
        if len(parents) != 1:
            CAMFunctionContext.fail(
                message=ERROR_MESSAGE,
                error=f"Multiple objects found for name '{parent_name}'. Please specify a more specific name.",
            )
            return
        parent = parents[0]

        task.updateUI()

        # Convert the template to a template input
        templateInput: adsk.cam.CreateFromCAMTemplateInput = (
            adsk.cam.CreateFromCAMTemplateInput.create()
        )
        templateInput.camTemplate = template

        # Apply the template to the setup
        with task.makeSubTask(message="Applying template", progressRange=(30, 100)) as createTask:
            try:
                # At the moment, we don't prevent the UI messagebox error from popping up if the operations are not compatible with the setup.
                # This could be improved by using the .operations property of the template
                # (see here https://help.autodesk.com/view/fusion360/ENU/?guid=GUID-0586D2B2-0683-462B-B3B8-B1E387CEC0F4)
                # However, until this property is taken OUT of "preview" mode, I don't think we should use it.
                #
                # This can be a long operation, so we run it asynchronously and
                # indeterminately increment the progress bar
                async def worker() -> list[adsk.cam.OperationBase]:
                    return parent.createFromCAMTemplate2(templateInput)

                createTask.runAsyncWorker(worker=worker)
            except Exception:
                CAMFunctionContext.fail(
                    message=ERROR_MESSAGE,
                    error="Template is not compatible with the setup.",
                )
                return

        CAMFunctionContext.succeed(
            message=f"Successfully applied template '{template.name}' to '{parent.name}' from{folderMessageString} the {template_library_location} library."
        )


@CAMFunctionContext.execute_if_unblocked
def highlight_operation(
    parent_name: dict | None = None,
    operation_name: dict | None = None,
    operation_type: str | None = None,
):
    with CAMFunctionTaskManager.nextTask("Highlighting operations") as task:
        _, ui, _, _, cam = init()

        # Get the specifics of the input name arguments
        parent_name_str, parent_name_regex_enabled = extractNameAndRegexEnabled(
            parent_name
        )
        operation_name_str, operation_name_regex_enabled = extractNameAndRegexEnabled(
            operation_name
        )

        # If operation_type is provided, validate it is a valid strategy
        strategy: adsk.cam.OperationStrategy | None = None
        if isNonEmptyString(operation_type):
            try:
                strategy = adsk.cam.OperationStrategy.createFromString(operation_type)
            except Exception:
                CAMFunctionContext.fail(
                    message="Error highlighting operation:",
                    error=f"Invalid operation type '{operation_type}' specified.",
                )
                return

        # Find the parent object(s) from parent_name in the document
        foundParents, parents, _ = findMatchingParents(
            parentName=parent_name_str,
            cam=cam,
            regexEnabled=parent_name_regex_enabled,
            errorMessage="Error highlighting operation:",
        )
        if not foundParents:
            return

        # Helper method for deciding if a candidate operation is to be highlighted
        def shouldHighlightOperation(operation: adsk.cam.OperationBase) -> bool:
            if isNonEmptyString(operation_name_str):
                if not hasMatchingCaseInsensitiveName(
                    item=operation,
                    name=operation_name_str,
                    regexEnabled=operation_name_regex_enabled,
                ):
                    return False

            if strategy is not None:
                if operation.strategy != strategy.name:
                    return False

            return True

        # Collect the operations to highlight
        operationsToHighlight: list[adsk.cam.OperationBase] = []

        with task.makeSubTask(
            progressRange=(0, 80), numberOfTasks=len(parents)
        ) as collectTask:
            for i, parent in enumerate(parents):
                with collectTask.makeSubTaskByIndex(index=i):
                    operationsToHighlight.extend(
                        operation
                        for operation in parent.operations
                        if shouldHighlightOperation(operation)
                    )

        # Don't change the current selection if there was nothing to highlight
        if len(operationsToHighlight) == 0:
            CAMFunctionContext.warn(
                message="Warning highlighting operation:",
                warning="No operations found matching the specified criteria.",
            )
            return

        # Highlight the operations
        with task.makeSubTask(progressRange=(80, 100)) as highlightTask:
            selectOperations(
                ui=ui,
                operations=operationsToHighlight,
                task=highlightTask,
            )

        if len(operationsToHighlight) == 1:
            CAMFunctionContext.succeed(
                message=f"Highlighted '{operationsToHighlight[0].name}'."
            )
        else:
            CAMFunctionContext.succeed(
                message=f"Highlighted {len(operationsToHighlight)} operations."
            )
