set(TARGET_OPENAL openal)
set(URL_OPENAL https://github.com/kcat/openal-soft/archive/1.24.2.tar.gz)
set(URL_MD5_OPENAL 2befc873d26f4eed10c06f272c48c5ec)
set(DEST_OPENAL ${DESTINATION_PATH}/openal)

set(LIBTYPE_OPENAL "DYNAMIC")
if(LIBTYPE_OPENAL STREQUAL "STATIC")
	set(LIBNAME_OPENAL libopenal.a)
elseif(LIBTYPE_OPENAL STREQUAL "DYNAMIC")
	set(LIBNAME_OPENAL libopenal.so)
endif()

ExternalProject_Add(project_${TARGET_OPENAL}
	URL ${URL_OPENAL}
	URL_MD5 ${URL_MD5_OPENAL}
	PATCH_COMMAND patch -p1 < ${CMAKE_SOURCE_DIR}/patches/openal-soft.patch
	CMAKE_ARGS -DALSOFT_UTILS=OFF -DALSOFT_EXAMPLES=OFF -DALSOFT_TESTS=OFF -DALSOFT_INSTALL_CONFIG=OFF -DLIBTYPE=${LIBTYPE_OPENAL} ${CMAKE_TOOLCHAIN_ARGS}
	CMAKE_CACHE_ARGS -DLIB_MAJOR_VERSION:STRING=""
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND COMMAND ${CMAKE_COMMAND} -E copy_if_different ${LIBNAME_OPENAL} ${DEST_OPENAL}/${ARCH}/${LIBNAME_OPENAL}
		COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_OPENAL}/include ${DEST_OPENAL}/include
)

if(CMAKE_BUILD_TYPE STREQUAL "Release" AND LIBTYPE_OPENAL STREQUAL "DYNAMIC")
	add_custom_command(TARGET project_${TARGET_OPENAL} POST_BUILD
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_OPENAL}/${ARCH}/libopenal.so
		COMMENT "Stripping OpenAL library")
endif()
