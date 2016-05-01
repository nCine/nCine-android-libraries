# nCine-android-libraries
CMake scripts to build nCine dependency libraries for Android

## Information
This repository contains the scripts to easily cross-compile the libraries needed by the nCine when building the Android version.

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

## Build
Create an Android standalone toolchain for at least one of the supported architectures using the script from the NDK, then:

```
cmake -H. -B../nCine-android-libraries-build -DTOOLCHAIN_ROOT=[parent path to toolchain(s)] -DARCH=[supported arch]
```
