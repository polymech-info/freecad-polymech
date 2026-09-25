/**
  Copyright (c) 2013-2018 by Autodesk, Inc.
  http://www.autodesk.com
  Not for redistribution
*/

#pragma once

/**
  HSMWorks exposes the low-level C API described below to automated toolpath
  generation and post processing.

  The HSMWorks API allows programmers in Visual Basic .NET, C#, C, and C++ to
  create add-ins for SolidWorks which also talk/interact with HSMWorks. Note
  that the SolidWorks macro feature DOES NOT support the HSMWorks API since the
  macros run in a separate process and hence cannot get access to the HSMWorks
  data.

  You would use the SolidWorks add-in sample code to get started. Hereafter you
  can add the HSMWorks calls as listed below.

  To use the HSMWorks API either:

  1. Link against hsmsw.lib included with the installation in the API folder.

  2. Alternatively import the functions at runtime using GetProcAddress():

  typedef unsigned int (*HSMWorks_getVersionFunction)(unsigned int* major, unsigned int* minor, unsigned int* micro, unsigned int* build);

  HMODULE module = LoadLibrary(L"hsmsw.dll");
  if (module) {
    HSMWorks_getVersionFunction HSMWorks_getVersion = (HSMWorks_getVersionFunction)GetProcAddress(module, "HSMWorks_getVersion");
    if (HSMWorks_getVersion) {
      unsigned int major = 0;
      unsigned int minor = 0;
      unsigned int micro = 0;
      unsigned int build = 0;
      HSMWorks_getVersion(&major, &minor, &micro, &build);
    }
  }
*/

/**
The following sample code shows how to generate toolpath and export it for post processing.

void sampleCode() {
  ISldWorksPtr sw; // See SolidWorks documentation for accessing SolidWorks object
  IUnknownPtr document = sw->GetActiveDoc();

  bool waitForTasks = false;
  unsigned int status = HSMWorks_regenerateAll(document, waitForTasks);
  if (status != STATUS_OK) {
    return;
  }
  if (!waitForTasks) {
    // Update user interface if require
    while (true) {
      Thread::sleep(1 * 1000000);
      status = HSMWorks_updateOperationManager(document);
      // if (status == STATUS_OK) { // Ignore error
      //  break; // error
      // }
      status = HSMWorks_checkTasks(document); // Do this in a separate thread - only call this every second or so
      if (status == STATUS_OK) {
        break; // done
      }
    }
  }
  status = HSMWorks_abortAllTasks(document); // Nothing to do
  if (status != STATUS_OK) {
    return;
  }
  status = HSMWorks_checkAllToolpath(document);
  if (status != STATUS_OK) {
    return;
  }
  const wchar_t* path = L"D:\\test.cnc";
  status = HSMWorks_exportAll(document, path);
  if (status != STATUS_OK) {
    return;
  }
  // Post process - see post manual for help
  // Clean up files here
}
*/

#if defined(HSMWORKS_EXPORT_API)
#define HSMWORKS_API __declspec(dllexport)
#else
#define HSMWORKS_API __declspec(dllimport)
#endif

