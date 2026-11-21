# wfc-comdlg32: Common Dialog (comdlg32.ocx, library MSComDlg).
#
# The member table is written by hand from the documented members.
# The table is built static by default; WFC_COMDLG32_SHARED builds it as
# comdlg32.ocx so a program can load it at run time instead. The version is
# the one in VERSION and is stamped into the DLL's version resource.
#
# Parent project variables used when present: WFC_OCX_SHARED (the default of
# WFC_COMDLG32_SHARED), WFC_COMDLG32_TEST_PREFIX (below) and the functions
# wfc_enable_strict_warnings and wsp_enable_hardening.
#
# CTest names: inside this repository a test is named TC-NNNN-<name>. When
# another project mounts the library (the WFC repository adds it as
# lib/wfc-comdlg32), every name is WFC_COMDLG32_TEST_PREFIX + TC-NNNN-<name>,
# the prefix being "wfc-comdlg32-" unless the including project sets the
# variable (also to the empty string) before add_subdirectory. The names of
# different libraries then never collide. The TC-NNNN identifier is the same
# in both. Labels do not change.
if(NOT DEFINED WFC_COMDLG32_TEST_PREFIX)
  if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    set(WFC_COMDLG32_TEST_PREFIX "")
  else()
    set(WFC_COMDLG32_TEST_PREFIX "wfc-comdlg32-")
  endif()
endif()

# Standalone build: the library outside WFC. WFC itself adds this directory
# with add_subdirectory and supplies the project, CTest and the WSP hardening.
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  cmake_minimum_required(VERSION 3.28)
  project(wfc-comdlg32 LANGUAGES CXX)
  if(WFC_WINELIB)
    # winegcc writes name.exe (a launcher) and name.exe.so; the platform module
    # resets the suffix when the project is declared, so it is set here.
    set(CMAKE_EXECUTABLE_SUFFIX ".exe")
  endif()
  option(WFC_BUILD_TESTS "Build the tests" ON)
  include(CTest)
  list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
  include(WfcWarnings)
  # WSP-SEC-0015: the pinned WSP baseline supplies the hardening flags (not for
  # the WebAssembly and Winelib targets, whose toolchains do not take them).
  if(
    EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/wsp/tools/cmake/WspBuild.cmake"
    AND NOT EMSCRIPTEN
    AND NOT WFC_WINELIB
  )
    include("${CMAKE_CURRENT_SOURCE_DIR}/wsp/tools/cmake/WspBuild.cmake")
  endif()
endif()

if(NOT DEFINED WFC_OCX_SHARED)
  set(WFC_OCX_SHARED OFF)
endif()
option(
  WFC_COMDLG32_SHARED
  "Build the WFC comdlg32 library as comdlg32.ocx"
  ${WFC_OCX_SHARED}
)

file(
  STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/VERSION"
  WFC_COMDLG32_VERSION
  LIMIT_COUNT 1
)
set(
  WFC_COMDLG32_VERSION
  "${WFC_COMDLG32_VERSION}"
  CACHE INTERNAL
  "wfccomdlg32 version"
)

set(WFC_COMDLG32_SOURCES src/comdlg32_tables.cpp)

if(WFC_COMDLG32_SHARED AND WIN32)
  enable_language(RC)
  string(REPLACE "." ";" version_parts "${WFC_COMDLG32_VERSION}")
  list(GET version_parts 0 WFC_LIB_VERSION_MAJOR)
  list(GET version_parts 1 WFC_LIB_VERSION_MINOR)
  list(GET version_parts 2 WFC_LIB_VERSION_PATCH)
  set(WFC_LIB_VERSION "${WFC_COMDLG32_VERSION}")
  file(
    STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/TARGET"
    WFC_LIB_TARGET
    LIMIT_COUNT 1
  )
  configure_file(
    src/registration_info.hpp.in
    "${CMAKE_CURRENT_BINARY_DIR}/registration_info.hpp"
    @ONLY
  )
  set(WFC_LIB_NAME wfccomdlg32)
  set(WFC_LIB_FILE comdlg32.ocx)
  set(WFC_LIB_DESCRIPTION "WFC Common Dialog")
  configure_file(
    version.rc.in
    "${CMAKE_CURRENT_BINARY_DIR}/wfccomdlg32.rc"
    @ONLY
  )
  add_library(
    wfc_comdlg32
    SHARED
    ${WFC_COMDLG32_SOURCES}
    src/registration.cpp
    src/wfccomdlg32.def
    "${CMAKE_CURRENT_BINARY_DIR}/wfccomdlg32.rc"
  )
  target_include_directories(wfc_comdlg32 PRIVATE "${CMAKE_CURRENT_BINARY_DIR}")
  target_link_libraries(wfc_comdlg32 PRIVATE advapi32 ole32 oleaut32)
  target_compile_definitions(
    wfc_comdlg32
    PUBLIC WFC_COMDLG32_SHARED
    PRIVATE WFC_COMDLG32_BUILD_DLL
  )
  set_target_properties(
    wfc_comdlg32
    PROPERTIES
      OUTPUT_NAME comdlg32
      SUFFIX ".ocx"
      ARCHIVE_OUTPUT_NAME wfccomdlg32
      PDB_NAME wfccomdlg32
      VERSION "${WFC_COMDLG32_VERSION}"
      RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
  )
