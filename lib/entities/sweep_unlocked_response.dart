import 'package:json_annotation/json_annotation.dart';
part 'sweep_unlocked_response.g.dart';

@JsonSerializable()
class SweepUnlockedResponse {
  List<SweepUnlockedResponseTxSet> txSets;

  SweepUnlockedResponse({
    required this.txSets,
  });

  factory SweepUnlockedResponse.fromJson(Map<String, dynamic> json) => _$SweepUnlockedResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SweepUnlockedResponseToJson(this);
}

@JsonSerializable()
class SweepUnlockedResponseTxSet {
  String multisigTxHex;
  List<SweepUnlockedResponseTransaction> txs;

  SweepUnlockedResponseTxSet({
    required this.multisigTxHex,
    required this.txs,
  });

  factory SweepUnlockedResponseTxSet.fromJson(Map<String, dynamic> json) => _$SweepUnlockedResponseTxSetFromJson(json);
  Map<String, dynamic> toJson() => _$SweepUnlockedResponseTxSetToJson(this);
}

@JsonSerializable()
class SweepUnlockedResponseTransaction {
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
  List<SweepUnlockedResponseInput> inputs;
  bool isOutgoing;
  bool isLocked;
  SweepUnlockedResponseOutgoingTransfer? outgoingTransfer;

  SweepUnlockedResponseTransaction({
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

  factory SweepUnlockedResponseTransaction.fromJson(Map<String, dynamic> json) => _$SweepUnlockedResponseTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$SweepUnlockedResponseTransactionToJson(this);
}

@JsonSerializable()
class SweepUnlockedResponseInput {
  SweepUnlockedResponseKeyImage keyImage;

  SweepUnlockedResponseInput({
    required this.keyImage,
  });

  factory SweepUnlockedResponseInput.fromJson(Map<String, dynamic> json) => _$SweepUnlockedResponseInputFromJson(json);
  Map<String, dynamic> toJson() => _$SweepUnlockedResponseInputToJson(this);
}

@JsonSerializable()
class SweepUnlockedResponseKeyImage {
  String hex;

  SweepUnlockedResponseKeyImage({
    required this.hex,
  });

  factory SweepUnlockedResponseKeyImage.fromJson(Map<String, dynamic> json) => _$SweepUnlockedResponseKeyImageFromJson(json);
  Map<String, dynamic> toJson() => _$SweepUnlockedResponseKeyImageToJson(this);
}

@JsonSerializable()
class SweepUnlockedResponseOutgoingTransfer {
  int amount;
  int accountIndex;
  List<int> subaddressIndices;
  List<SweepUnlockedResponseDestination> destinations;

  SweepUnlockedResponseOutgoingTransfer({
    required this.amount,
    required this.accountIndex,
    required this.subaddressIndices,
    required this.destinations,
  });

  factory SweepUnlockedResponseOutgoingTransfer.fromJson(Map<String, dynamic> json) => _$SweepUnlockedResponseOutgoingTransferFromJson(json);
  Map<String, dynamic> toJson() => _$SweepUnlockedResponseOutgoingTransferToJson(this);
}

@JsonSerializable()
class SweepUnlockedResponseDestination {
  int amount;
  String address;

  SweepUnlockedResponseDestination({
    required this.amount,
    required this.address,
  });

  factory SweepUnlockedResponseDestination.fromJson(Map<String, dynamic> json) => _$SweepUnlockedResponseDestinationFromJson(json);
  Map<String, dynamic> toJson() => _$SweepUnlockedResponseDestinationToJson(this);
}
