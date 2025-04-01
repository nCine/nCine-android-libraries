set(TARGET_BOX2D box2d)
set(TARGET_BOX2D_STATIC box2d_static)
set(URL_BOX2D https://github.com/erincatto/box2d/archive/v3.0.0.tar.gz)
set(URL_MD5_BOX2D ad0d1f85461cbbb98d6f7c71fe831a46)
set(DEST_BOX2D ${DESTINATION_PATH}/box2d)

set(BOX2D_CMAKE_ARGS -DBOX2D_SAMPLES=OFF -DBOX2D_UNIT_TESTS=OFF -DBOX2D_DOCS=OFF -DCMAKE_POLICY_VERSION_MINIMUM=3.5)

ExternalProject_Add(project_${TARGET_BOX2D}
	URL ${URL_BOX2D}
	URL_MD5 ${URL_MD5_BOX2D}
	CMAKE_ARGS ${CMAKE_TOOLCHAIN_ARGS} ${BOX2D_CMAKE_ARGS} -DBUILD_SHARED_LIBS=ON
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different src/libbox2d.so ${DEST_BOX2D}/${ARCH}/libbox2d.so
		COMMAND ${CMAKE_COMMAND} -E copy_directory ${EP_BASE}/Source/project_${TARGET_BOX2D}/include/box2d ${DEST_BOX2D}/include/box2d
)

ExternalProject_Add(project_${TARGET_BOX2D_STATIC}
	DEPENDS project_${TARGET_BOX2D}
	DOWNLOAD_COMMAND ""
	SOURCE_DIR ${EP_BASE}/Source/project_${TARGET_BOX2D}
	# Patch has already been applied when building the shared library
	CMAKE_ARGS ${CMAKE_TOOLCHAIN_ARGS} ${BOX2D_CMAKE_ARGS} -DBUILD_SHARED_LIBS=OFF
	BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
	BUILD_IN_SOURCE 0
	INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different src/libbox2d.a ${DEST_BOX2D}/${ARCH}/libbox2d.a
)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
	add_custom_command(TARGET project_${TARGET_BOX2D} POST_BUILD
		COMMAND ${STRIP} ${STRIP_SHARED_ARGS} ${DEST_BOX2D}/${ARCH}/libbox2d.so
		COMMENT "Stripping the dynamic Box2D library")

	add_custom_command(TARGET project_${TARGET_BOX2D_STATIC} POST_BUILD
		COMMAND ${STRIP} ${STRIP_STATIC_ARGS} ${DEST_BOX2D}/${ARCH}/libbox2d.a
		COMMENT "Stripping the static Box2D library")
endif()
