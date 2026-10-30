# wfc-comdlg32: Common Dialog (comdlg32.ocx, library MSComDlg).
#
# The member table is written by hand from the documented members.
# The table is built static by default; WFC_COMDLG32_SHARED builds it as
# wfccomdlg32.dll so a program can load it at run time instead. The version is the
# one in VERSION and is stamped into the DLL's version resource.
#
# Parent project variables used when present: WFC_OCX_SHARED (the default of
# WFC_COMDLG32_SHARED) and the functions wfc_enable_strict_warnings and
# wsp_enable_hardening.

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
  "Build the WFC comdlg32 library as wfccomdlg32.dll"
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
  target_link_libraries(wfc_comdlg32 PRIVATE advapi32)
  target_compile_definitions(
    wfc_comdlg32
    PUBLIC WFC_COMDLG32_SHARED
    PRIVATE WFC_COMDLG32_BUILD_DLL
  )
  set_target_properties(
    wfc_comdlg32
    PROPERTIES
      OUTPUT_NAME wfccomdlg32
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
# loads wfccomdlg32.dll, checks its COM entry points and version resource, and
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
  add_test(NAME TC-MP0010-comdlg32-tables COMMAND comdlg32_tables_test)
  set_tests_properties(
    TC-MP0010-comdlg32-tables
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
      NAME TC-MP0010-comdlg32-dll
      COMMAND
        comdlg32_dll_test "$<TARGET_FILE:wfc_comdlg32>" "${WFC_COMDLG32_VERSION}"
        "${WFC_LIB_TARGET}"
    )
    set_tests_properties(
      TC-MP0010-comdlg32-dll
      PROPERTIES
        LABELS "integration;mp-0010;comdlg32"
        RESOURCE_LOCK registry
        SKIP_RETURN_CODE 77
    )
  endif()
endif()
