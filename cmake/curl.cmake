set(TARGET_CURL curl)
set(URL_CURL https://curl.se/download/curl-8.18.0.tar.gz)
set(URL_MD5_CURL 240a23f26602f24564468d9abecb32fd)
set(DEST_CURL ${DESTINATION_PATH}/curl)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
	set(LIBNAME_CURL libcurl-d.so.4.8.0)
	set(LIBNAME_CURL_STATIC libcurl-d.a)
else()
	set(LIBNAME_CURL libcurl.so.4.8.0)
	set(LIBNAME_CURL_STATIC libcurl.a)
endif()

ExternalProject_Add(project_${TARGET_CURL}
	URL ${URL_CURL}
	URL_MD5 ${URL_MD5_CURL}
	CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DHTTP_ONLY=ON -DCURL_USE_LIBPSL=OFF -DBUILD_STATIC_LIBS=ON -DBUILD_CURL_EXE=OFF -DBUILD_LIBCURL_DOCS=OFF
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/${LIBNAME_CURL} ${DEST_CURL}/${ARCH}/${LIBNAME_CURL}
		COMMAND ${CMAKE_COMMAND} -E copy_if_different lib/${LIBNAME_CURL_STATIC} ${DEST_CURL}/${ARCH}/${LIBNAME_CURL_STATIC}
		COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_CURL}/include/curl ${DEST_CURL}/include/curl
		COMMAND ${CMAKE_COMMAND} -E remove ${DEST_CURL}/include/curl/Makefile.am
		COMMAND ${CMAKE_COMMAND} -E remove ${DEST_CURL}/include/curl/Makefile.in
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_CURL} POST_BUILD
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_CURL}/${ARCH}/${LIBNAME_CURL}
		COMMAND ${STRIP} ${STRIP_STATIC_ARGS} ${DEST_CURL}/${ARCH}/${LIBNAME_CURL_STATIC}
		COMMENT "Stripping curl libraries")
endif()
