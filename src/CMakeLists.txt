cmake_minimum_required(VERSION 3.4.1)

add_library(monero_flutter
    SHARED
    monero_flutter.cpp)

find_library( log-lib log )

set(EXTERNAL_DIR ${CMAKE_SOURCE_DIR}/../android/external)

add_library(wallet_api STATIC IMPORTED)
set_target_properties(wallet_api PROPERTIES IMPORTED_LOCATION
        ${EXTERNAL_DIR}/${ANDROID_ABI}/lib/libwallet_api.a)

add_library(monero_ffi_so SHARED IMPORTED)
set_target_properties(monero_ffi_so PROPERTIES IMPORTED_LOCATION
    ${EXTERNAL_DIR}/${ANDROID_ABI}/lib/libmonero-ffi.so)

add_library(iconv_so SHARED IMPORTED)
set_target_properties(iconv_so PROPERTIES IMPORTED_LOCATION
    ${EXTERNAL_DIR}/${ANDROID_ABI}/lib/libiconv.so)

target_link_libraries(monero_flutter
    monero_ffi_so
    # libwallet-crypto.a if(${ANDROID_ABI} STREQUAL "x86_64")
    wallet_api
    iconv_so
    ${log-lib})