else()
  add_library(wfc_comdlg32 STATIC ${WFC_COMDLG32_SOURCES})
  set_target_properties(wfc_comdlg32 PROPERTIES OUTPUT_NAME wfccomdlg32_static)
endif()
target_include_directories(
  wfc_comdlg32
  PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include"
)
target_compile_features(wfc_comdlg32 PRIVATE cxx_std_20)
if(COMMAND wfc_enable_strict_warnings)
  wfc_enable_strict_warnings(wfc_comdlg32)
endif()
if(COMMAND wsp_enable_hardening)
  wsp_enable_hardening(wfc_comdlg32)
endif()

# --- Tests --------------------------------------------------------------------
# The table (any build) and, in the shared build, the DLL itself: a C program
# loads comdlg32.ocx, checks its COM entry points and version resource, and
# registers and unregisters it in the registry of the current user.
if(BUILD_TESTING AND WFC_BUILD_TESTS)
  add_executable(comdlg32_tables_test tests/comdlg32_tables_test.cpp)
  target_link_libraries(comdlg32_tables_test PRIVATE wfc_comdlg32)
  if(WFC_COMDLG32_SHARED)
    # Next to the DLL, so the program finds it.
    set_target_properties(
      comdlg32_tables_test
      PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
  endif()
  target_compile_features(comdlg32_tables_test PRIVATE cxx_std_20)
  if(COMMAND wfc_enable_strict_warnings)
    wfc_enable_strict_warnings(comdlg32_tables_test)
  endif()
  if(COMMAND wsp_enable_hardening)
    wsp_enable_hardening(comdlg32_tables_test)
  endif()
  add_test(
    NAME ${WFC_COMDLG32_TEST_PREFIX}TC-0002-comdlg32-tables
    COMMAND comdlg32_tables_test
  )
  set_tests_properties(
    ${WFC_COMDLG32_TEST_PREFIX}TC-0002-comdlg32-tables
    PROPERTIES LABELS "unit;mp-0010;comdlg32" TIMEOUT 120
  )

  add_executable(comdlg32_dialogs_test tests/dialogs_test.cpp)
  target_link_libraries(comdlg32_dialogs_test PRIVATE wfc_comdlg32)
  if(WFC_COMDLG32_SHARED)
    # Next to the DLL, so the program finds it.
    set_target_properties(
      comdlg32_dialogs_test
      PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
  endif()
  target_compile_features(comdlg32_dialogs_test PRIVATE cxx_std_20)
  if(COMMAND wfc_enable_strict_warnings)
    wfc_enable_strict_warnings(comdlg32_dialogs_test)
  endif()
  if(COMMAND wsp_enable_hardening)
    wsp_enable_hardening(comdlg32_dialogs_test)
  endif()
  add_test(
    NAME ${WFC_COMDLG32_TEST_PREFIX}TC-0003-comdlg32-dialogs
    COMMAND comdlg32_dialogs_test
  )
  set_tests_properties(
    ${WFC_COMDLG32_TEST_PREFIX}TC-0003-comdlg32-dialogs
    PROPERTIES LABELS "unit;mp-0010;comdlg32" TIMEOUT 120
  )

  if(WIN32 AND WFC_COMDLG32_SHARED)
    enable_language(C)
    add_executable(comdlg32_dll_test tests/comdlg32_dll_test.c)
    target_link_libraries(comdlg32_dll_test PRIVATE version advapi32)
    add_dependencies(comdlg32_dll_test wfc_comdlg32)
    if(MSVC)
      target_compile_options(comdlg32_dll_test PRIVATE /W4 /WX)
    else()
      target_compile_options(comdlg32_dll_test PRIVATE -Wall -Wextra -Werror)
    endif()
    if(COMMAND wsp_enable_hardening)
      wsp_enable_hardening(comdlg32_dll_test)
    endif()
    add_test(
      NAME ${WFC_COMDLG32_TEST_PREFIX}TC-0001-comdlg32-dll
      COMMAND
        comdlg32_dll_test "$<TARGET_FILE:wfc_comdlg32>"
        "${WFC_COMDLG32_VERSION}" "${WFC_LIB_TARGET}"
    )
    set_tests_properties(
      ${WFC_COMDLG32_TEST_PREFIX}TC-0001-comdlg32-dll
      PROPERTIES
        LABELS "integration;mp-0010;comdlg32"
        RESOURCE_LOCK registry
        SKIP_RETURN_CODE 77
    )
  endif()
endif()

# --- Corpus case (standalone build) -------------------------------------------
# TC-0004 runs a corpus program with the WFC interpreter. Inside WFC the parent
# registers every corpus case itself, so only the standalone build adds it, and
# only when a WFC executable is found (WFC_EXECUTABLE, WFC_EXE or PATH).
if(
  CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR
  AND BUILD_TESTING
  AND WFC_BUILD_TESTS
)
  set(WFC_EXECUTABLE "" CACHE FILEPATH "wfc.exe for the corpus test case")
  if(NOT WFC_EXECUTABLE AND DEFINED ENV{WFC_EXE})
    set(WFC_EXECUTABLE "$ENV{WFC_EXE}")
  endif()
  if(NOT WFC_EXECUTABLE)
    find_program(WFC_EXECUTABLE_FOUND NAMES wfc)
    set(WFC_EXECUTABLE "${WFC_EXECUTABLE_FOUND}")
  endif()
  find_program(WFC_PWSH NAMES pwsh)
  if(WFC_EXECUTABLE AND WFC_PWSH)
    add_test(
      NAME ${WFC_COMDLG32_TEST_PREFIX}TC-0004-win-dialogs-classes
      COMMAND
        "${WFC_PWSH}" -NoProfile -File
        "${CMAKE_CURRENT_SOURCE_DIR}/tests/run-tc-0004-win-dialogs-classes.ps1"
        -Wfc "${WFC_EXECUTABLE}"
    )
    set_tests_properties(
      ${WFC_COMDLG32_TEST_PREFIX}TC-0004-win-dialogs-classes
      PROPERTIES LABELS "integration;comdlg32" TIMEOUT 120
    )
  else()
    message(STATUS "TC-0004 is not registered: no wfc executable found")
  endif()
endif()

# --- WebAssembly demo ---------------------------------------------------------
# With Emscripten the member table also builds as a module and a page that lists
# the classes (web/index.html); CI opens the page in Chromium for the README
# screenshot.
if(EMSCRIPTEN)
  file(
    STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/TARGET"
    WFC_WEB_TARGET
    LIMIT_COUNT 1
  )
  add_executable(comdlg32_web web/wasm_api.cpp)
  target_link_libraries(comdlg32_web PRIVATE wfc_comdlg32)
  target_compile_features(comdlg32_web PRIVATE cxx_std_20)
  target_compile_definitions(
    comdlg32_web
    PRIVATE
      WFC_WEB_VERSION="${WFC_COMDLG32_VERSION}"
      WFC_WEB_TARGET="${WFC_WEB_TARGET}"
  )
  set_target_properties(comdlg32_web PROPERTIES OUTPUT_NAME comdlg32 SUFFIX .js)
  set(
    WFC_WEB_NAMES
    library_name
    library_version
    library_target
    class_count
    class_name
    member_count
    event_count
    member_name
    event_name
  )
  string(JOIN "','_" WFC_WEB_EXPORTS ${WFC_WEB_NAMES})
  target_link_options(
    comdlg32_web
    PRIVATE
      -sMODULARIZE=1
      -sEXPORT_NAME=create_comdlg32
      "-sEXPORTED_FUNCTIONS=['_${WFC_WEB_EXPORTS}']"
      "-sEXPORTED_RUNTIME_METHODS=['ccall','UTF8ToString']"
      -sENVIRONMENT=web,node
  )
  add_custom_command(
    TARGET comdlg32_web
    POST_BUILD
    COMMAND
      "${CMAKE_COMMAND}" -E copy "${CMAKE_CURRENT_SOURCE_DIR}/web/index.html"
      "$<TARGET_FILE_DIR:comdlg32_web>/index.html"
  )
endif()
