set(TARGET_PNG png)
set(URL_PNG http://downloads.sourceforge.net/project/libpng/libpng16/1.6.32/libpng-1.6.32.tar.gz)
set(URL_MD5_PNG c379427048bb0882ab1e286ca386260e)
set(DEST_PNG ${DESTINATION_PATH}/png)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(LIBNAME_PNG libpng16d)
else()
	set(LIBNAME_PNG libpng16)
endif()

ExternalProject_Add(project_${TARGET_PNG}
	URL ${URL_PNG}
	URL_MD5 ${URL_PNG_MD5}
	PATCH_COMMAND patch -p1 < ${CMAKE_SOURCE_DIR}/patches/png.patch
	CMAKE_ARGS -DPNG_TESTS=OFF ${CMAKE_TOOLCHAIN_ARGS}
	BUILD_COMMAND ${PARALLEL_MAKE}
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBNAME_PNG}.so ${DEST_PNG}/${ARCH}/${LIBNAME_PNG}.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBNAME_PNG}.a ${DEST_PNG}/${ARCH}/${LIBNAME_PNG}.a
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_PNG}/png.h ${DEST_PNG}/include/png.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_PNG}/pngconf.h ${DEST_PNG}/include/pngconf.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different pnglibconf.h ${DEST_PNG}/include/pnglibconf.h
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_PNG} POST_BUILD
		COMMAND ${TOOLCHAIN}/bin/${HOST}-strip -S ${DEST_PNG}/${ARCH}/${LIBNAME_PNG}.so
		COMMAND ${TOOLCHAIN}/bin/${HOST}-strip -S ${DEST_PNG}/${ARCH}/${LIBNAME_PNG}.a
		COMMENT "Stripping PNG library")
endif()
