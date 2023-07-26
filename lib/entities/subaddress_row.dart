import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class ExternalSubaddressRow extends Struct {
  @Int64()
  external int id;
  external Pointer<Utf8> address;
  external Pointer<Utf8> label;

  SubaddressRow buildSubaddressRow() {
    return SubaddressRow(id, address.cast<Utf8>().toDartString(), label.cast<Utf8>().toDartString());
  }
}

class SubaddressRow {

  final int _id;
  final String _address;
  final  String _label;

  int get id {return _id;}
  String get address {return _address;}
  String get label {return _label;}

  SubaddressRow(this._id, this._address, this._label);
}