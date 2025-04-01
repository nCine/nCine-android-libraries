if(NOT DEFINED TARGET_OGG)
	message(FATAL_ERROR "TARGET_OGG is not defined")
endif()

set(TARGET_VORBIS vorbis)
set(TARGET_VORBIS_STATIC vorbis_static)
set(URL_VORBIS http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.gz)
set(URL_MD5_VORBIS 9b8034da6edc1a17d18b9bc4542015c7)
set(DEST_VORBIS ${DESTINATION_PATH}/vorbis)
set(INCLUDE_DIR_VORBIS ${EP_BASE}/Source/project_${TARGET_VORBIS}/include)
set(COMMON_CMAKE_ARGS_VORBIS -DOGG_INCLUDE_DIR=${DEST_OGG}/include -DCMAKE_POLICY_VERSION_MINIMUM=3.5)

ExternalProject_Add(project_${TARGET_VORBIS}
	DEPENDS project_${TARGET_OGG}
	URL ${URL_VORBIS}
	URL_MD5 ${URL_MD5_VORBIS}
	PATCH_COMMAND patch -p1 < ${CMAKE_SOURCE_DIR}/patches/vorbis.patch
	CMAKE_ARGS ${CMAKE_TOOLCHAIN_ARGS} -DOGG_LIBRARY=${DESTINATION_PATH}/ogg/${ARCH}/libogg.so -DBUILD_SHARED_LIBS=ON ${COMMON_CMAKE_ARGS_VORBIS}
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/libvorbis.so ${DEST_VORBIS}/${ARCH}/libvorbis.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/libvorbisfile.so ${DEST_VORBIS}/${ARCH}/libvorbisfile.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_VORBIS}/vorbis/codec.h ${DEST_VORBIS}/include/vorbis/codec.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_VORBIS}/vorbis/vorbisenc.h ${DEST_VORBIS}/include/vorbis/vorbisenc.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${INCLUDE_DIR_VORBIS}/vorbis/vorbisfile.h ${DEST_VORBIS}/include/vorbis/vorbisfile.h
)

ExternalProject_Add(project_${TARGET_VORBIS_STATIC}
	DEPENDS project_${TARGET_VORBIS}
	DOWNLOAD_COMMAND ""
	SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_VORBIS}
	CMAKE_ARGS ${CMAKE_TOOLCHAIN_ARGS} -DOGG_LIBRARY=${DESTINATION_PATH}/ogg/${ARCH}/libogg.a -DBUILD_SHARED_LIBS=OFF ${COMMON_CMAKE_ARGS_VORBIS}
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/libvorbis.a ${DEST_VORBIS}/${ARCH}/libvorbis.a
		COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/libvorbisfile.a ${DEST_VORBIS}/${ARCH}/libvorbisfile.a
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_VORBIS} POST_BUILD
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_VORBIS}/${ARCH}/libvorbis.so
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_VORBIS}/${ARCH}/libvorbisfile.so
		COMMENT "Stripping Vorbis shared libraries")

	add_custom_command(TARGET project_${TARGET_VORBIS_STATIC} POST_BUILD
		COMMAND ${STRIP} ${STRIP_STATIC_ARGS} ${DEST_VORBIS}/${ARCH}/libvorbis.a
		COMMAND ${STRIP} ${STRIP_STATIC_ARGS} ${DEST_VORBIS}/${ARCH}/libvorbisfile.a
		COMMENT "Stripping Vorbis static libraries")
endif()
