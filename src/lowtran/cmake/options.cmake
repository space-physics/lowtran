include(GNUInstallDirs)

# Rpath options necessary for shared library install to work correctly in user projects
set(CMAKE_INSTALL_NAME_DIR ${CMAKE_INSTALL_FULL_LIBDIR})
set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_FULL_LIBDIR})
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH true)

# Necessary for shared library with Visual Studio / Windows oneAPI
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS true)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  # will not take effect without FORCE
  # CMAKE_BINARY_DIR for use from FetchContent
  set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR} CACHE PATH "Install top-level directory" FORCE)
endif()

file(GENERATE OUTPUT .gitignore CONTENT "*")
