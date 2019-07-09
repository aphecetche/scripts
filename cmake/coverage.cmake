set(CTEST_SOURCE_DIRECTORY "/home/aphecetche/alice/cmake/O2")
set(CTEST_BINARY_DIRECTORY "/home/aphecetche/tmp/alice/cmake/O2")

set(ENV{CXXFLAGS} --coverage)
set(CTEST_COVERAGE_COMMAND gcov)

set(CTEST_CMAKE_GENERATOR Ninja)
set(CTEST_USE_LAUNCHERS YES)

set(CTEST_CONFIGURATION_TYPE RelWithDebInfo)

ctest_empty_binary_directory(${CTEST_BINARY_DIRECTORY})
ctest_start("Continuous")
ctest_configure(OPTIONS "-DBOOST_ROOT=/home/aphecetche/alice/cmake/sw/slc7_x86-64/EXPERIMENTAL/boost;-DCMAKE_PREFIX_PATH=/home/aphecetche/alice/cmake/sw/slc7_x86-64/EXPERIMENTAL")
ctest_build()
ctest_test()
ctest_coverage()
