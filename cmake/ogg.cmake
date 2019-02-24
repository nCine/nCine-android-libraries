set(TARGET_OGG ogg)
set(URL_OGG http://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.gz)
set(URL_MD5_OGG 1eda7efc22a97d08af98265107d65f95)
set(DEST_OGG ${DESTINATION_PATH}/ogg)

ExternalProject_Add(project_${TARGET_OGG}
	URL ${URL_OGG}
	URL_MD5 ${URL_MD5_OGG}
	CONFIGURE_COMMAND ./configure ${CONFIGURE_TOOLCHAIN_ARGS}
	BUILD_COMMAND ${PARALLEL_MAKE}
	BUILD_IN_SOURCE 1
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_OGG}/src/.libs/libogg.so ${DEST_OGG}/${ARCH}/libogg.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_OGG}/src/.libs/libogg.a ${DEST_OGG}/${ARCH}/libogg.a
		COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/ogg.h ${DEST_OGG}/include/ogg/ogg.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/os_types.h ${DEST_OGG}/include/ogg/os_types.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different include/ogg/config_types.h ${DEST_OGG}/include/ogg/config_types.h
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_OGG} POST_BUILD
		COMMAND ${STRIP} -S ${DEST_OGG}/${ARCH}/libogg.so
		COMMAND ${STRIP} -S ${DEST_OGG}/${ARCH}/libogg.a
		COMMENT "Stripping OGG libraries")
endif()
