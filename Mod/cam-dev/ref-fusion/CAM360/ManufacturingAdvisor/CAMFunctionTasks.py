"""
Classes to manage the progress bar in Fusion and to allow the UI to be updated.

Usage:
======

code = '''
a_tool_call()
another_tool_call()
yet_another_tool_call()
'''

with CAMFunctionsTaskManager.initFromCode(code):
    a_tool_call()
    another_tool_call()
    yet_another_tool_call()

def a_tool_call():
    with CAMFunctionsTaskManager.nextTask("Executing a_tool_call") as task:
        # The tool call implementation
        task.updatePercentageProgress(50)  # Update progress to 50%
        # More implementation
        task.updatePercentageProgress(100)  # Update progress to 100%

def another_tool_call():
    with CAMFunctionsTaskManager.nextTask("Executing another_tool_call") as task:
        # Entering task context calls task.updatePercentageProgress(0)
        simple_implementation()
    # Exiting task context calls task.updatePercentageProgress(100)


For API calls that take a long time to complete, the API call can be wrapped
in an async worker function and run with the
CAMFunctionTaskContext.runAsyncWorker method. This will update the task
progress bar in the UI while the worker function is running:

async def long_running_task():
    # Do the long-running task here

with task.makeSubTask(progressRange=(50, 100)) as workerTask:
    # Run the long task, while the workerTask is incrementally progressed
    workerTask.runAsyncWorker(worker=long_running_task)
    # The background progress will be updated every 0.5 seconds by default
    # until the task is complete
    # N.B. This context does NOT ensure that the task is completed to 100%, it
    # only ensures that the progress bar is updated in the background.
"""

import ast
import asyncio

from datetime import datetime, timedelta
from types import TracebackType

import adsk.core

from CAMFunctionContext import CAMFunctionContext


# Period of time to wait before updating the UI
UI_UPDATE_PERIOD = timedelta(milliseconds=100)


