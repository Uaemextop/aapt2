set(LIBLOG_SRCS
    ${SRC}/logging/liblog/log_event_list.cpp
    ${SRC}/logging/liblog/log_event_write.cpp
    ${SRC}/logging/liblog/logger_name.cpp
    ${SRC}/logging/liblog/logger_read.cpp
    ${SRC}/logging/liblog/logger_write.cpp
    ${SRC}/logging/liblog/properties.cpp
    ${SRC}/logging/liblog/logprint.cpp
    )

# These files use POSIX-only APIs (mmap, strptime, O_CLOEXEC, Unix sockets)
# and are not needed for the host-side aapt2 log backend on Windows.
if(NOT WIN32)
    list(APPEND LIBLOG_SRCS
        ${SRC}/logging/liblog/event_tag_map.cpp
        ${SRC}/logging/liblog/log_time.cpp
        ${SRC}/logging/liblog/pmsg_reader.cpp
        ${SRC}/logging/liblog/pmsg_writer.cpp
        ${SRC}/logging/liblog/logd_reader.cpp
        ${SRC}/logging/liblog/logd_writer.cpp
    )
endif()

add_library(liblog STATIC ${LIBLOG_SRCS})

target_compile_definitions(liblog PRIVATE
    -DLIBLOG_LOG_TAG=1006 
    -D_XOPEN_SOURCE=700 
    -DFAKE_LOG_DEVICE=1
    -DSNET_EVENT_LOG_TAG=1397638686
    -DANDROID_DEBUGGABLE=0
    )
    
target_include_directories(liblog PRIVATE
    ${SRC}/core/include
    ${SRC}/core/libutils/include
    ${SRC}/core/libcutils/include
    ${SRC}/core/libsystem/include

    ${SRC}/logging/liblog/include
    ${SRC}/libbase/include
    )
    