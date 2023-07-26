import 'package:json_annotation/json_annotation.dart';
part 'outputs_request.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class OutputsRequest {

  int? minAmount;
  int? amount;
  int? maxAmount;

  int? index;
  int? accountIndex;
  int? subaddressIndex;
  OutputsRequestKeyImage? keyImage;
  bool? isSpent;
  bool? isFrozen;

  @JsonKey(name: "txQuery")
  OutputsRequestTxQuery? txQuery;

  OutputsRequest({this.minAmount,
    this.amount,
    this.maxAmount,
    this.index,
    this.accountIndex,
    this.subaddressIndex,
    this.keyImage,
    this.isSpent,
    this.isFrozen,
    this.txQuery,
    });

  factory OutputsRequest.fromJson(Map<String, dynamic> json) => _$OutputsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class OutputsRequestKeyImage {
  String? hex;
  String? signature;

  OutputsRequestKeyImage({this.hex, this.signature});

  factory OutputsRequestKeyImage.fromJson(Map<String, dynamic> json) => _$OutputsRequestKeyImageFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsRequestKeyImageToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class OutputsRequestTxQuery {

  bool? isOutgoing;
  bool? isIncoming;
  bool? isLocked;
  bool? isConfirmed;
  bool? isRelayed;
  bool? isDoubleSpendSeen;
  int? inputSum;
  int? outputSum;

  OutputsRequestTxQuery({this.isOutgoing,
      this.isIncoming,
      this.isLocked,
      this.isConfirmed,
      this.isRelayed,
      this.isDoubleSpendSeen,
      this.inputSum,
      this.outputSum});

  factory OutputsRequestTxQuery.fromJson(Map<String, dynamic> json) => _$OutputsRequestTxQueryFromJson(json);
  Map<String, dynamic> toJson() => _$OutputsRequestTxQueryToJson(this);
}