import 'package:json_annotation/json_annotation.dart';
part 'outputs_response.g.dart';

@JsonSerializable()
class OutputsResponse {
  List<Block> blocks;

  OutputsResponse({
    required this.blocks,
  });

  factory OutputsResponse.fromJson(Map<String, dynamic> json) => _$OutputsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsResponseToJson(this);
}

@JsonSerializable()
class Block {
  int height;
  List<Transaction> txs;

  Block({
    required this.height,
    required this.txs,
  });

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);
  Map<String, dynamic> toJson() => _$BlockToJson(this);
}

@JsonSerializable()
class Transaction {
  String hash;
  bool relay;
  bool isRelayed;
  bool isConfirmed;
  bool inTxPool;
  bool isDoubleSpendSeen;
  bool isFailed;
  List<Output> outputs;
  bool isLocked;

  Transaction({
    required this.hash,
    required this.relay,
    required this.isRelayed,
    required this.isConfirmed,
    required this.inTxPool,
    required this.isDoubleSpendSeen,
    required this.isFailed,
    required this.outputs,
    required this.isLocked,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class Output {
  int amount;
  int index;
  String stealthPublicKey;
  KeyImage keyImage;
  int accountIndex;
  int subaddressIndex;
  bool isSpent;
  bool isFrozen;

  Output({
    required this.amount,
    required this.index,
    required this.stealthPublicKey,
    required this.keyImage,
    required this.accountIndex,
    required this.subaddressIndex,
    required this.isSpent,
    required this.isFrozen,
  });

  factory Output.fromJson(Map<String, dynamic> json) => _$OutputFromJson(json);
  Map<String, dynamic> toJson() => _$OutputToJson(this);
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