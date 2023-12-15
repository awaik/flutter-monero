import 'package:json_annotation/json_annotation.dart';
part 'txs_response.g.dart';

@JsonSerializable(explicitToJson: true)
class TxsResponse {
  List<TxResponseBlock> blocks;

  TxsResponse({
    required this.blocks,
  });

  factory TxsResponse.fromJson(Map<String, dynamic> json) => _$TxsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TxsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TxResponseBlock {
  int height;
  int timestamp;
  List<TxResponseTransaction> txs;

  TxResponseBlock({
    required this.height,
    required this.timestamp,
    required this.txs,
  });

  factory TxResponseBlock.fromJson(Map<String, dynamic> json) => _$TxResponseBlockFromJson(json);
  Map<String, dynamic> toJson() => _$TxResponseBlockToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TxResponseTransaction {
  int fee;
  int numConfirmations;
  int unlockHeight;
  String hash;
  bool isMinerTx;
  bool relay;
  bool isRelayed;
  bool isConfirmed;
  bool inTxPool;
  bool isDoubleSpendSeen;
  bool isFailed;
  bool isIncoming;
  bool isOutgoing;
  bool isLocked;
  List<TxResponseIncomingTransfer> incomingTransfers;

  TxResponseTransaction({
    required this.fee,
    required this.numConfirmations,
    required this.unlockHeight,
    required this.hash,
    required this.isMinerTx,
    required this.relay,
    required this.isRelayed,
    required this.isConfirmed,
    required this.inTxPool,
    required this.isDoubleSpendSeen,
    required this.isFailed,
    required this.isIncoming,
    required this.isOutgoing,
    required this.isLocked,
    required this.incomingTransfers,
  });

  factory TxResponseTransaction.fromJson(Map<String, dynamic> json) => _$TxResponseTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TxResponseTransactionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TxResponseIncomingTransfer {
  int amount;
  int accountIndex;
  int subaddressIndex;
  int numSuggestedConfirmations;
  String address;

  TxResponseIncomingTransfer({
    required this.amount,
    required this.accountIndex,
    required this.subaddressIndex,
    required this.numSuggestedConfirmations,
    required this.address,
  });

  factory TxResponseIncomingTransfer.fromJson(Map<String, dynamic> json) => _$TxResponseIncomingTransferFromJson(json);
  Map<String, dynamic> toJson() => _$TxResponseIncomingTransferToJson(this);
}