extern "C" {

/** Status codes. */
enum {
  STATUS_OK = 0, // API succeed
  STATUS_FAILED = 1, // API failed

  STATUS_INVALID_DOCUMENT = 2, // document is invalid
  STATUS_INVALID_PATH = 3, // invalid path
  STATUS_NO_HSMWORKS_DOCUMENT = 4, // no HSMWorks document is available
  STATUS_NOT_IMPLEMENTED = 5, // API is not implemented
  STATUS_INVALID_OBJECT = 6, // an object is invalid
  STATUS_INVALID_ARGUMENT = 7, // an argument is invalid
  STATUS_BUFFER_TOO_SMALL = 8, // output buffer is too small
  STATUS_NOT_MAIN_THREAD = 9, // API not called via main thread
  STATUS_INVALID_JSON = 10, // JSON data is invalid
  STATUS_FILE_NOT_FOUND = 11, // required file was not found
  STATUS_ABORTED = 12, // task aborted
  STATUS_EXCEPTION = 13, // exception for callback
  STATUS_INVALID_TOOL = 14, // tool is invalid / doesn't exist
  STATUS_INVALID_TOOL_LIBRARY = 15 // tool library is invalid / doesn't exist
};

/** Callback function for progress. Must return STATUS_OK or task will be aborted. */
typedef unsigned int (HSMWorks_Progress)(IUnknown* document, void* context, double progress);

/**
  Enables logging of the API calls. The log is written to the HSMWorks temp folder see "%LOCALAPPDATA%\Temp\HSMWorks\api.log".

  ATTENTION: Logging should not be generally enabled for end users. Make sure to only enable when debugging/testing.

  \since r43161
*/
HSMWORKS_API unsigned int HSMWorks_writeAPILog(bool enable);

/** Returns a counter. Simple function for verifying access to the HSMWorks API. */
HSMWORKS_API unsigned int HSMWorks_dummy();

/**
  Dumps the supported COM interfaces for the given COM object to the debugger.

  @param document The SolidWorks document.
*/
HSMWORKS_API unsigned int HSMWorks_dump(IUnknown* document);

/**
  Sets the given boolean setting to on/off.

  @param document The SolidWorks document. Not required for global settings.
  @param name The id of the setting.
  @param value The value of the setting.

  \since r40111

  The availble settings are:
    DISTRIBUTED_CAM: Turn on/off Distributed CAM (default is true)
    SILENT: Avoid certain popup messages (default is false)
*/
HSMWORKS_API unsigned int HSMWorks_setBoolSetting(IUnknown* document, const char* name, bool value);

/**
  Sets the given integer setting.

  @param document The SolidWorks document. Not required for global settings.
  @param name The id of the setting.
  @param value The value of the setting.

  \since r40111

  No settings are currently supported.
*/
HSMWORKS_API unsigned int HSMWorks_setIntSetting(IUnknown* document, const char* name, int value);

/**
  Sets the value of the given setting.

  @param document The SolidWorks document. Not required for global settings.
  @param name The id of the setting.
  @param value The value of the setting.

  \since r40111

  No settings are currently supported.
*/
HSMWORKS_API unsigned int HSMWorks_setDoubleSetting(IUnknown* document, const char* name, double value);

/**
  Turn on/off Distributed CAM.

  @param document The SolidWorks document.
  @param enable The setting.
  
  \No longer implemented starting with HSMWorks 2021
*/
HSMWORKS_API unsigned int HSMWorks_setDistributedCAM(IUnknown* document, bool enable);

/**
  Returns the version of HSMWorks running.

  @param major The major version number.
  @param minor The minor version number.
  @param micro The micro version number.
  @param build The build number.
*/
HSMWORKS_API unsigned int HSMWorks_getVersion(unsigned int* major, unsigned int* minor, unsigned int* micro, unsigned int* build);

/**
  Clears all toolpath.

  @param document The SolidWorks document.
*/
HSMWORKS_API unsigned int HSMWorks_clearAll(IUnknown* document);

/**
  Regenerate all toolpath. Set waitForTasks to true to wait for all tasks for complete before returning.

  @param document The SolidWorks document.
  @param waitForTasks Set to false is you dont want to wait for the toolpath generation to complete.
*/
HSMWORKS_API unsigned int HSMWorks_regenerateAll(IUnknown* document, bool waitForTasks);

/**
  Refreshes the operation manager.

  @param document The SolidWorks document.
*/
HSMWORKS_API unsigned int HSMWorks_updateOperationManager(IUnknown* document);

/**
  Returns STATUS_OK if all tasks are completed.

  if (HSMWorks_checkTasks(document) != STATUS_OK) {
    // tasks still running
  }

  @param document The SolidWorks document.
*/
HSMWORKS_API unsigned int HSMWorks_checkTasks(IUnknown* document);

/**
  Returns STATUS_OK on success. ids will be filled with all the ids of the objects. size will be set the the number of objects. size must be set initially to the maximum size of the ids buffer.

  unsigned int objectIds[4096];
  unsigned int size = sizeof(objectIds)/sizeof(objectIds[0]);
  if (HSMWorks_getObjects(document, objectIds, &size) == STATUS_OK) {
    for (unsigned int i = 0; i < size; ++i) {
      unsigned int objectId = objectIds[i];
      // do something with objectId
    }
  }

  @param document The SolidWorks document.
  @param ids The HSMWorks object IDs.
  @param size The size of ID buffer.
*/
HSMWORKS_API unsigned int HSMWorks_getObjects(IUnknown* document, unsigned int* ids, unsigned int* size);

/**
  Returns STATUS_OK on success. ids will be filled with all the ids of the child
  objects of the given object. size will be set the the number of child objects.
  size must be set initially to the maximum size of the ids buffer.

  \since r42793

  unsigned int jobIds[256];
  unsigned int size = sizeof(jobIds)/sizeof(jobIds[0]);
  if (HSMWorks_getJobObjects(document, jobIds, &size) == STATUS_OK) {
    for (unsigned int i = 0; i < size; ++i) {
      unsigned int jobId = jobIds[i];
      unsigned int objectIds[4096];
      unsigned int size = sizeof(objectIds)/sizeof(objectIds[0]);
      if (HSMWorks_getChildObjects(document, jobId, true, objectIds, &size) == STATUS_OK) {
        for (unsigned int i = 0; i < size; ++i) {
          unsigned int objectId = objectIds[i];
          // do something with objectId
        }
      }
    }
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID for which to return the child objects.
  @param recurse Returns the all children if true otherwise only the first level of children. Note that folders/patterns are included in the ids.
  @param flags Flags to control if 
  @param ids The HSMWorks object IDs of the children. The order will match the order in the operation manager.
  @param size The size of ID buffer.
*/
HSMWORKS_API unsigned int HSMWorks_getChildObjects(IUnknown* document, unsigned int id, bool recurse, unsigned int* ids, unsigned int* size);

/**
  Returns STATUS_OK on success. Returns the id of the parent object.

  \since r42793

  unsigned int objectId = 1234; // the object
  unsigned int parentId = 0;
  if (HSMWorks_getParentObject(document, objectId, &parentId) == STATUS_OK) {
    // do something with parentId
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID for which to return the parent object.
  @param parentId The HSMWorks object IDs of the parent.
*/
HSMWORKS_API unsigned int HSMWorks_getParentObject(IUnknown* document, unsigned int id, unsigned int* parentId);

/**
  Returns STATUS_OK on success. ids will be filled with all the ids of the job objects. size will be set the the number of job objects. size must be set initially to the maximum size of the ids buffer.

  unsigned int jobIds[256];
  unsigned int size = sizeof(jobIds)/sizeof(jobIds[0]);
  if (HSMWorks_getJobObjects(document, jobIds, &size) == STATUS_OK) {
    for (unsigned int i = 0; i < size; ++i) {
      unsigned int jobId = jobIds[i];
      // do something with jobId
    }
  }

  @param document The SolidWorks document.
  @param ids The HSMWorks job object IDs.
  @param size The size of ID buffer.
*/
HSMWORKS_API unsigned int HSMWorks_getJobObjects(IUnknown* document, unsigned int* ids, unsigned int* size);

/**
  Returns STATUS_OK if the given id is an object.

  unsigned int objectId = 0;
  if (HSMWorks_isObject(document, objectId) == STATUS_OK) {
    // yes - this is an object
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_isObject(IUnknown* document, unsigned int id);

/**
  Returns STATUS_OK if the given id is a job object.

  unsigned int objectId = 0;
  if (HSMWorks_isJob(document, objectId) == STATUS_OK) {
    // yes - this is a job
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_isJob(IUnknown* document, unsigned int id);

/**
  Returns STATUS_OK if the given id is a folder object.

  unsigned int objectId = 0;
  if (HSMWorks_isFolder(document, objectId) == STATUS_OK) {
    // yes - this is a folder
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_isFolder(IUnknown* document, unsigned int id);

/**
  Returns STATUS_OK if the given id is a pattern object. Note that a pattern is also a folder object.

  \since r42793

  unsigned int objectId = 0;
  if (HSMWorks_isPattern(document, objectId) == STATUS_OK) {
    // yes - this is a pattern folder
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_isPattern(IUnknown* document, unsigned int id);

/**
  Returns STATUS_OK if the given id is "normal" toolpath object. This basically excludes container stye objects.

  \since r43271

  unsigned int objectId = 0;
  if (HSMWorks_isToolpathObject(document, objectId) == STATUS_OK) {
    // yes - e.g. Parallel or Manual NC operation
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_isToolpathObject(IUnknown* document, unsigned int id);

/**
  Returns STATUS_OK if the given object is the default. Only containers can be made default for now.

  unsigned int objectId = 0;
  if (HSMWorks_isDefault(document, objectId) == STATUS_OK) {
    // success
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_isDefault(IUnknown* document, unsigned int id);

/**
  Returns the object ID for the default container. Only containers can be made default for now. Returned object ID might be for a folder.

  \since r43112

  unsigned int objectId = 0;
  if (HSMWorks_getDefaultContainer(document, &objectId) == STATUS_OK) {
    // success
  }

  @param document The SolidWorks document.
  @param objectId The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_getDefaultContainer(IUnknown* document, unsigned int* objectId);

/**
  Returns STATUS_OK if the given object could be made the default. Only containers can be made default for now.

  unsigned int objectId = 0;
  if (HSMWorks_makeDefault(document, objectId) == STATUS_OK) {
    // success
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_makeDefault(IUnknown* document, unsigned int id);

/**
  Removed the specified object.

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_removeObject(IUnknown* document, unsigned int id);

/**
  Returns STATUS_OK if the object with the given description exists. The id will be set to the internal id of the object.

  unsigned int objectId = 0;
  if (HSMWorks_getObjectId(document, objectId, L"Parallel1", &objectId) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param description The HSMWorks object description.
  @param objectId The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_getObjectId(IUnknown* document, const wchar_t* description, unsigned int* objectId);

/**
  Returns STATUS_OK on success. Use this to read the object log for the given object. size of the maximum size of the log buffer.
  
  wchar_t value[64 * 1024];
  unsigned int objectId = 0;
  if (HSMWorks_getObjectLog(document, objectId, value, sizeof(value)/sizeof(value[0])) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param log The log buffer.
  @param size The size of the log buffer. Both input and output.
*/
HSMWORKS_API unsigned int HSMWorks_getObjectLog(IUnknown* document, unsigned int id, wchar_t* log, unsigned int* size);

/**
  Returns STATUS_OK on success.

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_isObjectDirty(IUnknown* document, unsigned int id);

/**
  Returns STATUS_OK on success.

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_isSelected(IUnknown* document, unsigned int id);

/**
  Returns STATUS_OK on success.

  unsigned int objectId = 0;
  if (HSMWorks_setSelected(document, objectId, true) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param selected The selected state.
*/
HSMWORKS_API unsigned int HSMWorks_setSelected(IUnknown* document, unsigned int id, bool selected);

/**
  Returns STATUS_OK on success.

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_isProtected(IUnknown* document, unsigned int id);

/**
  Returns STATUS_OK on success.

  unsigned int objectId = 0;
  if (HSMWorks_setProtected(document, objectId, true) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param protected The protection state.
*/
HSMWORKS_API unsigned int HSMWorks_setProtected(IUnknown* document, unsigned int id, bool _protected);

/**
  Returns STATUS_OK on success.

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_isOptional(IUnknown* document, unsigned int id);

/**
  Returns STATUS_OK on success.

  unsigned int objectId = 0;
  if (HSMWorks_setOptional(document, objectId, true) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param optional The optional state.
*/
HSMWORKS_API unsigned int HSMWorks_setOptional(IUnknown* document, unsigned int id, bool optional);

/**
  Returns STATUS_OK on success.

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
*/
HSMWORKS_API unsigned int HSMWorks_hasObjectWarning(IUnknown* document, unsigned int id);

/**
  Returns STATUS_OK on success. Gets the description of the specified object. size is the maximum size of value buffer.

  wchar_t value[4096];
  unsigned int objectId = 0;
  if (HSMWorks_getObjectDescription(document, objectId, value, sizeof(value)/sizeof(value[0])) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param description The description.
  @param size The size of the value buffer.
*/
HSMWORKS_API unsigned int HSMWorks_getObjectDescription(IUnknown* document, unsigned int id, wchar_t* description, unsigned int size);

/**
  Returns STATUS_OK on success. Sets the description of the specified object.

  unsigned int objectId = 0;
  if (HSMWorks_setObjectDescription(document, objectId, L"Short description") != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param description The description.
*/
HSMWORKS_API unsigned int HSMWorks_setObjectDescription(IUnknown* document, unsigned int id, const wchar_t* description);

/**
  Returns STATUS_OK on success. Gets the notes of the specified object. size is the maximum size of value buffer.

  wchar_t value[4096];
  unsigned int objectId = 0;
  if (HSMWorks_getObjectNotes(document, objectId, value, sizeof(value)/sizeof(value[0])) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param notes The notes.
  @param size The size of the value buffer.
*/
HSMWORKS_API unsigned int HSMWorks_getObjectNotes(IUnknown* document, unsigned int id, wchar_t* notes, unsigned int size);

/**
  Returns STATUS_OK on success. Sets the notes of the specified object.

  unsigned int objectId = 0;
  if (HSMWorks_setObjectNotes(document, objectId, L"This is some long description.") != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param note The note.
*/
HSMWORKS_API unsigned int HSMWorks_setObjectNotes(IUnknown* document, unsigned int id, const wchar_t* notes);

/**
  Returns STATUS_OK on success. Gets the parameter of the specified document. size is the maximum size of value buffer.

  \since r42089

  wchar_t value[4096];
  unsigned int objectId = 0;
  if (HSMWorks_getDocumentParameter(document, name, value, sizeof(value)/sizeof(value[0])) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param name The parameter name.
  @param value The parameter value.
  @param size The size of the value buffer.

  The available parameters are:
    none
*/
HSMWORKS_API unsigned int HSMWorks_getDocumentParameter(IUnknown* document, const wchar_t* name, wchar_t* value, unsigned int size);

/**
  Returns STATUS_OK on success. Gets the parameter of the specified job object. size is the maximum size of value buffer.

  wchar_t value[4096];
  unsigned int objectId = 0;
  if (HSMWorks_getJobParameter(document, objectId, L"postProcessor", value, sizeof(value)/sizeof(value[0])) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks job object ID.
  @param name The parameter name.
  @param value The parameter value.
  @param size The size of the value buffer.

  The available parameters are:
    type
    comment
    
    machineId
    machine (this return the XML representation of the machine)
    postProcessor
    setupSheet

    programName
    programComment
    workOffset
    probeWorkOffset
    multipleWorkOffsets
    numberOfWorkDuplicates
    workOffsetIncrement
*/
HSMWORKS_API unsigned int HSMWorks_getJobParameter(IUnknown* document, unsigned int id, const wchar_t* name, wchar_t* value, unsigned int size);

/**
  Returns STATUS_OK on success. Sets the parameter of the specified object.

  You can use the dump.cps post processor to see the available parameters.

  unsigned int objectId = 0;
  if (HSMWorks_setObjectParameter(document, objectId, L"tolerance", L"0.001") != STATUS_OK) {
    // failed
  }
  if (HSMWorks_setObjectParameter(document, objectId, L"maximumStepdown", L"tool_fluteLength * 0.5") != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param name The parameter name.
  @param value The parameter value.
*/
HSMWORKS_API unsigned int HSMWorks_setObjectParameter(IUnknown* document, unsigned int id, const wchar_t* name, const wchar_t* value);

/**
  Returns STATUS_OK on success. Gets the parameter of the specified object. size is the maximum size of value buffer.

  You can use the dump.cps post processor to set the available parameters.

  wchar_t value[4096];
  unsigned int objectId = 0;
  if (HSMWorks_getObjectParameter(document, objectId, L"tolerance", value, sizeof(value)/sizeof(value[0])) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param name The parameter name.
  @param value The parameter value.
  @param size The size of the value buffer.
*/
HSMWORKS_API unsigned int HSMWorks_getObjectParameter(IUnknown* document, unsigned int id, const wchar_t* name, wchar_t* value, unsigned int size);

/**
  Sets the geometry of the specified object. Returns STATUS_OK on success.
  
  @param document The SolidWorks document.
  @param id The id of the operation.
  @param name identifies the geometry being set and can be any of these:

    For jobs:
      surfaces
      fixture - since r42793
      stock - since r42793

    For folders:
      None

    For operations:
      holes
      centers
      surfaces
      check surfaces
      entry points
      drill positions
      contours
      machining boundaries
      stock boundaries
      rest surfaces

  IUnknown* ids[16]; // fill with SolidWorks geometry references
  if (HSMWorks_setObjectGeometry(document, objectId, "surfaces", ids, sizeof(ids)/sizeof(ids[0])) != STATUS_OK) {
    // failed
  }

  @param ids must be a list of SolidWorks geometry references.
  @param size is the size of the ids buffer.
*/
HSMWORKS_API unsigned int HSMWorks_setObjectGeometry(IUnknown* document, unsigned int id, const wchar_t* name, IUnknown** ids, unsigned int size);

/** Flags to be set on geometry entities for use with HSMWorks_setObjectGeometry2(). Check user interface to which flags are supported for a given strategy. */
enum class GeometryFlags {
  FLAG_REVERSE = 1 << 0, ///< Reverse direction of contour.
  FLAG_CHAIN_ALONG_Z = 1 << 1, ///< Continue along Z for contour.
  FLAG_CHAIN_TANGENT = 1 << 2, ///< Continue along tangent for contour.
  FLAG_CHAIN_RADIALLY = 1 << 3, ///< Continue along radius for contour.
  FLAG_SELECT_SAME_DIAMETER = 1 << 4 ///< Select same diameters for drilling.
};

/**
  Sets the geometry of the specified object. Returns STATUS_OK on success.
  
  \since r43429

  @param document The SolidWorks document.
  @param id The id of the operation.
  @param name identifies the geometry being set and can be any of these:

    For jobs:
      surfaces
      fixture - since r42793
      stock - since r42793

    For folders:
      None

    For operations:
      holes
      centers
      surfaces
      check surfaces
      entry points
      drill positions
      contours
      machining boundaries
      stock boundaries
      rest surfaces

  IUnknown* ids[16]; // fill with SolidWorks geometry references
  unsigned int flags[16] = {0};
  if (HSMWorks_setObjectGeometry2(document, objectId, "surfaces", ids, flags, sizeof(ids)/sizeof(ids[0])) != STATUS_OK) {
    // failed
  }

  @param ids must be a list of SolidWorks geometry references.
  @param flags must be a list of flags to set on each geometry reference. May be nullptr. Otherwise it must have the same size as ids array.
  @param size is the size of the ids buffer.
*/
HSMWORKS_API unsigned int HSMWorks_setObjectGeometry2(IUnknown* document, unsigned int id, const wchar_t* name, IUnknown** ids, const unsigned int* flags, unsigned int size);


/**
  Gets the geometry of the specified object. Returns STATUS_OK on success.

  @param document The SolidWorks document.
  @param id The id of the operation.
  @param name identifies the geometry to be retrieved. Can be any of these:

    For jobs:
      surfaces
      fixture
      stock

    For folders:
      None

    For operations:
      holes
      centers
      surfaces
      check surfaces
      entry points
      drill positions
      contours
      machining boundaries
      stock boundaries
      rest surfaces

  IUnknown* ids[16]; // fill with SolidWorks geometry references
  unsigned int flags[16];
  unsigned int numReferences = sizeof(ids)/sizeof(ids[0]);
  if (HSMWorks_getObjectGeometry(document, objectId, "surfaces", ids, flags, &numReferences) == STATUS_OK) {
    // Process references
    for (unsigned int i = 0; i < numReferences; i++) {
      ids[i] ...
      flags[i] ...
    }
  }

  @param ids will be filled with a list of SolidWorks geometry references.
  @param flags will be filled with a list of corresponding GeometryFlags values - one for each returned reference.
  @param size is the size of the ids buffer on input, and will be set to the actual number of references returned on output.
*/
HSMWORKS_API unsigned int HSMWorks_getObjectGeometry(IUnknown* document, unsigned int id, const wchar_t* name, IUnknown** ids, unsigned int* flags, unsigned int* size);


/**
  Returns STATUS_OK on success. Returns the path of the specified object in the CAM manager. size is the maximum size of value buffer.

  wchar_t path[4096];
  if (HSMWorks_getObjectPath(document, objectId, path, sizeof(path)/sizeof(path[0])) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param path The path.
  @param size The size of the value buffer.
*/
HSMWORKS_API unsigned int HSMWorks_getObjectPath(IUnknown* document, unsigned int id, wchar_t* value, unsigned int size);

/**
  Returns STATUS_OK on success. Sets the tool of the specified object.

  const wchar_t* toolId = L"{9CFDBD64-1ED2-47d7-AA87-D634BD0AAB35}"; // you can seee this in the tool library
  if (HSMWorks_setObjectToolId(document, objectId, toolId)) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param toolId The internal GUID identifying the tool. Use empty string or 0 to remove tool from object.
*/
HSMWORKS_API unsigned int HSMWorks_setObjectToolById(IUnknown* document, unsigned int id, const wchar_t* toolId);

/**
  Returns STATUS_OK on success. Returns the GUID of the selected tool of the specified object. The tool must exist in the document tool table.

  wchar_t toolId[256];
  unsigned int objectId = 0;
  if (HSMWorks_getObjectToolId(document, objectId, toolId, sizeof(toolId)/sizeof(toolId[0])) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param toolId The internal GUID identifying the tool.
  @param size The size of the toolId buffer.
*/
HSMWORKS_API unsigned int HSMWorks_getObjectToolId(IUnknown* document, unsigned int id, wchar_t* toolId, unsigned int size);

/**
  Returns the number of tools in the document.

  \since r43112

  @param document The SolidWorks document.
  @param numberOfTools The returned number of tools in the document.
*/
HSMWORKS_API unsigned int HSMWorks_getNumberOfTools(IUnknown* document, unsigned int* numberOfTools);

/**
  Returns the GUID of the tool of the specified object. The tool must exist in the document tool table.

  \since r43112

  unsigned int numberOfTools = 0;
  if (HSMWorks_getNumberOfTools(document, &numberOfTools) != STATUS_OK) {
    // failed
  }
  for (unsigned int i = 0; i < numberOfTools; ++i) {
    wchar_t toolId[256];
    if (HSMWorks_getToolById(document, i, toolId, sizeof(toolId)/sizeof(toolId[0])) != STATUS_OK) {
      break; // failed
    }
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param toolId The internal GUID identifying the tool.
  @param size The size of the toolId buffer.
*/
HSMWORKS_API unsigned int HSMWorks_getToolIdByIndex(IUnknown* document, unsigned int index, wchar_t* toolId, unsigned int size);

/**
  Returns the tool id for the first tool found in the document with the given tool number.

  \since r43112

  @param document The SolidWorks document.
  @param number The tool number.
  @param toolId The internal GUID identifying the tool.
  @param size The size of the toolId buffer.
*/
HSMWORKS_API unsigned int HSMWorks_getToolIdByNumber(IUnknown* _document, unsigned int number, wchar_t* toolId, unsigned int size);

/**
  Returns STATUS_OK is the given tool exists in the document.

  \since r43378

  @param document The SolidWorks document.
  @param toolId The internal GUID identifying the tool.
*/
HSMWORKS_API unsigned int HSMWorks_hasToolId(IUnknown* _document, const wchar_t* toolId);

/**
  Import tool from library into document. Returns STATUS_OK on success. If tool already exists it may be overwritten. You should avoid this case.

  Make sure that the imported tool has the appropriate tool number, diameter offset, length offset, and coolant defined to post processing.

  \since r43378

  const wchar_t* toolId = L"{ad85e657-81af-4263-b8d8-9069bcc8a999}"; // you can seee this in the tool library
  const wchar_t* libraryPath = L"C:\\Program Files\\HSMWorks\\libraries\\Metric - Titanium.hsmlib";
  if (HSMWorks_importToolById(document, toolId, libraryPath)) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param toolId The internal GUID identifying the tool.
  @param libraryPath The path of the tool library. If nullptr all open libraries will be searched.
*/
HSMWORKS_API unsigned int HSMWorks_importToolById(IUnknown* document, const wchar_t* toolId, const wchar_t* libraryPath);

/**
  Create object.

  unsigned int defaultId = 0;
  status = HSMWorks_getDefaultContainer(document, &defaultId);
  if (status != STATUS_OK) {
    // failed
  }

  unsigned int objectId = 0;
  if (HSMWorks_createObject(document, L"My description", L"new_contour", defaultId, &objectId) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param description The description of the object. nullptr is allowed in which case a default description is used.
  @param strategy The strategy. Must be a toolpath strategy.
  @param containerId The id of the job or folder in which to create the object. Set to 0 to use default container.
  @param objectId The id of the created object on success.
*/
HSMWORKS_API unsigned int HSMWorks_createObject(IUnknown* document, const wchar_t* description, const wchar_t* strategy, int containerId, unsigned int* objectId);

/**
  Create object.

  \since r43274

  unsigned int objectId = 0;
  if (HSMWorks_createObject2(document, L"My description", L"new_contour", 0, true, &objectId) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param description The description of the object. nullptr is allowed in which case a default description is used.
  @param strategy The strategy. Must be a toolpath strategy.
  @param containerId The id of the job or folder in which to create the object. Set to 0 to use default container.
  @param silent When true the main edit dialog will be skipped.
  @param objectId The id of the created object on success.
*/
HSMWORKS_API unsigned int HSMWorks_createObject2(IUnknown* document, const wchar_t* description, const wchar_t* strategy, int containerId, bool silent, unsigned int* objectId);

/** A 3D vector. */
struct HSMWorks_Vector {
  double x;
  double y;
  double z;
};

/**
  Interface for setting toolpath.

  \since r43112
*/
typedef void HSMWorks_Toolpath;

/**
  Callback function used with HSMWorks_setToolpath().

  \since r43112

  @return Return true on success.
*/
typedef bool HSMWorks_CreateToolpath(HSMWorks_Toolpath* toolpath, void* context);

/**
  Used from HSMWorks_CreateToolpath() callback. OnOpen() must be called last to complete the toolpath.

  \since r43112

  @param toolpath The toolpath object.
*/
HSMWORKS_API bool HSMWorks_onOpen(HSMWorks_Toolpath* toolpath);

/**
  Used from HSMWorks_CreateToolpath() callback. Sets the tool by the tool id - must be called before onSection().

  \since r43112

  @param toolpath The toolpath object.
  @param toolId The tool ID as given by xxx.
*/
HSMWORKS_API bool HSMWorks_onTool(HSMWorks_Toolpath* _toolpath, const wchar_t* toolId);

/**
  Used from HSMWorks_CreateToolpath() callback. Sets the context - must be called before onSection().

  \since r43112

  @param toolpath The toolpath object.
  @param toolView The tool view frame in millimeters. See HSMWorks_getObjectToolView() for layout.
*/
HSMWORKS_API bool HSMWorks_onContext(HSMWorks_Toolpath* toolpath, const double toolView[16]);

/**
  Used from HSMWorks_CreateToolpath() callback. Starts the toolpath geometry.

  \since r43112

  @param toolpath The toolpath object.
*/
HSMWORKS_API bool HSMWorks_onSection(HSMWorks_Toolpath* toolpath);

/**
  Used from HSMWorks_CreateToolpath() callback. Dangerous - avoid this. Undocumented.

  \since r43112

  @param toolpath The toolpath object.
  @param name Internal id.
  @param value The value.
*/
HSMWORKS_API bool HSMWorks_onParameterString(HSMWorks_Toolpath* toolpath, const char* name, const char* value);

/**
  Used from HSMWorks_CreateToolpath() callback. Dangerous - avoid this. Undocumented.
  
  \since r43112

  @param toolpath The toolpath object.
  @param name Internal id.
  @param value The value.
*/
HSMWORKS_API bool HSMWorks_onParameterInteger(HSMWorks_Toolpath* toolpath, const char* name, int value);

/**
  Used from HSMWorks_CreateToolpath() callback. Dangerous - avoid this. Undocumented.

  \since r43112

  @param toolpath The toolpath object.
  @param name Internal id.
  @param value The value.
*/
HSMWORKS_API bool HSMWorks_onParameterDouble(HSMWorks_Toolpath* toolpath, const char* name, double value);

/**
  Used from HSMWorks_CreateToolpath() callback. Dangerous - avoid this. Undocumented.

  \since r43112

  @param toolpath The toolpath object.
  @param id Internal id.
*/
HSMWORKS_API bool HSMWorks_onGroup(HSMWorks_Toolpath* toolpath, const char* id);

/**
  Used from HSMWorks_CreateToolpath() callback. Dangerous - avoid this. Undocumented.

  \since r43112
  
  @param toolpath The toolpath object.
*/
HSMWORKS_API bool HSMWorks_onGroupEnd(HSMWorks_Toolpath* toolpath);

/**
  Used from HSMWorks_CreateToolpath() callback. Only use this within a section.

  \since r43112

  @param toolpath The toolpath object.
  @param time The dwelling in seconds.
*/
HSMWORKS_API bool HSMWorks_onDwell(HSMWorks_Toolpath* toolpath, double time);

/**
  Used from HSMWorks_CreateToolpath() callback. Only use this within a section.

  \since r43112

  @param toolpath The toolpath object.
  @param spindleSpeed The spindle speed in RPM.
*/
HSMWORKS_API bool HSMWorks_onSpindleSpeed(HSMWorks_Toolpath* toolpath, double spindleSpeed);

/**
  Used from HSMWorks_CreateToolpath() callback. Only use this within a section.

  \since r43112

  @param toolpath The toolpath object.
  @param end The end point of the move.
*/
HSMWORKS_API bool HSMWorks_onRapid(HSMWorks_Toolpath* toolpath, const HSMWorks_Vector& end);

/**
  Used from HSMWorks_CreateToolpath() callback. Only use this within a section.

  \since r43112

  @param toolpath The toolpath object.
  @param end The end point of the move.
  @param feedrate The feedrate for the move.
*/
HSMWORKS_API bool HSMWorks_onLinear(HSMWorks_Toolpath* toolpath, const HSMWorks_Vector& end, double feedrate);

/**
  Used from HSMWorks_CreateToolpath() callback. A section cannot start with a circular move. Only use this within a section.

  \since r43112

  @param toolpath The toolpath object.
  @param end The end point of the ciruclar move.
  @param center The center point of the ciruclar move.
  @param normal The normal of the ciruclar plane. The move is CCW (right hand rule).
  @param feedrate The feedrate for the move.
*/
HSMWORKS_API bool HSMWorks_onCircular(HSMWorks_Toolpath* toolpath, const HSMWorks_Vector& end, const HSMWorks_Vector& center, const HSMWorks_Vector& normal, double feedrate);

/**
  Used from HSMWorks_CreateToolpath() callback. Only use this within a section.

  \since r43112

  @param toolpath The toolpath object.
  @param end The end point of the ciruclar move.
  @param zAxis The tool axis / local Z at end point.
*/
HSMWORKS_API bool HSMWorks_onRapid5D(HSMWorks_Toolpath* toolpath, const HSMWorks_Vector& end, const HSMWorks_Vector& zAxis);

/**
  Used from HSMWorks_CreateToolpath() callback. Only use this within a section.

  \since r43112

  @param toolpath The toolpath object.
  @param end The end point of the ciruclar move.
  @param zAxis The tool axis / local Z at end point.
  @param feedrate The feedrate for the move.
*/
HSMWORKS_API bool HSMWorks_onLinear5D(HSMWorks_Toolpath* toolpath, const HSMWorks_Vector& end, const HSMWorks_Vector& zAxis, double feedrate);

/**
  Used from HSMWorks_CreateToolpath() callback. Ends the toolpath geometry that was started with HSMWorks_onSection().

  \since r43112

  @param toolpath The toolpath object.
*/
HSMWORKS_API bool HSMWorks_onSectionEnd(HSMWorks_Toolpath* toolpath);

/**
  Used from HSMWorks_CreateToolpath() callback. OnClose() must be called last to complete the toolpath.

  \since r43112

  @param toolpath The toolpath object.
*/
HSMWORKS_API bool HSMWorks_onClose(HSMWorks_Toolpath* toolpath);

/**
  Sets the toolpath for the given CLD object. Only milling toolpath is supported.

  \since r43112

  bool createToolpath(HSMWorks_Toolpath* toolpath, void* context) {
    ISldWorksPtr sw = SwApp::GetSldWorks();
    if (!sw) {
      return false;
    }
    IUnknownPtr document = sw->GetActiveDoc();

    unsigned int numberOfTools = 0;
    unsigned int status = HSMWorks_getNumberOfTools(document, &numberOfTools);
    if (status != STATUS_OK) {
      return false;
    }
    wchar_t toolId[256];
    for (unsigned int i = 0; i < numberOfTools; ++i) {
      status = HSMWorks_getToolIdByIndex(document, i, toolId, lengthOf(toolId));
      if (status != STATUS_OK) {
        return false;
      }
      break; // just use the first tool found
    }

    if (!HSMWorks_onOpen(toolpath)) {
      return false;
    }

    if (!HSMWorks_onTool(toolpath, toolId)) {
      return false;
    }

    const double toolView[16] = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 };

    if (!HSMWorks_onContext(toolpath, toolView)) {
      return false;
    }
    if (!HSMWorks_onSection(toolpath)) {
      return false;
    }
    if (!HSMWorks_onRapid(toolpath, makeVector(0, 0, 100))) {
      return false;
    }
    double feedrate = 100;
    if (!HSMWorks_onLinear(toolpath, makeVector(0, 0, 100), feedrate)) {
      return false;
    }
    if (!HSMWorks_onLinear(toolpath, makeVector(0, 0, 10), feedrate)) {
      return false;
    }
    feedrate = 200;
    if (!HSMWorks_onLinear(toolpath, makeVector(-100, -100, 10), feedrate)) {
      return false;
    }
    if (!HSMWorks_onSpindleSpeed(toolpath, 1234)) {
      return false;
    }
    if (!HSMWorks_onDwell(toolpath, 2)) {
      return false;
    }
    if (!HSMWorks_onLinear(toolpath, makeVector(-100, 100, 10), feedrate)) {
      return false;
    }
    if (!HSMWorks_onRapid(toolpath, makeVector(-100, 100, 100))) {
      return false;
    }
    if (!HSMWorks_onSectionEnd(toolpath)) {
      return false;
    }
    if (!HSMWorks_onClose(toolpath)) {
      return false;
    }
    return true;
  }

  unsigned int objectId = 0;
  if (HSMWorks_createObject(document, L"cld", L"External toolpath", 0, &objectId) != STATUS_OK) {
    // failed
  }
  void* context = nullptr; // use for your own purpose
  if (HSMWorks_setToolpath(document, objectId, createToolpath, context) != STATUS_OK) {
    // failed
  }

  @param document The SolidWorks document.
  @param id The object id. Must be "cld" strategy.
  @param toolpath The toolpath callback.
  @param context The toolpath callback context.
*/
HSMWORKS_API unsigned int HSMWorks_setToolpath(IUnknown* document, unsigned int id, HSMWorks_CreateToolpath* toolpath, void* context);

/**
  Returns STATUS_OK if all tasks are aborted.

  @param document The SolidWorks document.
*/
HSMWORKS_API unsigned int HSMWorks_abortAllTasks(IUnknown* document);

/**
  Returns STATUS_OK if all toolpath operations are valid.

  @param document The SolidWorks document.
*/
HSMWORKS_API unsigned int HSMWorks_checkAllToolpath(IUnknown* document);

/**
  Sets the WCS of the given Job.

  @param document The SolidWorks document.
  @param id The object id of the job.
  @param originMode The origin mode.
  @param orientationMode The orientation mode.
  @param originId The SolidWorks geometry reference for the origin. May be nullptr.
  @param orientationId The SolidWorks geometry reference for the orientation. May be nullptr.
*/
HSMWORKS_API unsigned int HSMWorks_setJobWCS(IUnknown* document, unsigned int id, const wchar_t* originMode, const wchar_t* orientationMode, IUnknown* originId, IUnknown* orientationId);

/**
  Returns the WCS for the given job relative to the global SolidWorks frame of reference.
  
  \since r43112

  A frame is row-major (translation is in mm):

  [Right_x, Up_x, Forward_x, Translation_x]
  [Right_y, Up_y, Forward_y, Translation_y]
  [Right_z, Up_z, Forward_z, Translation_z]
  [0,       0,    0,         1            ]

  @param document The SolidWorks document.
  @param id The object id of the job.
  @param frame The frame in millimeters. Uses right-hand rule.
*/

HSMWORKS_API unsigned int HSMWorks_getJobWCS(IUnknown* document, unsigned int id, double (&frame)[16]);

/**
  Sets the tool view (frame) for the given operation, using either a WCS or an origin + orientation.

  \since r43493

  @param document The SolidWorks document.
  @param id The object id of the job.
  @param viewSelectionMode The selection mode -- either "coordinateSystem" or "originAndOrientation"
  @param originId The object to use as the origin (using "originAndOrientation) or the WCS (using "coordinateSystem")
  @param orientationId The object to use as the orientation plane (using "originAndOrientation")
*/
HSMWORKS_API unsigned int HSMWorks_setObjectToolView(IUnknown* document, unsigned int id, const wchar_t* viewSelectionMode, IUnknown* originId, IUnknown* orientationId);

/**
  Returns the tool view (frame) for the given operation relative to the global SolidWorks frame of reference.

  \since r43112

  A frame is row-major (translation is in mm):

  [Right_x, Up_x, Forward_x, Translation_x]
  [Right_y, Up_y, Forward_y, Translation_y]
  [Right_z, Up_z, Forward_z, Translation_z]
  [0,       0,    0,         1            ]

  @param document The SolidWorks document.
  @param id The object id of the job.
  @param frame The frame in millimeters. Uses right-hand rule.
*/
HSMWORKS_API unsigned int HSMWorks_getObjectToolView(IUnknown* document, unsigned int id, double(&_frame)[16]);

/**
  Export all toolpath to the specified path. CNC format.

  Returns STATUS_FAILED if no toolpath operations are available.

  Use post.exe to convert to NC code. E.g.:
  post --noeditor --property programName 1234 -- property programComment comment --property unit 1 mypost.cps test.cnc test.nc

  @param document The SolidWorks document.
  @param path The destination path.
*/
HSMWORKS_API unsigned int HSMWorks_exportAll(IUnknown* document, const wchar_t* path);

/**
  Export all toolpath for the specified object (would normally be a job or folder). CNC format.

  Returns STATUS_FAILED if no toolpath operations are available.

  Use post.exe to convert to NC code. E.g.:
  post --noeditor --property programName 1234 -- property programComment comment --property unit 1 mypost.cps test.cnc test.nc

  Note the quotes '' which indicates a JavaScript string literal.

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param path The destination path.
*/
HSMWORKS_API unsigned int HSMWorks_export(IUnknown* document, unsigned int id, const wchar_t* path);

/**
  Post processes all toolpath for the specified object (would normally be a job or folder).

  \since r43312

  Returns STATUS_FAILED if no toolpath operations are available.

  The check the individual posts for documentation of the available properties.

  Note that property 'programName' is often a required property and note that
  program name is commonly used as the O-number in which case it must be
  convertible to a number within the allowed range of the CNC. JSON output
  could look like:

  {\"programName\":\"1234\",\"programComment\":\"My program comment\",\"tolerance\":0.01}

  Built-in properties will be in mm unit. Check post for unit for post
  specific properties. Also make sure to pay attention to the type of the
  values. The type must generally be a string, integer, floating point number,
  or boolean.

  unsigned int objectId = 0; // e.g. get some Job object
  unsigned int unit = 1; // mm
  const char* properties = "{\"programName\":\"1234\",\"programComment\":\"My comment\",\"tolerance\":0.01}";
  const wchar_t* configPath = L"C:\\Program Files\\HSMWorks\\posts\\haas.cps";
  const wchar_t* outputPath = L"C:\\ncprograms\\myprogram.nc";
  unsigned int status = HSMWorks_postProcess(document, objectId, unit, properties, configPath, outputPath, nullptr, nullptr);

  @param document The SolidWorks document.
  @param id The HSMWorks object ID.
  @param unit The output unit (0 for inches and 1 for mm).
  @param properties The properties to send to the post encoded in JSON.
  @param configPath The post configuration path.
  @param outputPath The main output path. Note that the post could generated additional files. A log will be generated using extension "log" in the same folder as the output file.
  @param progress Callback for progress and abort support. May be nullptr.
  @param context Progress context.
*/
HSMWORKS_API unsigned int HSMWorks_postProcess(IUnknown* document, unsigned int id, unsigned int unit, const char* properties, const wchar_t* configPath, const wchar_t* outputPath, HSMWorks_Progress progress, void* context);

/**
  Toolpath statistics returned by HSMWorks_getToolpathStats(). Note that all values are metric.
  
  You can estimate the machining time by this formula:
    machiningTime = AVERAGE_TOOL_CHANGE_TIME * numberOfToolChanges + AVERAGE_RAPID_FEED * rapidDistance + PENALTY_RATIO * feedTime + dwellingTime
*/
struct HSMWorks_ToolpathStats {
  double leadDistance; ///< The lead move distance. Unit MM.
  double cuttingDistance; ///< The cutting move distance. Unit MM.
  double rapidDistance; ///< The rapid move move distance. Unit MM.
  double linearDistance; ///< The total linear move distance. Unit MM.
  double circularDistance; ///< The total circular move distance. Unit MM.
  double feedTime; ///< The total time spend on feed moves. Unit MIN.
  double dwellingTime; ///< The total time spend dwelling. Unit S (not MIN!).
  double spindleSpeedMin; ///< The minimum spindle speed. Unit RPM.
  double spindleSpeedMax; ///< The maximum spindle speed. Unit RPM.
  double feedrateMin; ///< The minimum feedrate. Unit MM/MIN.
  double feedrateMax; ///< The maximum feedrate. Unit MM/MIN.
  double reserved1[32-11]; ///< Unused.
  unsigned int numberOfToolChanges; ///< The total number of tool changes.
  unsigned int reserved2[32-1]; // Unused.
};

/** Settings that control the toolpath statistics. */
struct HSMWorks_ToolpathStatsControls {
  double maximumSpindleRPM; ///< The maximum supported spindle speed. Unit RPM.
  double reserved1[16-1]; ///< Unused.
  unsigned int reserved2[16]; // Unused.
};

/**
  Analyze all toolpath for the specified object. The object would normally be a job or folder but can also be a single toolpath object.

  \since r42089

  Returns STATUS_FAILED if no toolpath operations are available.

  HSMWorks_ToolpathStatsControls controls;
  memset(&controls, 0, sizeof(controls)); // zero clear is required
  controls.maximumSpindleRPM = 10000;

  HSMWorks_ToolpathStats stats;
  memset(&stats, 0, sizeof(stats)); // zero clear is required

  status = HSMWorks_getToolpathStats(document, objectId, &controls, &stats);
  if (status != STATUS_OK) {
    return;
  }
  if (stats.numberOfToolChanges == 1) {
    // only one tool
  }

  @param document The SolidWorks document.
  @param id The HSMWorks object ID. If you use 0xffffffff then all jobs will be included.
  @param controls Settings that control the statistics. May be nullptr.
  @param stats The returned toolpath statistics. You MUST zero clear the stats variable before passing it to HSMWorks_getToolpathStats(). Stats is only modified if STATUS_OK is returned.
*/
HSMWORKS_API unsigned int HSMWorks_getToolpathStats(IUnknown* document, unsigned int id, HSMWorks_ToolpathStatsControls* controls, HSMWorks_ToolpathStats* stats);

}
