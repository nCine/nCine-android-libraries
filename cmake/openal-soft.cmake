set(TARGET_OPENAL openal)
set(URL_OPENAL http://kcat.strangesoft.net/openal-releases/openal-soft-1.17.1.tar.bz2)
set(URL_MD5_OPENAL 4e1cff46cdb3ac147745dea33ad92687)
set(DEST_OPENAL ${DESTINATION_PATH}/openal)

ExternalProject_Add(project_${TARGET_OPENAL}
	URL ${URL_OPENAL}
	URL_MD5 ${URL_MD5_OPENAL}
	PATCH_COMMAND patch -p1 < ${CMAKE_SOURCE_DIR}/patches/openal-soft.patch
	CMAKE_ARGS -DALSOFT_UTILS=OFF -DALSOFT_EXAMPLES=OFF -DALSOFT_TESTS=OFF -DALSOFT_CONFIG=OFF ${CMAKE_TOOLCHAIN_ARGS}
	CMAKE_CACHE_ARGS -DLIB_MAJOR_VERSION:STRING=""
	BUILD_COMMAND ${PARALLEL_MAKE}
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND COMMAND ${CMAKE_COMMAND} -E copy_if_different libopenal.so ${DEST_OPENAL}/${ARCH}/libopenal.so
		COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_OPENAL}/include ${DEST_OPENAL}/include
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_OPENAL} POST_BUILD
		COMMAND ${TOOLCHAIN}/bin/${HOST}-strip -S ${DEST_OPENAL}/${ARCH}/libopenal.so
		COMMENT "Stripping OpenAL library")
endif()
