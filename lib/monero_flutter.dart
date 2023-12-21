import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:monero_flutter/entities/error_info.dart';
import 'package:monero_flutter/entities/native_string_list.dart';

import 'monero_ffi_bindings_generated.dart';

const String _libName = 'monero_flutter';

/// The dynamic library in which the symbols for [MoneroFlutterBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final MoneroApiBindings bindings = MoneroApiBindings(_dylib);

Pointer<ErrorBox> buildErrorBoxPointer() {
  Pointer<ErrorBox> pointerToErrorBox = calloc.call();

  pointerToErrorBox.ref.code = 0;
  pointerToErrorBox.ref.message = nullptr;

  return pointerToErrorBox;
}

ErrorInfo extractErrorInfo(Pointer<ErrorBox> errorBoxPointer) {
  final code = errorBoxPointer.ref.code;
  String? message;

  if (0 != code) {
    message = errorBoxPointer.ref.message.cast<Utf8>().toDartString();
  }

  if (nullptr != errorBoxPointer.ref.message) {
    calloc.free(errorBoxPointer.ref.message);
  }

  calloc.free(errorBoxPointer);

  return ErrorInfo(code: code, message: message);
}

String? extractString(Pointer<Char> charPointer) {
  if (nullptr == charPointer) {
    return null;
  }

  String value = charPointer.cast<Utf8>().toDartString();
  calloc.free(charPointer);
  return value;
}

Pointer<Uint8> toNativeByteArray(Uint8List bytes) {
  final nativeData = calloc<Uint8>(bytes.length);
  nativeData.asTypedList(bytes.length).setAll(0, bytes);

  return nativeData;
}

NativeList fromStringList(List<String> sourceList) {
  return NativeList(sourceList);
}

List<String> toList(Pointer<Pointer<Char>> pointers) {

  if (nullptr == pointers) {
    return [];
  }

  final list = <String>[];

  var i = 0;

  while (true) {
    final pointer = pointers.elementAt(i).value;

    if (pointer == nullptr) {
      break;
    }

    final string = pointer.cast<Utf8>().toDartString();
    list.add(string);
    i++;
  }

  i = 0;
  while (true) {
    final pointer = pointers.elementAt(i).value;

    if (pointer == nullptr) {
      break;
    }

    calloc.free(pointer);
    i++;
  }

  calloc.free(pointers);

  return list;
}