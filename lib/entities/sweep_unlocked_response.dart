import 'package:json_annotation/json_annotation.dart';
part 'sweep_unlocked_response.g.dart';

@JsonSerializable()
class Data {
  List<TxSet> txSets;

  Data({
    required this.txSets,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class TxSet {
  String multisigTxHex;
  List<Transaction> txs;

  TxSet({
    required this.multisigTxHex,
    required this.txs,
  });

  factory TxSet.fromJson(Map<String, dynamic> json) => _$TxSetFromJson(json);
  Map<String, dynamic> toJson() => _$TxSetToJson(this);
}

@JsonSerializable()
class Transaction {
  int fee;
  int ringSize;
  int numConfirmations;
  int unlockHeight;
  int weight;
  String hash;
  String key;
  String fullHex;
  String metadata;
  bool isMinerTx;
  bool relay;
  bool isRelayed;
  bool isConfirmed;
  bool inTxPool;
  bool isFailed;
  List<Input> inputs;
  bool isOutgoing;
  bool isLocked;
  OutgoingTransfer? outgoingTransfer;

  Transaction({
    required this.fee,
    required this.ringSize,
    required this.numConfirmations,
    required this.unlockHeight,
    required this.weight,
    required this.hash,
    required this.key,
    required this.fullHex,
    required this.metadata,
    required this.isMinerTx,
    required this.relay,
    required this.isRelayed,
    required this.isConfirmed,
    required this.inTxPool,
    required this.isFailed,
    required this.inputs,
    required this.isOutgoing,
    required this.isLocked,
    this.outgoingTransfer,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class Input {
  KeyImage keyImage;

  Input({
    required this.keyImage,
  });

  factory Input.fromJson(Map<String, dynamic> json) => _$InputFromJson(json);
  Map<String, dynamic> toJson() => _$InputToJson(this);
}

@JsonSerializable()
class KeyImage {
  String hex;

  KeyImage({
    required this.hex,
  });

  factory KeyImage.fromJson(Map<String, dynamic> json) => _$KeyImageFromJson(json);
  Map<String, dynamic> toJson() => _$KeyImageToJson(this);
}

@JsonSerializable()
class OutgoingTransfer {
  int amount;
  int accountIndex;
  List<int> subaddressIndices;
  List<Destination> destinations;

  OutgoingTransfer({
    required this.amount,
    required this.accountIndex,
    required this.subaddressIndices,
    required this.destinations,
  });

  factory OutgoingTransfer.fromJson(Map<String, dynamic> json) => _$OutgoingTransferFromJson(json);
  Map<String, dynamic> toJson() => _$OutgoingTransferToJson(this);
}

@JsonSerializable()
class Destination {
  int amount;
  String address;

  Destination({
    required this.amount,
    required this.address,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => _$DestinationFromJson(json);
  Map<String, dynamic> toJson() => _$DestinationToJson(this);
}
