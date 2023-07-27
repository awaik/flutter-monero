import 'package:json_annotation/json_annotation.dart';

part 'simplified_transaction_request.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SimplifiedTransactionRequest{
  List<SimplifiedTransactionRequestDestination> destinations;

  SimplifiedTransactionRequest({
    required this.destinations
  });

  factory SimplifiedTransactionRequest.fromJson(Map<String, dynamic> json) => _$SimplifiedTransactionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SimplifiedTransactionRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SimplifiedTransactionRequestDestination {
  String address;
  int amount;

  SimplifiedTransactionRequestDestination({required this.address, required this.amount});

  factory SimplifiedTransactionRequestDestination.fromJson(Map<String, dynamic> json) => _$SimplifiedTransactionRequestDestinationFromJson(json);
  Map<String, dynamic> toJson() => _$SimplifiedTransactionRequestDestinationToJson(this);
}