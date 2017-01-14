set(ARCH x86_64)
set(HOST x86_64-linux-android)
set(TOOLCHAIN ${TOOLCHAIN_ROOT}/toolchain-${ARCH})
set(PROCESSOR x86_64) # for CMAKE_SYSTEM_PROCESSOR

set(NDK_CFLAGS "-ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes")
set(NDK_LDFLAGS "-no-canonical-prefixes")

set(BUILD_CFLAGS "-g")
 if(CMAKE_BUILD_TYPE STREQUAL "Release")
	set(BUILD_CFLAGS "${BUILD_CFLAGS} -O2 -DNDEBUG")
elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(BUILD_CFLAGS "${BUILD_CFLAGS} -O0 -UNDEBUG")
 endif()

set(CROSS_CFLAGS "${NDK_CFLAGS} ${BUILD_CFLAGS}")
set(CROSS_LDFLAGS "${NDK_LDFLAGS}")
