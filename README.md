[![Android](https://github.com/nCine/nCine-android-libraries/workflows/Android/badge.svg)](https://github.com/nCine/nCine-android-libraries/actions?workflow=Android)

# nCine-android-libraries

CMake scripts to build nCine dependency libraries for Android.

## Information

This repository contains the scripts to easily cross-compile the libraries needed by the nCine when building the Android version.

It also contains some additional libraries that can optionally be used in nCine projects.

### Supported architectures

- armeabi-v7a
- arm64-v8a
- x86_64

### Libraries

- libogg
- libvorbis
- libpng
- libwebp
- OpenAL-soft
- Lua
- Box2D
- libcurl

## Build

Install the Android NDK somewhere, then:

```bash
cmake -S nCine-android-libraries -B nCine-android-libraries-build -DNDK_DIR=[path to the NDK] -DARCH=[architecture] -DPLATFORM=[platform level]
```
