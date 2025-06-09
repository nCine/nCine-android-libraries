set(TARGET_LUA lua)
set(URL_LUA https://www.lua.org/ftp/lua-5.4.8.tar.gz)
set(URL_MD5_LUA 81cf5265b8634967d8a7480d238168ce)
set(DEST_LUA ${DESTINATION_PATH}/lua)

if(${ARCH} STREQUAL "armeabi-v7a")
	set(32BITS_LUA_PATCH_COMMAND patch -p1 < ${CMAKE_SOURCE_DIR}/patches/lua_liolib.patch)
endif()

ExternalProject_Add(project_${TARGET_LUA}
	URL ${URL_LUA}
	URL_MD5 ${URL_MD5_LUA}
	PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/patches/CMakeLists_lua.txt ${EP_BASE}/Source/project_${TARGET_LUA}/CMakeLists.txt
		COMMAND ${32BITS_LUA_PATCH_COMMAND}
	CMAKE_ARGS ${CMAKE_TOOLCHAIN_ARGS}
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different liblua5.4.so ${DEST_LUA}/${ARCH}/liblua.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different liblua.a ${DEST_LUA}/${ARCH}/liblua.a
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_LUA}/src/lua.h ${DEST_LUA}/include/lua.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_LUA}/src/luaconf.h ${DEST_LUA}/include/luaconf.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_LUA}/src/lualib.h ${DEST_LUA}/include/lualib.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_LUA}/src/lauxlib.h ${DEST_LUA}/include/lauxlib.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_LUA}/src/lua.hpp ${DEST_LUA}/include/lua.hpp
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_LUA} POST_BUILD
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_LUA}/${ARCH}/liblua.so
		COMMAND ${STRIP} ${STRIP_STATIC_ARGS} ${DEST_LUA}/${ARCH}/liblua.a
		COMMENT "Stripping Lua libraries")
endif()
