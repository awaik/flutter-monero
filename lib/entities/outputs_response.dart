import 'package:json_annotation/json_annotation.dart';

part 'outputs_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OutputsResponse {
  List<OutputsResponseBlock> blocks;

  OutputsResponse({
    required this.blocks,
  });

  factory OutputsResponse.fromJson(Map<String, dynamic> json) => _$OutputsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OutputsResponseBlock {
  int height;
  List<OutputsResponseTransaction> txs;

  OutputsResponseBlock({
    required this.height,
    required this.txs,
  });

  factory OutputsResponseBlock.fromJson(Map<String, dynamic> json) => _$OutputsResponseBlockFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsResponseBlockToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OutputsResponseTransaction {
  String hash;
  bool relay;
  bool isRelayed;
  bool isConfirmed;
  bool inTxPool;
  bool isDoubleSpendSeen;
  bool isFailed;
  List<OutputsResponseOutput> outputs;
  bool isLocked;

  OutputsResponseTransaction({
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

  factory OutputsResponseTransaction.fromJson(Map<String, dynamic> json) => _$OutputsResponseTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsResponseTransactionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OutputsResponseOutput {
  int amount;
  int index;
  String stealthPublicKey;
  OutputsResponseKeyImage? keyImage;
  int accountIndex;
  int subaddressIndex;
  bool isSpent;
  bool isFrozen;

  OutputsResponseOutput({
    required this.amount,
    required this.index,
    required this.stealthPublicKey,
    this.keyImage,
    required this.accountIndex,
    required this.subaddressIndex,
    required this.isSpent,
    required this.isFrozen,
  });

  factory OutputsResponseOutput.fromJson(Map<String, dynamic> json) => _$OutputsResponseOutputFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsResponseOutputToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OutputsResponseKeyImage {
  String hex;

  OutputsResponseKeyImage({
    required this.hex,
  });

  factory OutputsResponseKeyImage.fromJson(Map<String, dynamic> json) => _$OutputsResponseKeyImageFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsResponseKeyImageToJson(this);
}
