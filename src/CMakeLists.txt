# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(monero_flutter_library VERSION 0.0.1 LANGUAGES C)

add_library(monero_flutter SHARED
  "monero_flutter.c"
)

set_target_properties(monero_flutter PROPERTIES
  PUBLIC_HEADER monero_flutter.h
  OUTPUT_NAME "monero_flutter"
)

target_compile_definitions(monero_flutter PUBLIC DART_SHARED_LIB)
