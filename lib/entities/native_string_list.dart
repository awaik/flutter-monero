import 'dart:ffi';

import 'package:ffi/ffi.dart';

class NativeList {

  late int _size;

  late List<Pointer<Char>> _pointerList;
  late Pointer<Pointer<Char>> _pointerToPointers;

  int get size => _size;
  Pointer<Pointer<Char>> get pointerToPointers => _pointerToPointers;

  NativeList(List<String> origin) {
    _size = origin.length;
    final pointerList = origin.map((info) => info.toNativeUtf8().cast<Char>()).toList();

    final Pointer<Pointer<Char>> pointerToPointers = calloc(_size);

    for (int i = 0; i < _size; i++) {
      pointerToPointers[i] = pointerList[i];
    }

    _pointerList = pointerList;
    _pointerToPointers = pointerToPointers;
  }

  void free() {

    for (var element in _pointerList) {
      calloc.free(element);
    }

    calloc.free(_pointerToPointers);
  }
}