set(TARGET_LUA lua)
set(URL_LUA https://www.lua.org/ftp/lua-5.3.5.tar.gz)
set(URL_MD5_LUA 4f4b4f323fd3514a68e0ab3da8ce3455)
set(DEST_LUA ${DESTINATION_PATH}/lua)

ExternalProject_Add(project_${TARGET_LUA}
	URL ${URL_LUA}
	URL_MD5 ${URL_MD5_LUA}
	PATCH_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/patches/CMakeLists_lua.txt ${EP_BASE}/Source/project_${TARGET_LUA}/CMakeLists.txt
	CMAKE_ARGS ${CMAKE_TOOLCHAIN_ARGS}
	BUILD_COMMAND ${PARALLEL_MAKE}
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different liblua5.3.so ${DEST_LUA}/${ARCH}/liblua.so
		COMMAND ${CMAKE_COMMAND} -E copy_if_different liblua.a ${DEST_LUA}/${ARCH}/liblua.a
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_LUA}/src/lua.h ${DEST_LUA}/include/lua.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_LUA}/src/luaconf.h ${DEST_LUA}/include/luaconf.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_LUA}/src/lualib.h ${DEST_LUA}/include/lualib.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_LUA}/src/lauxlib.h ${DEST_LUA}/include/lauxlib.h
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${EP_BASE}/Source/project_${TARGET_LUA}/src/lua.hpp ${DEST_LUA}/include/lua.hpp
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_LUA} POST_BUILD
		COMMAND ${TOOLCHAIN}/bin/${HOST}-strip -S ${DEST_LUA}/${ARCH}/liblua.so
		COMMAND ${TOOLCHAIN}/bin/${HOST}-strip -S ${DEST_LUA}/${ARCH}/liblua.a
		COMMENT "Stripping Lua libraries")
endif()
