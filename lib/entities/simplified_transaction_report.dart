import 'package:json_annotation/json_annotation.dart';

part 'simplified_transaction_report.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SimplifiedTransactionReport {

  @JsonKey(name: "utxo_groups")
  List<SimplifiedTransactionReportUtxoGroup> utxoGroups;

  SimplifiedTransactionReport({required this.utxoGroups});

  factory SimplifiedTransactionReport.fromJson(Map<String, dynamic> json) => _$SimplifiedTransactionReportFromJson(json);
  Map<String, dynamic> toJson() => _$SimplifiedTransactionReportToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SimplifiedTransactionReportUtxoGroup {

  @JsonKey(name: "assigned_utxos")
  List<SimplifiedTransactionReportUtxo> assignedUtxos;

  @JsonKey(name: "assigned_trades")
  List<SimplifiedTransactionReportTrade> assignedTrades;

  SimplifiedTransactionReportUtxoGroup({required this.assignedUtxos, required this.assignedTrades});

  factory SimplifiedTransactionReportUtxoGroup.fromJson(Map<String, dynamic> json) => _$SimplifiedTransactionReportUtxoGroupFromJson(json);
  Map<String, dynamic> toJson() => _$SimplifiedTransactionReportUtxoGroupToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SimplifiedTransactionReportUtxo {
  String id;

  SimplifiedTransactionReportUtxo({required this.id});

  factory SimplifiedTransactionReportUtxo.fromJson(Map<String, dynamic> json) => _$SimplifiedTransactionReportUtxoFromJson(json);
  Map<String, dynamic> toJson() => _$SimplifiedTransactionReportUtxoToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SimplifiedTransactionReportTrade {
  String id;

  @JsonKey(name: "tx_tree")
  SimplifiedTransactionReportTxTree txTree;

  SimplifiedTransactionReportTrade({required this.id, required this.txTree});

  factory SimplifiedTransactionReportTrade.fromJson(Map<String, dynamic> json) => _$SimplifiedTransactionReportTradeFromJson(json);
  Map<String, dynamic> toJson() => _$SimplifiedTransactionReportTradeToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class SimplifiedTransactionReportTxTree {

  @JsonKey(name: "raw_tx")
  String rawTx;

  @JsonKey(name: "child_raw_txs")
  List<String> childTawTxs;

  SimplifiedTransactionReportTxTree({required this.rawTx, required this.childTawTxs});

  factory SimplifiedTransactionReportTxTree.fromJson(Map<String, dynamic> json) => _$SimplifiedTransactionReportTxTreeFromJson(json);
  Map<String, dynamic> toJson() => _$SimplifiedTransactionReportTxTreeToJson(this);
}