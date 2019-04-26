if(NOT DEFINED TARGET_OGG)
	message(FATAL_ERROR "TARGET_OGG is not defined")
endif()

set(TARGET_VORBIS vorbis)
set(URL_VORBIS http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.gz)
set(URL_MD5_VORBIS d3190649b26572d44cd1e4f553943b31)

set(DEST_VORBIS ${DESTINATION_PATH}/vorbis)

ExternalProject_Add(project_${TARGET_VORBIS}
	DEPENDS project_${TARGET_OGG}
	URL ${URL_VORBIS}
	URL_MD5 ${URL_MD5_VORBIS}
	CONFIGURE_COMMAND ./configure ${CONFIGURE_TOOLCHAIN_ARGS} OGG_LIBS=-L${DESTINATION_PATH}/ogg/${ARCH} OGG_CFLAGS=-I${EP_BASE}/Source/project_${TARGET_OGG}/include
	BUILD_COMMAND ${PARALLEL_MAKE}
	BUILD_IN_SOURCE 1
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_VORBIS}/lib/.libs/libvorbis.so ${DEST_VORBIS}/${ARCH}/libvorbis.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_VORBIS}/lib/.libs/libvorbis.a ${DEST_VORBIS}/${ARCH}/libvorbis.a
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_VORBIS}/lib/.libs/libvorbisfile.so ${DEST_VORBIS}/${ARCH}/libvorbisfile.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_VORBIS}/lib/.libs/libvorbisfile.a ${DEST_VORBIS}/${ARCH}/libvorbisfile.a
		COMMAND ${CMAKE_COMMAND} -E copy_if_different include/vorbis/codec.h ${DEST_VORBIS}/include/vorbis/codec.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different include/vorbis/vorbisenc.h ${DEST_VORBIS}/include/vorbis/vorbisenc.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different include/vorbis/vorbisfile.h ${DEST_VORBIS}/include/vorbis/vorbisfile.h
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_VORBIS} POST_BUILD
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_VORBIS}/${ARCH}/libvorbis.so
		COMMAND ${STRIP} ${STRIP_STATIC_ARGS} ${DEST_VORBIS}/${ARCH}/libvorbis.a
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_VORBIS}/${ARCH}/libvorbisfile.so
		COMMAND ${STRIP} ${STRIP_STATIC_ARGS} ${DEST_VORBIS}/${ARCH}/libvorbisfile.a
		COMMENT "Stripping Vorbis libraries")
endif()
