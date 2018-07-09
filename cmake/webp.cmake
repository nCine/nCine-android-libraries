set(TARGET_WEBP webp)
set(URL_WEBP http://downloads.webmproject.org/releases/webp/libwebp-1.0.0.tar.gz)
set(URL_MD5_WEBP 967b8f087cb392e6cc94d5e116a120c0)
set(DEST_WEBP ${DESTINATION_PATH}/webp)

set(CPUFEATURES ${NDK_DIR}/sources/android/cpufeatures)
set(WEBP_CFLAGS "${CROSS_CFLAGS} -I${CPUFEATURES} -DANDROID -DHAVE_MALLOC_H -DHAVE_PTHREAD -DWEBP_USE_THREAD")
set(WEBP_LDFLAGS "${CROSS_LDLAGS} -L${TOOLCHAIN}/sysroot/usr/lib -lm -L${EP_BASE}/Source/project_${TARGET_WEBP} -lcpufeatures")

ExternalProject_Add(project_${TARGET_WEBP}
	URL ${URL_WEBP}
	URL_MD5 ${URL_MD5_WEBP}
	CONFIGURE_COMMAND ${TOOLCHAIN}/bin/clang -c -I${CPUFEATURES} ${CPUFEATURES}/cpu-features.c -o ${EP_BASE}/Source/project_${TARGET_WEBP}/cpu-features.o
		COMMAND ${TOOLCHAIN}/bin/llvm-ar rcs ${EP_BASE}/Source/project_${TARGET_WEBP}/libcpufeatures.a ${EP_BASE}/Source/project_${TARGET_WEBP}/cpu-features.o
		COMMAND ./configure ${CONFIGURE_TOOLCHAIN_ARGS_NOFLAGS} CFLAGS=${WEBP_CFLAGS} LDFLAGS=${WEBP_LDFLAGS} --enable-shared=yes --enable-static=yes
	BUILD_COMMAND ${PARALLEL_MAKE}
		COMMAND ${TOOLCHAIN}/bin/llvm-ar r ${EP_BASE}/Source/project_${TARGET_WEBP}/src/.libs/libwebp.a ${EP_BASE}/Source/project_${TARGET_WEBP}/cpu-features.o
	BUILD_IN_SOURCE 1
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_WEBP}/src/.libs/libwebp.so ${DEST_WEBP}/${ARCH}/libwebp.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_WEBP}/src/.libs/libwebp.a ${DEST_WEBP}/${ARCH}/libwebp.a
		COMMAND ${CMAKE_COMMAND} -E copy_directory src/webp ${DEST_WEBP}/include/webp
		COMMAND ${CMAKE_COMMAND} -E remove ${DEST_WEBP}/include/webp/config.h.in
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_WEBP} POST_BUILD
		COMMAND ${TOOLCHAIN}/bin/${HOST}-strip -S ${DEST_WEBP}/${ARCH}/libwebp.so
		COMMAND ${TOOLCHAIN}/bin/${HOST}-strip -S ${DEST_WEBP}/${ARCH}/libwebp.a
		COMMENT "Stripping WebP libraries")
endif()

