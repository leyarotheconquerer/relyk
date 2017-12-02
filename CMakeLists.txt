cmake_minimum_required(VERSION 3.2.3)
if (COMMAND cmake_policy)
	# Libraries linked via full path no longer produce linker search paths
	cmake_policy(SET CMP0003 NEW)
	# INTERFACE_LINK_LIBRARIES defines the link interface
	cmake_policy(SET CMP0022 NEW)
	# Disallow use of the LOCATION target property - so we set to OLD as we still need it
	cmake_policy(SET CMP0026 OLD)
	# MACOSX_RPATH is enabled by default
	cmake_policy(SET CMP0042 NEW)
	# Honor the visibility properties for SHARED target types only
	cmake_policy(SET CMP0063 OLD)
endif()

# Set project name
project (Relyk)

# Set CMake modules search path
set (CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/CMake/Modules)

# Include UrhoCommon.cmake module after setting project name
include (UrhoCommon)

# Define target name
set (TARGET_NAME Relyk)

# Define source files
define_source_files (
	RECURSE true
	GLOB_CPP_PATTERNS src/*.cpp
)

# Define the include directories
set (INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/include)

# Setup target with resource copying
setup_main_executable()