class CAMFunctionTaskContext:
    """
    A context manager that updates the progress bar in Fusion.

    The outermost context will update the progress bar from 0% to 100%.

    Subtasks created from the outermost context will update the progress bar
    for a portion of the total progress, allowing for nested tasks to be
    tracked.
    - For a task context with a single task, a subtask can be created to
      progress between two specific percentage values of the current task
      with makeSubTaskByRange.
    - For a task created for a number of tasks, a task context can be created
      for each subtask with makeSubTaskByIndex.

    Progress on a task context always has the range from 0% to 100%.
    Internally this will be converted to the min/max range to be shown on the
    progress bar in Fusion.
    """

    # Last time the UI was updated
    _lastUIUpdate: datetime = datetime.now()

    def __init__(
        self,
        message: str,
        numberOfTasks: int = 1,
        progressRange: tuple[int, int] = (0, 100),
        parentTask: "CAMFunctionTaskContext" = None,
        progressBar: adsk.core.ProgressBar = None,
    ):
        """
        Initialise a new task context.

        :param message: The message to be shown in the progress bar.
        :param numberOfTasks: The number of tasks to be executed in this context.
        :param progressRange: The range of the progress bar for this task, as a tuple
                              of (minimum, maximum) values in the range [0-100].
        :param parentTask: The parent task context, if this is a subtask.
        """

        assert numberOfTasks > 0
        assert 0 <= progressRange[0] <= progressRange[1] <= 100

        self.message: str = message
        self.numberOfTasks: int = numberOfTasks
        self.progressRange: tuple[int, int] = progressRange
        self.parentTask: CAMFunctionTaskContext = parentTask
        self.childTasks: list["CAMFunctionTaskContext"] = []

        # Store the progress bar
        if progressBar:
            self.progressBar: adsk.core.ProgressBar = progressBar
        else:
            app = adsk.core.Application.get()
            self.progressBar = app.userInterface.progressBar

    @property
    def level(self) -> int:
        """
        The level of this task in the hierarchy, where 0 is the outermost task.
        """

        if self.parentTask:
            return self.parentTask.level + 1
        return 0

    @property
    def minimumValue(self) -> int:
        """
        The minimum value of the progress bar for this task.
        """

        return self.progressRange[0]

    @property
    def maximumValue(self) -> int:
        """
        The maximum value of the progress bar for this task.
        """

        return self.progressRange[1]

    @property
    def range(self) -> int:
        """
        The range of the progress bar for this task.
        """

        return self.maximumValue - self.minimumValue

    @property
    def progressMessage(self) -> str:
        """
        The message to be shown in the progress bar, with the percentage placeholder.
        """

        return f"{self.message} %p%"

    @classmethod
    def resetUIUpdate(cls):
        """
        Reset the last UI update time to the current time.
        """

        cls._lastUIUpdate = datetime.now()

    def __enter__(self) -> "CAMFunctionTaskContext":
        """
        Ensure the progress bar is shown with the task message.
        """

        if not self.parentTask:
            # If this is the outermost task, show the progress bar
            self.showProgressBar()
        else:
            # If this is a subtask, update the progress bar message and set the
            # progress to the minimum value of this task
            self.progressBar.message = self.progressMessage
            self.updatePercentageProgress(0)

        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_value: BaseException | None,
        exc_traceback: TracebackType | None,
    ):
        """
        Complete this task and either restore the message or hide progress.
        """

        if exc_type is None:
            # If no exception occurred, update the progress to 100%
            self.updatePercentageProgress(100)

        if not self.parentTask:
            # If this is the outermost task, hide the progress bar
            self.progressBar.hide()

            # Add the nested task information to the context output
            self.recordNestedTasks()
        else:
            # If this is a subtask, restore the parent task message
            self.progressBar.message = self.parentTask.progressMessage
        self.updateUI()

        # Do not return a truthy value to propagate exceptions

    def makeSubTask(
        self,
        message: str | None = None,
        progressRange: tuple[int, int] = (0, 100),
        numberOfTasks: int = 1,
    ) -> "CAMFunctionTaskContext":
        """
        Create a subtask that updates the progress bar between two values.

        Minimum and maximum values are in the range [0-100] of this task.
        """

        assert 0 <= progressRange[0] <= progressRange[1] <= 100

        subtaskProgressRange: tuple[int, int] = (
            self.minimumValue + self.range * progressRange[0] // 100,
            self.minimumValue + self.range * progressRange[1] // 100,
        )

        subTask = CAMFunctionTaskContext(
            message=message or self.message,
            numberOfTasks=numberOfTasks,
            progressRange=subtaskProgressRange,
            parentTask=self,
            progressBar=self.progressBar,
        )
        self.childTasks.append(subTask)
        return subTask

    def makeSubTaskByIndex(
        self,
        index: int,
        message: str | None = None,
        numberOfTasks: int = 1,
    ) -> "CAMFunctionTaskContext":
        """
        Create a subtask that updates the progress bar for a specific index.
        """

        assert 0 <= index < self.numberOfTasks
        assert numberOfTasks >= 1

        # Convert the index to a percentage range
        progressRange: tuple[int, int] = (
            100 * index // self.numberOfTasks,
            100 * (index + 1) // self.numberOfTasks,
        )

        return self.makeSubTask(
            message=message,
            progressRange=progressRange,
            numberOfTasks=numberOfTasks,
        )

    def showProgressBar(self):
        """
        Show the progress bar with the current message.
        """

        assert not self.parentTask

        self.progressBar.show(
            message=self.message,
            minimumValue=self.minimumValue,
            maximumValue=self.maximumValue,
            isModal=False,
        )
        self.updateUI()

    def updateUI(self):
        """
        Refresh the Fusion user interface.
        """

        # Check if enough time has passed since the last UI update
        if (datetime.now() - CAMFunctionTaskContext._lastUIUpdate) < UI_UPDATE_PERIOD:
            return

        adsk.doEvents()

        # Update the last UI update time
        CAMFunctionTaskContext.resetUIUpdate()

    def updatePercentageProgress(self, percentage: int):
        """
        Update the percentage progress of this task.

        The given percentage is converted to the range of the progress bar that
        this task is using.

        :param value: The percentage value of the progress of this task,
                      between 0 and 100.
        """

        assert 0 <= percentage <= 100, "value must be between 0 and 100"

        progressValue: int = self.minimumValue + self.range * percentage // 100

        self.progressBar.progressValue = progressValue
        self.updateUI()

    def updateTaskProgress(self, completed: int, total: int):
        """
        Update the progress of this task based on completed and total steps.
        """

        assert total > 0, "Total must be greater than 0"
        assert 0 <= completed <= total, "Completed must be between 0 and total"

        # Calculate the percentage of completion of this task
        percentage: int = 100 * completed // total

        # Update the progress bar
        self.updatePercentageProgress(percentage)

    def runAsyncWorker(
        self,
        worker: callable,
        *args,
        **kwargs,
    ) -> any:
        """
        Run the given worker function asynchronously and update the progress of
        this task.

        args and kwargs are passed to the worker function.

        This is useful for long-running tasks where the progress cannot be
        determined in advance, or would block the application while executing.

        This task increments its progress bar for the given progress range by
        10% every 0.5 seconds (by default), then pauses until the worker
        function completes. This pause allows the worker thread to do work.
        """

        PROGRESS_INCREMENT: int = 10  # Percentage to increment the progress bar
        UPDATE_INTERVAL: float = 0.5  # Seconds to wait between progress updates

        # Async helper to update the progress bar from 0% to 100% (or until the
        # worker completes)
        async def updateTaskToEnd(task: "CAMFunctionTaskContext"):
            currentPercentage: int = 0

            # Update the progress bar until it reaches 100%
            while currentPercentage < 100:
                currentPercentage += PROGRESS_INCREMENT
                task.updatePercentageProgress(currentPercentage)
                await asyncio.sleep(UPDATE_INTERVAL)

            # Ensure the UI is still responsive after the loop
            while True:
                task.updateUI()
                await asyncio.sleep(UPDATE_INTERVAL)

        # Wrapper around the worker function to run it while updating the
        # progress bar
        async def runWorker():
            # Create a task to update the progress bar
            updateTask = asyncio.create_task(updateTaskToEnd(self))
            try:
                # Run the worker function
                return await worker(*args, **kwargs)
            finally:
                # Ensure the update task is cancelled after the worker completes
                updateTask.cancel()

        # Run the async worker function and return the result
        return asyncio.run(runWorker())

    def getTaskInformation(self) -> dict:
        """
        Get the information about this task as a dictionary.

        This includes the message, progress range, and child tasks (if any).
        """

        info = {
            "level": self.level,
            "progressRange": self.progressRange,
        }

        # Only include the message if this is the outermost task or if the
        # parent task message is different
        if not self.parentTask or self.parentTask.message != self.message:
            info["message"] = self.message

        # Include child tasks if there are any
        if len(self.childTasks) > 0:
            info["tasks"] = [task.getTaskInformation() for task in self.childTasks]

        return info

    def recordNestedTasks(self):
        """
        Record the nested tasks in the CAMFunctionContext for later use.
        """
        assert self.level == 0, "Should only be called for the outermost task"

        # Create a list of task messages and their progress ranges
        task_info: dict = self.getTaskInformation()

        # Add the nested tasks to the CAMFunctionContext results
        CAMFunctionContext.recordTaskProgress(task_info)


