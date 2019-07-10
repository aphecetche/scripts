set(CTEST_SOURCE_DIRECTORY "$ENV{HOME}/alice/cmake/O2")
set(CTEST_BINARY_DIRECTORY "$ENV{HOME}/tmp/alice/cmake/O2")

set(ENV{CXXFLAGS} --coverage)
set(CTEST_COVERAGE_COMMAND gcov)

set(CTEST_CMAKE_GENERATOR Ninja)
set(CTEST_USE_LAUNCHERS YES)

set(CTEST_CONFIGURATION_TYPE RelWithDebInfo)
execute_process(COMMAND aliBuild architecture
                OUTPUT_VARIABLE archResult
                RESULT_VARIABLE result)
if(result)
  message(FATAL_ERROR "Could not get arch")
endif()
string(STRIP ${archResult} arch)

ctest_empty_binary_directory(${CTEST_BINARY_DIRECTORY})
ctest_start("Continuous")
ctest_configure(
  OPTIONS
  "-DBOOST_ROOT=$ENV{ALIBUILD_WORK_DIR}/${arch}/EXPERIMENTAL/boost;-DCMAKE_PREFIX_PATH=$ENV{ALIBUILD_WORK_DIR}/${arch}/EXPERIMENTAL"
  )
ctest_build()
ctest_test()
ctest_coverage()
