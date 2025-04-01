set(TARGET_OGG ogg)
set(TARGET_OGG_STATIC ogg_static)
set(URL_OGG http://downloads.xiph.org/releases/ogg/libogg-1.3.5.tar.gz)
set(URL_MD5_OGG 3267127fe8d7ba77d3e00cb9d7ad578d)
set(DEST_OGG ${DESTINATION_PATH}/ogg)
set(INCLUDE_DIR_OGG ${EP_BASE}/Source/project_${TARGET_OGG}/include)

ExternalProject_Add(project_${TARGET_OGG}
	URL ${URL_OGG}
	URL_MD5 ${URL_MD5_OGG}
	PATCH_COMMAND patch -p1 < ${CMAKE_SOURCE_DIR}/patches/ogg.patch
	CMAKE_ARGS ${CMAKE_TOOLCHAIN_ARGS} -DBUILD_SHARED_LIBS=ON -DCMAKE_POLICY_VERSION_MINIMUM=3.5
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different libogg.so ${DEST_OGG}/${ARCH}/libogg.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_OGG}/ogg/ogg.h ${DEST_OGG}/include/ogg/ogg.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_OGG}/ogg/os_types.h ${DEST_OGG}/include/ogg/os_types.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/config_types.h ${DEST_OGG}/include/ogg/config_types.h
)

ExternalProject_Add(project_${TARGET_OGG_STATIC}
	DEPENDS project_${TARGET_OGG}
	DOWNLOAD_COMMAND ""
	SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_OGG}
	CMAKE_ARGS ${CMAKE_TOOLCHAIN_ARGS} -DBUILD_SHARED_LIBS=OFF -DCMAKE_POLICY_VERSION_MINIMUM=3.5
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different libogg.a ${DEST_OGG}/${ARCH}/libogg.a
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_OGG} POST_BUILD
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_OGG}/${ARCH}/libogg.so
		COMMENT "Stripping OGG shared library")

	add_custom_command(TARGET project_${TARGET_OGG_STATIC} POST_BUILD
		COMMAND ${STRIP} ${STRIP_STATIC_ARGS} ${DEST_OGG}/${ARCH}/libogg.a
		COMMENT "Stripping OGG static library")
endif()
