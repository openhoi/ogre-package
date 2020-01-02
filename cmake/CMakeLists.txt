cmake_minimum_required(VERSION 3.3.0)

set(CPACK_GENERATOR "DEB")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "openhoi Team")

include(CPack)

add_subdirectory(../ogre ogre)