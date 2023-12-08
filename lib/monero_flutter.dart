
import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';

import 'monero_ffi_bindings_generated.dart';

//int sum(int a, int b) => _bindings.sum(a, b);

String test() {
  Pointer<ErrorBox> pointerToErrorBox = calloc.call();

  pointerToErrorBox.ref.code = 0;
  pointerToErrorBox.ref.message = nullptr;

  _bindings.get_current_height(pointerToErrorBox);

  final message = pointerToErrorBox.ref.message.cast<Utf8>().toDartString();

  return message;
}

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
final MoneroFlutterBindings _bindings = MoneroFlutterBindings(_dylib);