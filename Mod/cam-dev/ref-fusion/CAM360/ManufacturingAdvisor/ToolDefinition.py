from enum import StrEnum
from typing import NotRequired, TypedDict

from CAMFunctionContext import CAMFunctionContext
import adsk.cam


class ToolLibraryType(StrEnum):
    """
    Enum representing different types of tool libraries.
    """

    DOCUMENT = "document"
    LOCAL = "local"
    SAMPLES = "samples"
    CLOUD = "cloud"
    ALL = "all"


# List of all tool library types in the order of their search priority
TOOL_LIBRARY_SEARCH_PRIORITY = [
    ToolLibraryType.DOCUMENT,
    ToolLibraryType.LOCAL,
    ToolLibraryType.SAMPLES,
    ToolLibraryType.CLOUD,
]


def extractToolLibraryType(libraryTypeStr: str) -> ToolLibraryType:
    """
    Extracts the tool library type from the given string.
    """
    try:
        return ToolLibraryType(libraryTypeStr)
    except ValueError:
        CAMFunctionContext.warn(
            message="Tool library type is not recognized.",
            warning=f"Unrecognized tool library type: '{libraryTypeStr}'. All tool libraries will be used.",
        )
        return ToolLibraryType.ALL


class ToolLibraryDefinition:
    """
    Represents a tool library definition.
    """

    def __init__(
        self,
        name: str | None = None,
        type: ToolLibraryType | None = None,
        toolLibrary: adsk.cam.ToolLibrary | None = None,
    ):
        """
        Initializes a ToolLibraryDefinition instance.
        """
        self.name = name
        self.type = type if type else ToolLibraryType.ALL
        self.toolLibrary = toolLibrary


class ToolDefinition:
    """
    Represents a tool definition.
    """

    def __init__(
        self,
        name: str | None = None,
        toolLibraryDefinition: ToolLibraryDefinition | None = None,
    ):
        """
        Initializes a ToolDefinition instance.
        """
        self.name = name
        self.toolLibraryDefinition = toolLibraryDefinition


# ToolLibraryDefinitionDict is a TypedDict that defines the structure of a tool library definition dictionary.
ToolLibraryDefinitionDict = TypedDict(
    "ToolLibraryDefinitionDict",
    {
        "name": NotRequired[str],
        "type": NotRequired[str],
    },
)

# ToolDefinitionDict is a TypedDict that defines the structure of a tool definition dictionary.
ToolDefinitionDict = TypedDict(
    "ToolDefinitionDict",
    {
        "name": str,
        "tool_library": NotRequired[ToolLibraryDefinitionDict],
    },
)


def extractToolLibraryDefinition(
    toolLibraryDefinitionInput: ToolDefinitionDict | None, cam: adsk.cam.CAM
) -> ToolLibraryDefinition:
    """
    Extracts a ToolLibraryDefinition from a dictionary.
    This can be constructed using a CAMToolLibraryDefinitionToolParameter argument of a function call.
    """

    name = None
    type = ToolLibraryType.ALL
    toolLibrary = None

    if toolLibraryDefinitionInput:
        name = toolLibraryDefinitionInput.get("name", None)
        typeStr = toolLibraryDefinitionInput.get("type", ToolLibraryType.ALL.value)
        type = extractToolLibraryType(typeStr)

    if type == ToolLibraryType.DOCUMENT:
        toolLibrary = cam.documentToolLibrary

    return ToolLibraryDefinition(
        name=name,
        type=type,
        toolLibrary=toolLibrary,
    )


def extractToolDefinition(
    toolDefinitionInput: ToolDefinitionDict | None, cam: adsk.cam.CAM
) -> ToolDefinition:
    """
    Extracts a ToolDefinition from a dictionary.
    This can be constructed using a CAMToolDefinitionToolParameter argument of a function call.
    """

    name = None
    toolLibraryDefinition = None

    if toolDefinitionInput:
        name = toolDefinitionInput.get("name", None)
        toolLibraryDefinition = extractToolLibraryDefinition(
            toolDefinitionInput.get("tool_library", None), cam
        )

    return ToolDefinition(
        name=name,
        toolLibraryDefinition=toolLibraryDefinition,
    )
