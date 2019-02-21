include(ExternalProject)
include(cmake/JSONParser.cmake)

message(STATUS "Compiling for mbed")

set(MBED_DIR ${CMAKE_SOURCE_DIR}/3rdparty/mbed-os )

message(STATUS "${MBED_DIR}/targets/targets.json")

if(NOT DEFINED mbed_target)
    message(FATAL_ERROR "A target mapping is required" )
endif()

file(READ "${MBED_DIR}/targets/targets.json" TARGET_JSON)
sbeParseJson(targets TARGET_JSON)


#foreach(var ${targets})
#    message("${var} = ${${var}}")
#endforeach()


macro(_look_up_target target_variable target variable)
    if(NOT "${${target_variable}.${target}.${variable}}" STREQUAL "")
        set(${variable} "${target_variable}.${target}.${variable}")
    else()
        if(NOT "${${target_variable}.${target}.inherits_0}" STREQUAL "")
            _look_up_target(${target_variable} ${${target_variable}.${target}.inherits_0} ${variable})
        else()
            set(${variable} "")
        endif()
    endif()
endmacro()


macro(_build_target path source_dirs include_dirs)
endmacro()


file(GLOB MBED_SOURCE_DIRS
        ${MBED_DIR}/platform/*.c
        ${MBED_DIR}/platform/*.cpp
        ${MBED_DIR}/hal/*.cpp
        ${MBED_DIR}/hal/*.c
        ${MBED_DIR}/cmsis/*.cpp
        ${MBED_DIR}/cmsis/*.c
        ${MBED_DIR}/drivers/*.cpp
        ${MBED_DIR}/drivers/*.c
        )
set(MBED_INCLUDE_DIRS
        ${MBED_DIR}
        ${MBED_DIR}/platform
        ${MBED_DIR}/hal
        ${MBED_DIR}/cmsis
        ${MBED_DIR}/drivers)
#Search for target paths
_look_up_target(targets ${mbed_target} extra_labels)
set(TARGET_PATH ${MBED_DIR}/targets/)
if(NOT "${extra_labels}" STREQUAL "")
    foreach(index ${${extra_labels}})
        set(TARGET_PATH "${TARGET_PATH}/TARGET_${${extra_labels}_${index}}")
        if(EXISTS ${TARGET_PATH})
            list(APPEND MBED_INCLUDE_DIRS "${TARGET_PATH}")
            file(GLOB SRC_DIR "${TARGET_PATH}/*.cpp" "${TARGET_PATH}/*c")
            list (APPEND MBED_SOURCE_DIRS ${SRC_DIR})
        endif()
    endforeach()
endif()

_look_up_target(targets ${mbed_target} extra_labels_add)
if(NOT "${extra_labels_add}" STREQUAL "")
    foreach(index ${${extra_labels_add}})
        if(EXISTS ${TARGET_PATH}/TARGET_${${extra_labels_add}_${index}})
            set(TARGET_PATH "${TARGET_PATH}/TARGET_${${extra_labels_add}_${index}}")
            message(STATUS ${TARGET_PATH})
            list(APPEND MBED_INCLUDE_DIRS "${TARGET_PATH}")
            file(GLOB SRC_DIR "${TARGET_PATH}/*.cpp" "${TARGET_PATH}/*c")
            list (APPEND MBED_SOURCE_DIRS ${SRC_DIR})
        endif()
    endforeach()
endif()


set(TARGET_PATH "${TARGET_PATH}/TARGET_${mbed_target}")
if(EXISTS ${TARGET_PATH})
    list(APPEND MBED_INCLUDE_DIRS "${TARGET_PATH}")
    file(GLOB SRC_DIR "${TARGET_PATH}/*.cpp" "${TARGET_PATH}/*c")
    list (APPEND MBED_SOURCE_DIRS ${SRC_DIR})
endif()
message(STATUS "${TARGET_PATH}")
message(STATUS "${MBED_SOURCE_DIRS}")
message(STATUS "${MBED_INCLUDE_DIRS}")

set(CMAKE_C_FLAGS "${MBED_COMMON_FLAGS_STR} -std=gnu99")

add_library(mbed-os STATIC ${MBED_SOURCE_DIRS})
target_include_directories(mbed-os PUBLIC ${MBED_INCLUDE_DIRS})