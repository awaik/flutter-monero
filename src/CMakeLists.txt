cmake_minimum_required(VERSION 3.4.1)

set(EXTERNAL_DIR ${CMAKE_SOURCE_DIR}/../android/external)

add_library(monero_flutter
    SHARED
    monero_flutter.cpp)

add_library(monero-ffi SHARED IMPORTED)
set_target_properties(monero-ffi PROPERTIES IMPORTED_LOCATION
    ${EXTERNAL_DIR}/${ANDROID_ABI}/lib/libmonero-ffi.so)

add_library(charset SHARED IMPORTED)
set_target_properties(charset PROPERTIES IMPORTED_LOCATION
    ${EXTERNAL_DIR}/${ANDROID_ABI}/lib/libcharset.so)

add_library(iconv SHARED IMPORTED)
set_target_properties(iconv PROPERTIES IMPORTED_LOCATION
    ${EXTERNAL_DIR}/${ANDROID_ABI}/lib/libiconv.so)

add_library(boost_program_options STATIC IMPORTED)
set_target_properties(boost_program_options PROPERTIES IMPORTED_LOCATION
    ${EXTERNAL_DIR}/${ANDROID_ABI}/lib/libboost_program_options.a)

target_link_libraries(monero_flutter
    monero-ffi
    charset
    iconv
    boost_program_options
)