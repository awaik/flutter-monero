import 'dart:ffi';
import 'package:ffi/ffi.dart';

class AccountRow extends Struct {
  @Int64()
  external int id;

  external Pointer<Char> label;

  String getLabel() => label.cast<Utf8>().toDartString();

  int getId() => id;
}