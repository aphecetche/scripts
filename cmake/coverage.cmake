#
# A script to build a project in coverage mode
#
# This script (named coverage.cmake) should be executed from a build tree (can
# be empty) :
#
# ctest -S coverage.cmake -DSOURCEDIR=... [ -DCMAKE_GENERATOR=... ]
#
# or just
#
# ctest -S coverage.cmake
#
# assuming the environment variable SOURCEDIR is defined.
#
# In any case a correct _build_ environment must be defined first, and then :
#
# * SOURCEDIR should point to the source directory of the project
#
# * CMAKE_GENERATOR (optional) should be either an env. or cmake variable (using
#   the -D syntax in that latter case) containing one of the valid generator
#   name known by the cmake program you are using. If not defined, Ninja is used
#
# In aliBuild world, the easiest way to get a correct build env. is to do
#
# WORK_DIR=/path/to/sw/ && source $WORK_DIR/[PACKAGE]/[platform]/latest/etc/profile.d/init.sh
#
# where [PACKAGE] is the package you are trying to get coverage for.
#
# Note : if both an env. variable XXX and a cmake variable (-DXXX) exist, the
# cmake variable is used.

# Ensure we have a sourcedir to work with
if(NOT SOURCEDIR)
        if(NOT DEFINED ENV{SOURCEDIR})
                message(FATAL_ERROR "Should define SOURCEDIR")
        else()
                set(SOURCEDIR $ENV{SOURCEDIR})
        endif()
endif()

get_filename_component(DIR ${SOURCEDIR} ABSOLUTE)
if(NOT EXISTS ${DIR})
        message(FATAL_ERROR "Source directory ${DIR} does not exist")
endif()

# Ensure we define the generator to be used
if(CMAKE_GENERATOR)
        set(CTEST_CMAKE_GENERATOR ${CMAKE_GENERATOR})
elseif(DEFINED ENV{CMAKE_GENERATOR})
        set(CTEST_CMAKE_GENERATOR $ENV{CMAKE_GENERATOR})
else()
        message(
                STATUS "CMAKE_GENERATOR not defined, using Unix CMakefiles by default")
        set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
endif()

# Set source and build directories
set(CTEST_SOURCE_DIRECTORY ${SOURCEDIR})
set(CTEST_BINARY_DIRECTORY .)
set(ENV{CTEST_USE_LAUNCHERS_DEFAULT} ON)

# After the coverage files have been generated, we will process them
# with lcov so it _must_ be available
#
find_program(LCOV_EXECUTABLE lcov)
if(NOT LCOV_EXECUTABLE)
        message(FATAL_ERROR "Could not find lcov program")
endif()

# We will generate html report if genhtml is available
find_program(GENHTML_EXECUTABLE genhtml)

# Setup for coverage build
unset(ENV{CXXFLAGS})
set(configureOptions "-DCMAKE_CXX_FLAGS=--coverage -g -O0")

set(CTEST_COVERAGE_COMMAND "gcov")

ctest_start("Coverage")
ctest_configure(OPTIONS "${configureOptions}")

ctest_build(CAPTURE_CMAKE_ERROR ERR)

if(ERR EQUAL -1)
        message(FATAL_ERROR "Build failed")
endif()

ctest_test()
ctest_coverage()

if(LCOV_EXECUTABLE)
        set(COVERAGE_INFO_FILE coverage.info)
        set(HTML_OUTPUT_DIRECTORY "${CTEST_BINARY_DIRECTORY}/coverage-html")

        # first lcov collection step to get the baseline (uses only gcdo files,
        # but all of them)

        message(STATUS "Collect baseline coverage information")

        execute_process(COMMAND ${LCOV_EXECUTABLE}
                "--directory"
                "${CTEST_BINARY_DIRECTORY}"
                "--capture"
                "--initial"
                "--quiet"
                "--output-file"
                "${COVERAGE_INFO_FILE}.zero")
 
        # second lcov collection step now using the gcda files, i.e. only
        # the files that were involved in testing

        message(STATUS "Collect coverage information after tests")

        execute_process(COMMAND ${LCOV_EXECUTABLE}
                "--directory"
                "${CTEST_BINARY_DIRECTORY}"
                "--capture"
                "--exclude"
                "${CTEST_BINARY_DIRECTORY}/*"
                "--quiet"
                "--output-file"
                "${COVERAGE_INFO_FILE}.test")

        # merge two steps

        message(STATUS "Merge baseline and after-tests coverate results")

        execute_process(COMMAND ${LCOV_EXECUTABLE}
                "--add-tracefile"
                "${COVERAGE_INFO_FILE}.test"
                "--add-tracefile"
                "${COVERAGE_INFO_FILE}.zero"
                "--quiet"
                "--output-file"
                "${COVERAGE_INFO_FILE}.total")

        # extract what we want

        message(STATUS "Extract wanted information from ${COVERAGE_INFO_FILE}")

        execute_process(COMMAND ${LCOV_EXECUTABLE}
                "--extract"
                "${COVERAGE_INFO_FILE}.total"
                "${CTEST_SOURCE_DIRECTORY}/*"
                "--quiet"
                "--output-file"
                "${COVERAGE_INFO_FILE}")

        # remove unit tests themselves from the report
        # filtering by name is probably not perfect here
        # but better than nothing
        # FIXME: get the list of tests using ctest itself ? 

        message(STATUS "Remove unwanted information from ${COVERAGE_INFO_FILE}")

        execute_process(COMMAND ${LCOV_EXECUTABLE}
                "--remove"
                "${COVERAGE_INFO_FILE}"
                "*/test*"
                "--quiet"
                "--output-file"
                "${COVERAGE_INFO_FILE}")

        # finally generate a html report
        if(GENHTML_EXECUTABLE)

                message(STATUS "Generating html report")

                execute_process(COMMAND ${GENHTML_EXECUTABLE}
                        "${COVERAGE_INFO_FILE}"
                        "--ignore-errors"
                        "source"
                        "--legend"
                        "--show-details"
                        "--quiet"
                        "--output-directory"
                        "${HTML_OUTPUT_DIRECTORY}")
        else()
                message(STATUS "genhtml command not found : not using it")
        endif()
else()
        message(STATUS "lcov command not found : not using it")
endif()
