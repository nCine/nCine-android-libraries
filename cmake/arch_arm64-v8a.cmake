set(ARCH arm64-v8a)
set(HOST aarch64-linux-android)
set(TARGET aarch64-linux-android${PLATFORM})
set(PROCESSOR aarch64) # for CMAKE_SYSTEM_PROCESSOR

set(NDK_CFLAGS "-DANDROID -fPIC -fdata-sections -ffunction-sections -funwind-tables -fstack-protector-strong -no-canonical-prefixes -Wno-invalid-command-line-argument -Wno-unused-command-line-argument -D_FORTIFY_SOURCE=2")
set(NDK_LDFLAGS "-Wl,--build-id=sha1 -Wl,--fatal-warnings -Wl,--gc-sections -no-canonical-prefixes")

set(BUILD_CFLAGS "-g")
 if(CMAKE_BUILD_TYPE STREQUAL "Release")
	set(BUILD_CFLAGS "${BUILD_CFLAGS} -O2 -DNDEBUG")
elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(BUILD_CFLAGS "${BUILD_CFLAGS} -O0 -UNDEBUG -fno-limit-debug-info")
 endif()

set(CROSS_CFLAGS "${NDK_CFLAGS} ${BUILD_CFLAGS}")
set(CROSS_LDFLAGS "${NDK_LDFLAGS}")
