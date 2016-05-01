set(ARCH x86_64)
set(HOST x86_64-linux-android)
set(TOOLCHAIN ${TOOLCHAIN_ROOT}/toolchain-${ARCH})

set(NDK_CFLAGS "-ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes")
set(NDK_LDFLAGS "-no-canonical-prefixes")

 if(CMAKE_BUILD_TYPE STREQUAL "Release")
	set(BUILD_CFLAGS "-O2 -g -DNDEBUG -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300")
elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(BUILD_CFLAGS "-O0 -UNDEBUG -fno-omit-frame-pointer -fno-strict-aliasing")
 endif()

set(CROSS_CFLAGS "${NDK_CFLAGS} ${BUILD_CFLAGS}")
set(CROSS_LDFLAGS "${NDK_LDFLAGS}")
