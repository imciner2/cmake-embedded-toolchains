# This file contains a CMake toolchain for compiling programs for Fedora
# on an ARM 64-bit system (aarch64).
#
# To use this toolchain, pass its absolute path to the CMake command using the
# -DCMAKE_TOOLCHAIN_FILE variable.
#
# The CMake toolchain is designed to use the compilers provided by the COPR repo
# lantw44/aarch64-linux-gnu-toolchain. To install this, run:
# dnf copr enable lantw44/aarch64-linux-gnu-toolchain
# dnf install aarch64-linux-gnu-{binutils,gcc,glibc,filesystem,kernel-headers}
#
# @Author: Ian McInerney
# @License: MIT
# @Copyright: 2019


set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

if(MINGW OR CYGWIN OR WIN32)
    set(SEARCH_CMD where)
elseif(UNIX OR APPLE)
    set(SEARCH_CMD which)
endif()

set(TOOLCHAIN_PREFIX aarch64-linux-gnu)

# Find the compiler
execute_process(
  COMMAND ${SEARCH_CMD} ${TOOLCHAIN_PREFIX}-gcc
  OUTPUT_VARIABLE GCC_PATH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Find the base path to the compiler tools and the cmake sys root
STRING(REGEX REPLACE "/${TOOLCHAIN_PREFIX}-gcc$" "" TOOL_BIN_PATH "${GCC_PATH}")

STRING(REGEX REPLACE "/bin$" "" NO_BIN_PATH "${TOOL_BIN_PATH}")
set(CMAKE_SYSROOT ${NO_BIN_PATH}/${TOOLCHAIN_PREFIX}/sys-root)

# Without that flag CMake is not able to pass test compilation check
if (${CMAKE_VERSION} VERSION_EQUAL "3.6.0" OR ${CMAKE_VERSION} VERSION_GREATER "3.6")
    set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
else()
    set(CMAKE_EXE_LINKER_FLAGS_INIT "--specs=nosys.specs")
endif()

set(CMAKE_C_COMPILER     ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_ASM_COMPILER   ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER   ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-g++)
set(CMAKE_OBJCOPY        ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-objcopy CACHE INTERNAL "Object copy tool")
set(CMAKE_OBJDUMP        ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-objdump CACHE INTERNAL "Object dump tool")
set(CMAKE_SIZE_UTIL      ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-size CACHE INTERNAL "Size tool")
set(CMAKE_AR_TOOL        ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-ar CACHE INTERNAL "Archiver tool")
set(CMAKE_AS_TOOL        ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-as CACHE INTERNAL "Assembler tool")
set(CMAKE_LD_TOOL        ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-ld CACHE INTERNAL "Linker tool")
set(CMAKE_NM_TOOL        ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-nm CACHE INTERNAL "Symbol list tool")
set(CMAKE_READ_ELF_TOOL  ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-readelf CACHE INTERNAL "ELF information tool")
set(CMAKE_ADDR2LINE_TOOL ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-addr2line CACHE INTERNAL "Address to line tool")
set(CMAKE_STRINGS_TOOL   ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-strings CACHE INTERNAL "Print strings tool")
set(CMAKE_STRIP_TOOL     ${TOOL_BIN_PATH}/${TOOLCHAIN_PREFIX}-strip CACHE INTERNAL "Strip symbols tool")


set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
