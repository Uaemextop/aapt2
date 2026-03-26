set(LIBUTILS_SRCS
    ${SRC}/core/libutils/binder/Errors.cpp
    ${SRC}/core/libutils/FileMap.cpp
    ${SRC}/core/libutils/JenkinsHash.cpp
    ${SRC}/core/libutils/LightRefBase.cpp
    ${SRC}/core/libutils/NativeHandle.cpp
    ${SRC}/core/libutils/Printer.cpp
    ${SRC}/core/libutils/binder/RefBase.cpp
    ${SRC}/core/libutils/binder/SharedBuffer.cpp
    ${SRC}/core/libutils/StopWatch.cpp
    ${SRC}/core/libutils/binder/String8.cpp
    ${SRC}/core/libutils/binder/String16.cpp
    ${SRC}/core/libutils/binder/StrongPointer.cpp
    ${SRC}/core/libutils/SystemClock.cpp
    ${SRC}/core/libutils/Threads.cpp
    ${SRC}/core/libutils/Timers.cpp
    ${SRC}/core/libutils/Tokenizer.cpp
    ${SRC}/core/libutils/binder/Unicode.cpp
    ${SRC}/core/libutils/binder/VectorImpl.cpp
    ${SRC}/core/libutils/misc.cpp
    ${SRC}/core/libutils/Trace.cpp
    )

# Looper.cpp uses Linux-specific sys/epoll.h and is not available on Windows.
if(NOT WIN32)
    list(APPEND LIBUTILS_SRCS ${SRC}/core/libutils/Looper.cpp)
endif()

add_library(libutils STATIC ${LIBUTILS_SRCS})

target_include_directories(libutils PRIVATE
    ${SRC}/core/include
    ${SRC}/core/libsystem/include
    ${SRC}/core/libvndksupport/include
    ${SRC}/core/libprocessgroup/include
    ${SRC}/core/libcutils/include
    ${SRC}/core/libutils/include
    ${SRC}/core/libutils/binder
    ${SRC}/core/libutils/binder/include
    ${SRC}/logging/liblog/include
    ${SRC}/libbase/include
    )
    