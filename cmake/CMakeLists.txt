cmake_minimum_required (VERSION 3.10 FATAL_ERROR)

if(WIN32)
    message( FATAL_ERROR "You cannot run this script under Windows. Exiting." )
endif()

set(SPECIFIC_SYSTEM_PREFERED_CPACK_GENERATOR "TGZ")
if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux")
	if(EXISTS "/etc/redhat-release")
		file(READ "/etc/redhat-release" LINUX_ISSUE)
	elseif(EXISTS "/etc/issue")
		file(READ "/etc/issue" LINUX_ISSUE)
	endif()
	if(LINUX_ISSUE MATCHES "Fedora")
		set(SPECIFIC_SYSTEM_PREFERED_CPACK_GENERATOR "RPM")
	elseif(LINUX_ISSUE MATCHES "Debian")
		set(SPECIFIC_SYSTEM_PREFERED_CPACK_GENERATOR "DEB")
    set(SPECIFIC_SYSTEM_REQUIRED_CPACK_DEB_DEPENDENCIES "libfreetype6, libfreeimage3, libsdl2-2.0-0, libxaw7, libxt6")
		elseif(LINUX_ISSUE MATCHES "Ubuntu")
		set(SPECIFIC_SYSTEM_PREFERED_CPACK_GENERATOR "DEB")
    set(SPECIFIC_SYSTEM_REQUIRED_CPACK_DEB_DEPENDENCIES "libfreetype6, libfreeimage3, libsdl2-2.0-0, libxaw7, libxt6")
	endif()
endif()

file(READ "../version" ver)
string(REGEX MATCH "VERSION_MAJOR=([0-9]*)" _ ${ver})
set(MAJOR_VERSION ${CMAKE_MATCH_1})
string(REGEX MATCH "VERSION_MINOR=([0-9]*)" _ ${ver})
set(MINOR_VERSION ${CMAKE_MATCH_1})
string(REGEX MATCH "VERSION_PATCH=([0-9]*)" _ ${ver})
set(PATCH_VERSION ${CMAKE_MATCH_1})

set(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
set(CPACK_PACKAGE_NAME "ogre")
set(CPACK_PACKAGE_VENDOR "openhoi Team")
set(CPACK_PACKAGE_CONTACT "reiser.thomas@gmail.com")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "openhoi Team")
set(CPACK_GENERATOR "${SPECIFIC_SYSTEM_PREFERED_CPACK_GENERATOR}")
set(CPACK_SOURCE_GENERATOR "${SPECIFIC_SYSTEM_PREFERED_CPACK_GENERATOR}")
set(CPACK_PACKAGE_DESCRIPTION "OGRE libraries for openhoi")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Contains all OGRE libraries required for openhoi")
set(CPACK_PACKAGE_VERSION_MAJOR "${MAJOR_VERSION}")
set(CPACK_PACKAGE_VERSION_MINOR "${MINOR_VERSION}")
set(CPACK_PACKAGE_VERSION_PATCH "${PATCH_VERSION}")
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}_${MAJOR_VERSION}.${MINOR_VERSION}.${CPACK_PACKAGE_VERSION_PATCH}")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}_${MAJOR_VERSION}.${MINOR_VERSION}.${CPACK_PACKAGE_VERSION_PATCH}")
set(CPACK_DEBIAN_PACKAGE_LICENSE "mit")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "${SPECIFIC_SYSTEM_REQUIRED_CPACK_DEB_DEPENDENCIES}")


if(UNIX AND CMAKE_GENERATOR STREQUAL "Ninja")
    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fcolor-diagnostics")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fcolor-diagnostics")
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fdiagnostics-color")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fdiagnostics-color")
    endif()
endif()

add_subdirectory(../ogre ogre)
