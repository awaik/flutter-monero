import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class ExternalAccountRow extends Struct {
  @Int64()
  external int id;

  external Pointer<Char> label;

  AccountRow buildAccountRow() {
    return AccountRow(id, label.cast<Utf8>().toDartString());
  }
}

class AccountRow {
  final int _id;
  final String _label;

  int get id {return _id;}
  String get label {return _label;}

  AccountRow(this._id, this._label);
}