class CAMFunctionTaskManager:
    """
    Manages how many task contexts are created for the CAM functions.

    CAMFunctionsTaskManager is initialised with the code string to be executed
    (in order to determine how many toplevel CAM functions will be executed).

    Each CAM function then uses the CAMFunctionTaskContext returned by
    CAMFunctionsTaskManager.nextTask to update progress in the UI
    """

    rootTask: CAMFunctionTaskContext = None
    currentTaskIndex: int = 0

    @classmethod
    def initFromCode(cls, code: str) -> CAMFunctionTaskContext:
        """
        Initialise the number of tasks to be run from the complete code string.
        """

        try:
            # Parse the code into an Abstract Syntax Tree (AST) and count the
            # number of top-level statements (tasks)
            tree: ast.Module = ast.parse(code)
            numberOfTasks: int = len(tree.body)
        except SyntaxError:
            # If the code is not valid Python, fall back to counting lines
            #
            # This is a simple fallback and may not accurately reflect the number
            # of tasks, but it allows the code to run without crashing.
            numberOfTasks: int = len(code.splitlines())

        cls.rootTask = CAMFunctionTaskContext(
            message="Executing code",
            numberOfTasks=numberOfTasks,
            progressRange=(0, 100),  # Progress range from 0% to 100%
        )
        cls.currentTaskIndex = 0

        # Reset the last UI update time for the new root task
        CAMFunctionTaskContext.resetUIUpdate()

        return cls.rootTask

    @classmethod
    def nextTask(cls, message: str) -> CAMFunctionTaskContext:
        """
        Get the next task to be executed.
        """

        if cls.rootTask is None:
            raise ValueError("Root task is not initialized. Call initFromCode first.")

        if cls.currentTaskIndex >= cls.rootTask.numberOfTasks:
            raise StopIteration("No more tasks to execute.")

        subTask: CAMFunctionTaskContext = cls.rootTask.makeSubTaskByIndex(
            message=message,
            index=cls.currentTaskIndex,
        )
        cls.currentTaskIndex += 1
        return subTask
