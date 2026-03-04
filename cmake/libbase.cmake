set(LIBBASE_SRCS
    ${SRC}/libbase/chrono_utils.cpp
    ${SRC}/libbase/errors_unix.cpp
    ${SRC}/libbase/file.cpp
    ${SRC}/libbase/logging.cpp
    ${SRC}/libbase/mapped_file.cpp
    ${SRC}/libbase/parsebool.cpp
    ${SRC}/libbase/parsenetaddress.cpp
    ${SRC}/libbase/posix_strerror_r.cpp
    ${SRC}/libbase/process.cpp
    ${SRC}/libbase/properties.cpp
    ${SRC}/libbase/stringprintf.cpp
    ${SRC}/libbase/strings.cpp
    ${SRC}/libbase/test_utils.cpp
    ${SRC}/libbase/threads.cpp
    )

# cmsg.cpp requires sys/socket.h (Unix only)
if(NOT WIN32)
    list(APPEND LIBBASE_SRCS ${SRC}/libbase/cmsg.cpp)
endif()

add_library(libbase STATIC ${LIBBASE_SRCS})

target_include_directories(libbase PRIVATE
    ${SRC}/libbase/include 
    ${SRC}/core/include 
    ${SRC}/logging/liblog/include
    )

# __builtin_available is an Apple Clang extension; on GCC (Linux/Windows) define it as always-true.
if(NOT APPLE)
    target_compile_options(libbase PRIVATE "-D__builtin_available(...)=1")
endif()

# localtime_r is POSIX-only; map it to the Windows equivalent localtime_s (note reversed arg order).
# The POSIX version returns struct tm* (second arg on success, NULL on failure); emulate that.
if(WIN32)
    target_compile_options(libbase PRIVATE "-Dlocaltime_r(tp,tm)=(localtime_s((tm),(tp))==0?(tm):NULL)")
endif()
