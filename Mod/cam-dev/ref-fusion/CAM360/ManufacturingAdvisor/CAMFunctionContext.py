import json
# This file contains the classes used to represent the results
# of a Manufacturing Assistant action in the Manufacturing workspace.


class CAMFunctionExecutionBlocker(Exception):
    """Custom exception to handle interruptions."""

    pass


class CAMFunctionResult:
    def __init__(self, message: str, list: list = None):
        self.result = "success"
        self.message = message
        self.list = list


class CAMFunctionWarning(CAMFunctionResult):
    def __init__(self, message: str, warning: str):
        super().__init__(message)
        self.result = "warning"
        self.warning = warning


class CAMFunctionError(CAMFunctionResult):
    def __init__(self, message: str, error: str):
        super().__init__(message)
        self.result = "error"
        self.error = error


class CAMFunctionResults:
    def __init__(self):
        self.results = []
        self.taskProgress = {}


class CAMFunctionContext:
    results: CAMFunctionResults
    isExecutionBlocked: bool = False

    def __init__(self):
        pass

    @classmethod
    def add(cls, result: CAMFunctionResult):
        cls.results.results.append(result)

    @classmethod
    def succeed(cls, message: str, list: list = None):
        cls.add(CAMFunctionResult(message=message, list=list))

    @classmethod
    def warn(cls, message: str, warning: str):
        cls.add(CAMFunctionWarning(message=message, warning=warning))

    @classmethod
    def fail(cls, message: str, error: str):
        cls.add(CAMFunctionError(message=message, error=error))

    @classmethod
    def handle_exception(cls, message: str, exception: Exception):
        if isinstance(exception, CAMFunctionExecutionBlocker):
            # Don't add an error message for the exception that blocks execution
            return
        cls.fail(message=message, error=str(exception))

    @classmethod
    def blockFutureExecution(cls, warning: str):
        """
        Set the flag to prevent any function calling tools from being executed,
        and add a warning to the context.
        """
        cls.isExecutionBlocked = True
        cls.warn(message="Execution interrupted", warning=warning)

    @classmethod
    def blockExecutionImmediately(cls, warning: str):
        """
        Raise an exception to immediately interrupt the current function
        and prevent any future function calling tools from being executed.
        """
        cls.blockFutureExecution(warning=warning)
        raise CAMFunctionExecutionBlocker

    def execute_if_unblocked(func):
        def wrapper(*args, **kwargs):
            if CAMFunctionContext.isExecutionBlocked:
                return
            return func(*args, **kwargs)

        return wrapper

    @classmethod
    def recordTaskProgress(cls, taskInformation: dict):
        """
        Record the task progress information in the context output.

        This is used to track the progress of nested tasks and ensure proper
        overall progress reporting from 0% to 100%.
        """
        cls.results.taskProgress.update(taskInformation)

    def __enter__(self):
        CAMFunctionContext.results = CAMFunctionResults()
        CAMFunctionContext.isExecutionBlocked = False

    def __exit__(self, exc_type, exc_value, traceback):
        if exc_type is not None:
            CAMFunctionContext.handle_exception(
                message="An error occurred",
                exception=exc_value,
            )

        # Remove None values recursively.
        def removeNone(obj):
            if hasattr(obj, "__dict__"):
                return removeNone(vars(obj))
            if isinstance(obj, dict):
                return {k: removeNone(v) for k, v in obj.items() if v is not None}
            elif isinstance(obj, list):
                return [removeNone(i) for i in obj]
            else:
                return obj

        cleaned_results = removeNone(CAMFunctionContext.results)

        print(json.dumps(cleaned_results))
        CAMFunctionContext.results = None
        CAMFunctionContext.isExecutionBlocked = False
        return True
