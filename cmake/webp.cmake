set(TARGET_WEBP webp)
set(TARGET_WEBP_STATIC webp_static)
set(URL_WEBP http://downloads.webmproject.org/releases/webp/libwebp-1.6.0.tar.gz)
set(URL_MD5_WEBP cceb6447180f961473b181c9ef38b630)
set(DEST_WEBP ${DESTINATION_PATH}/webp)

set(WEBP_CMAKE_ARGS
	-DWEBP_BUILD_ANIM_UTILS=OFF -DWEBP_BUILD_CWEBP=OFF -DWEBP_BUILD_DWEBP=OFF
	-DWEBP_BUILD_GIF2WEBP=OFF -DWEBP_BUILD_IMG2WEBP=OFF -DWEBP_BUILD_VWEBP=OFF
	-DWEBP_BUILD_WEBPINFO=OFF -DWEBP_BUILD_WEBPMUX=OFF -DWEBP_BUILD_EXTRAS=OFF)

ExternalProject_Add(project_${TARGET_WEBP}
	URL ${URL_WEBP}
	URL_MD5 ${URL_MD5_WEBP}
	CMAKE_ARGS ${CMAKE_TOOLCHAIN_ARGS} ${WEBP_CMAKE_ARGS} -DBUILD_SHARED_LIBS=ON
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different libwebp.so ${DEST_WEBP}/${ARCH}/libwebp.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different libsharpyuv.so ${DEST_WEBP}/${ARCH}/libsharpyuv.so
		COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_WEBP}/src/webp ${DEST_WEBP}/include/webp
		COMMAND ${CMAKE_COMMAND} -E copy_if_different src/webp/config.h ${DEST_WEBP}/include/webp
		COMMAND ${CMAKE_COMMAND} -E remove ${DEST_WEBP}/include/webp/config.h.in
)

ExternalProject_Add(project_${TARGET_WEBP_STATIC}
	DEPENDS project_${TARGET_WEBP}
	DOWNLOAD_COMMAND ""
	SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_WEBP}
	CMAKE_ARGS ${CMAKE_TOOLCHAIN_ARGS} ${WEBP_CMAKE_ARGS} -DBUILD_SHARED_LIBS=OFF
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different libwebp.a ${DEST_WEBP}/${ARCH}/libwebp.a
		COMMAND ${CMAKE_COMMAND} -E copy_if_different libsharpyuv.a ${DEST_WEBP}/${ARCH}/libsharpyuv.a
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_WEBP} POST_BUILD
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_WEBP}/${ARCH}/libwebp.so
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_WEBP}/${ARCH}/libsharpyuv.so
		COMMENT "Stripping the dynamic WebP libraries")

	add_custom_command(TARGET project_${TARGET_WEBP_STATIC} POST_BUILD
		COMMAND ${STRIP} ${STRIP_STATIC_ARGS} ${DEST_WEBP}/${ARCH}/libwebp.a
		COMMAND ${STRIP} ${STRIP_STATIC_ARGS} ${DEST_WEBP}/${ARCH}/libsharpyuv.a
		COMMENT "Stripping the static WebP libraries")
endif()
