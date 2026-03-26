# packagelistparser uses POSIX-only types (uid_t, gid_t, __BEGIN_DECLS) and
# functions (getline) that are not available on Windows.
if(NOT WIN32)
add_library(libpackagelistparser STATIC
${SRC}/core/libpackagelistparser/packagelistparser.cpp
)

target_include_directories(libpackagelistparser PRIVATE
${SRC}/core/libpackagelistparser/include
${SRC}/logging/liblog/include
)
endif()
