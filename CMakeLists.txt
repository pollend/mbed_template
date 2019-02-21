cmake_minimum_required(VERSION 3.8.2)

project(mbed_template)

set(mbed_target "DISCO_F407VG")

include(cmake/toolchain/clang-arm-gcc-toolchain.cmake)
include(cmake/toolchain/utils.cmake)
include(cmake/mbed_arm.cmake)


set (SOURCES
        "blink.cpp")
add_executable(blink ${SOURCES})
target_link_libraries(blink mbed-os stdc++ supc++ m gcc g c nosys rdimon)
generate_object(blink ".bin" "binary")