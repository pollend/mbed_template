include(ExternalProject)
include(cmake/JSONParser.cmake)

message(STATUS "Compiling for mbed")


ExternalProject_Add(mbed_os
        GIT_REPOSITORY https://github.com/ARMmbed/mbed-os.git
        PREFIX ${CMAKE_CURRENT_BINARY_DIR}/mbed-os
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND "")

ExternalProject_Get_property(mbed_os SOURCE_DIR)

message(STATUS "${SOURCE_DIR}/targets/targets.json")

file(READ "${SOURCE_DIR}/targets/targets.json" TARGET_JSON)
sbeParseJson(targets TARGET_JSON)



foreach(var ${targets})
    message("${var} = ${${var}}")
endforeach()


message(STATUS ${targets.GD32_E103VB.inherits_0})

macro(_look_up_target target variable result)
    if(DEFINED ${targets.${target}.${variable}})
    else()
        _look_up_target(target ${json.${target}.inherits_0} result)
    endif()

endmacro()

#
#
#if(${TOOLCHAIN} STREQUAL "")
#    message(FATAL_ERROR "A toolchain (eg: TOOLCHAIN_GCC_ARM) must be specified")
#endif()
#
#if("${MBED_TARGET}" STREQUAL "")
#    message(FATAL_ERROR "MBED_TARGET must be specified")
#endif()
#
#if("${MBED_PATH}" STREQUAL "")
#    message(FATAL_ERROR "MBED_PATH must be specified")
#endif()
#
#
#if (${CMAKE_C_COMPILER_ID} STREQUAL "GNU")
#    set(MBED_COMPILER_FAMILY "GCC")
#elseif (${CMAKE_C_COMPILER_ID} STREQUAL "ARMCC")
#    set(MBED_COMPILER_FAMILY "ARM")
#else()
#    # TODO: Maybe we should crash here.
#    set(MBED_COMPILER_FAMILY "ARM")
#endif()
#
#
#set(MBED_COMMON_FLAGS
#        -Wall
#        -Wextra
#        -mthumb
#        -Wno-unused-parameter
#        -Wno-missing-field-initializers
#        -MMD
#        -fmessage-length=0               # error messages on single line
#        -fno-exceptions                  #
#        -fno-common                      # place tentative definitions in the data section
#        -fno-builtin                     #
#        -ffunction-sections              # allows more aggressive optimizations
#        -fdata-sections                  # allows more aggressive optimizations
#        -funsigned-char                  # force all chars to be compiled unsigned
#        -fno-delete-null-pointer-checks  # force compiler to assume we can't access memory address 0. enables some optimizations
#        -fomit-frame-pointer             # aggressively look to omit frame pointers
#        -mtune=${MBED_CORE}
#        -mcpu=${MBED_CORE}
#        -DTARGET_${MBED_TARGET}
#        -DTARGET_${MBED_INSTRUCTIONSET}
#        -DTARGET_${MBED_VENDOR}
#        -DTOOLCHAIN_GCC_ARM              # TODO: Support other toolchains
#        -DTOOLCHAIN_GCC
#        ${MBED_DEFINES}
#        )
#
#set(MBED_COMMON_FLAGS_RELEASE ${MBED_COMMON_FLAGS}
#        "-Os"
#        "-DNDEBUG"
#        )
#
#set(MBED_COMMON_FLAGS_DEBUG ${MBED_COMMON_FLAGS}
#        "-O0"
#        "-g3"
#        "-DMBED_DEBUG"
#        "-DMBED_TRAP_ERRORS_ENABLED=1"
#        )
#
#set(MBED_COMMON_LINKER_FLAGS
#        "-Wl,--no-wchar-size-warning"
#        "-Wl,--gc-sections"               # eliminate unused sections and symbols from output
#        "-Wl,--wrap,main"
#        "-Wl,--wrap,malloc_r"
#        "-Wl,--wrap,free_r"
#        "-Wl,--wrap,realloc_r"
#        "-Wl,--wrap,memalign_r"
#        "-Wl,--wrap,calloc_r"
#        "-Wl,--wrap,exit"
#        "-Wl,--wrap,atexit"
#        "-Wl,-n"
#        "-T${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/TARGET_${MBED_CPU}/device/${TOOLCHAIN}/${MBED_LINK_TARGET}.ld"
#        "-static"
#        "--specs=${MBED_STD_LIB}"
#        )
#
#set(MBED_SOURCE_DIRS
#        "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/TARGET_${MBED_CPU}/TARGET_${MBED_TARGET}"
#        "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/TARGET_${MBED_CPU}/device/${TOOLCHAIN}"
#        "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/TARGET_${MBED_CPU}/device/"
#        "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/TARGET_${MBED_CPU}"
#        "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}/device"
#        "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}/TARGET_${MBED_FAMILY}"
#        "${MBED_PATH}/targets/TARGET_${MBED_VENDOR}"
#        "${MBED_PATH}"
#        "${MBED_PATH}/platform"
#        "${MBED_PATH}/hal"
#        "${MBED_PATH}/cmsis"
#        "${MBED_PATH}/cmsis/TARGET_${MBED_CPU_FAMILY}"
#        "${MBED_PATH}/cmsis/TARGET_${MBED_CPU_FAMILY}/TOOLCHAIN_${MBED_COMPILER_FAMILY}"
#        "${MBED_PATH}/drivers"
#)