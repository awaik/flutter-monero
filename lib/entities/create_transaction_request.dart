import 'package:json_annotation/json_annotation.dart';

part 'create_transaction_request.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class CreateTransactionRequest
{
  List<CreateTransactionRequestDestination> destinations;
  int accountIndex;
  List<int> subaddressIndices;

  CreateTransactionRequest({
    required this.destinations,
    required this.accountIndex,
    required this.subaddressIndices,
  });

  factory CreateTransactionRequest.fromJson(Map<String, dynamic> json) => _$CreateTransactionRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionRequestToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class CreateTransactionRequestDestination {
  String address;
  int amount;

  CreateTransactionRequestDestination({required this.address, required this.amount});

  factory CreateTransactionRequestDestination.fromJson(Map<String, dynamic> json) => _$CreateTransactionRequestDestinationFromJson(json);
  Map<String, dynamic> toJson() => _$CreateTransactionRequestDestinationToJson(this);
}