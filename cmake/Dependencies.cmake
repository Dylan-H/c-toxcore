###############################################################################
#
# :: For UNIX-like systems that have pkg-config.
#
###############################################################################

include(ModulePackage)

find_package(Threads REQUIRED)

find_library(NSL_LIBRARIES          nsl          )
find_library(RT_LIBRARIES           rt           )
find_library(SOCKET_LIBRARIES       socket       )

# For toxcore.
#pkg_use_module(LIBSODIUM            libsodium    )

# For toxav.
#pkg_use_module(OPUS                 "opus;Opus"  )
#pkg_use_module(VPX                  "vpx;libvpx" )

# For tox-bootstrapd.
pkg_use_module(LIBCONFIG            libconfig    )

###############################################################################
#
# :: For MSVC Windows builds.
#
# These require specific installation paths of dependencies:
# - libsodium in third-party/libsodium/Win32/Release/v140/dynamic
# - pthreads in third-party/pthreads-win32/Pre-built.2
#
###############################################################################

if(WIN32)
    set(libpath ${CMAKE_CURRENT_SOURCE_DIR}/../lib/x64)
elseif(ANDROID)
    set(libpath ${CMAKE_CURRENT_SOURCE_DIR}/../lib/${CMAKE_ANDROID_ARCH_ABI})
else()
  set(libpath ${CMAKE_CURRENT_SOURCE_DIR}/../lib/linux64)
endif()

  # libsodium
  # ---------
  if(NOT LIBSODIUM_FOUND)
    find_library(LIBSODIUM_LIBRARIES
      NAMES sodium libsodium
      PATHS ${libpath} NO_DEFAULT_PATH
    )
    if(LIBSODIUM_LIBRARIES)
      include_directories("${CMAKE_CURRENT_SOURCE_DIR}/../include")
      set(LIBSODIUM_FOUND TRUE)
      message("libsodium: ${LIBSODIUM_LIBRARIES}")
    else()
      message(FATAL_ERROR "libsodium libraries not found")
    endif()
  endif()

  #OPUS
  #------------
  if(NOT OPUS_FOUND)
    find_library(OPUS_LIBRARIES
      NAMES opus libopus
      PATHS ${libpath} NO_DEFAULT_PATH
    )
    if(OPUS_LIBRARIES)
      include_directories("${CMAKE_CURRENT_SOURCE_DIR}/../opus/include")
      set(OPUS_FOUND TRUE)
      message("opus: ${OPUS_LIBRARIES}")
    else()
      message(FATAL_ERROR "OPUS libraries not found")
    endif()
  endif()

  #VPX
  #------------
  if(NOT VPX_FOUND)
    find_library(VPX_LIBRARIES
      NAMES vpxmd libvpx vpx
      PATHS ${libpath} NO_DEFAULT_PATH
    )
    if(VPX_LIBRARIES)
      include_directories("${CMAKE_CURRENT_SOURCE_DIR}/../libvpx")
      set(VPX_FOUND TRUE)
      message("vpx: ${VPX_LIBRARIES}")
    else()
      message(FATAL_ERROR "VPX libraries not found")
    endif()
  endif()
if(MSVC)
  # pthreads
  # --------
  if(NOT PTHREAD_FOUND)
    find_library(PTHREAD_LIBRARIES
    NAMES pthreadVC3 libpthreadVC3
    PATHS
    "D:/Work/vcpkg/installed/x64-windows/lib"
    "D:/Work/vcpkg/installed/x64-windows/lib"
    )
    if(PTHREAD_LIBRARIES)
      include_directories("D:/Work/vcpkg/installed/x64-windows/include")
      set(PTHREAD_FOUND TRUE)
      link_libraries(${PTHREAD_LIBRARIES})
      message("pthread: ${PTHREAD_LIBRARIES}")
    else()
      message(FATAL_ERROR "pthread libraries not found")
    endif()
  endif()
endif()
