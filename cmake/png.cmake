set(TARGET_PNG png)
set(URL_PNG http://downloads.sourceforge.net/project/libpng/libpng16/1.6.47/libpng-1.6.47.tar.gz)
set(URL_MD5_PNG 6b46d508eb5da4d9c98722c69d7e8b67)
set(DEST_PNG ${DESTINATION_PATH}/png)

ExternalProject_Add(project_${TARGET_PNG}
	URL ${URL_PNG}
	URL_MD5 ${URL_PNG_MD5}
	PATCH_COMMAND patch -p1 < ${CMAKE_SOURCE_DIR}/patches/png.patch
	CMAKE_ARGS -DPNG_TESTS=OFF ${CMAKE_TOOLCHAIN_ARGS}
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different libpng16.so ${DEST_PNG}/${ARCH}/libpng16.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different libpng16.a ${DEST_PNG}/${ARCH}/libpng16.a
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_PNG}/png.h ${DEST_PNG}/include/png.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_PNG}/pngconf.h ${DEST_PNG}/include/pngconf.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different pnglibconf.h ${DEST_PNG}/include/pnglibconf.h
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_PNG} POST_BUILD
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_PNG}/${ARCH}/libpng16.so
		COMMAND ${STRIP} ${STRIP_STATIC_ARGS} ${DEST_PNG}/${ARCH}/libpng16.a
		COMMENT "Stripping PNG libraries")
endif()
