// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simplified_transaction_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimplifiedTransactionReport _$SimplifiedTransactionReportFromJson(
        Map<String, dynamic> json) =>
    SimplifiedTransactionReport(
      utxoGroups: (json['utxo_groups'] as List<dynamic>)
          .map((e) => SimplifiedTransactionReportUtxoGroup.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SimplifiedTransactionReportToJson(
        SimplifiedTransactionReport instance) =>
    <String, dynamic>{
      'utxo_groups': instance.utxoGroups.map((e) => e.toJson()).toList(),
    };

SimplifiedTransactionReportUtxoGroup
    _$SimplifiedTransactionReportUtxoGroupFromJson(Map<String, dynamic> json) =>
        SimplifiedTransactionReportUtxoGroup(
          assignedUtxos: (json['assigned_utxos'] as List<dynamic>)
              .map((e) => SimplifiedTransactionReportUtxo.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
          assignedTrades: (json['assigned_trades'] as List<dynamic>)
              .map((e) => SimplifiedTransactionReportTrade.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$SimplifiedTransactionReportUtxoGroupToJson(
        SimplifiedTransactionReportUtxoGroup instance) =>
    <String, dynamic>{
      'assigned_utxos': instance.assignedUtxos.map((e) => e.toJson()).toList(),
      'assigned_trades':
          instance.assignedTrades.map((e) => e.toJson()).toList(),
    };

SimplifiedTransactionReportUtxo _$SimplifiedTransactionReportUtxoFromJson(
        Map<String, dynamic> json) =>
    SimplifiedTransactionReportUtxo(
      id: json['id'] as String,
    );

Map<String, dynamic> _$SimplifiedTransactionReportUtxoToJson(
        SimplifiedTransactionReportUtxo instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

SimplifiedTransactionReportTrade _$SimplifiedTransactionReportTradeFromJson(
        Map<String, dynamic> json) =>
    SimplifiedTransactionReportTrade(
      id: json['id'] as String,
      txTree: SimplifiedTransactionReportTxTree.fromJson(
          json['tx_tree'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SimplifiedTransactionReportTradeToJson(
        SimplifiedTransactionReportTrade instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tx_tree': instance.txTree.toJson(),
    };

SimplifiedTransactionReportTxTree _$SimplifiedTransactionReportTxTreeFromJson(
        Map<String, dynamic> json) =>
    SimplifiedTransactionReportTxTree(
      rawTx: json['raw_tx'] as String,
      childTawTxs: (json['child_raw_txs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SimplifiedTransactionReportTxTreeToJson(
        SimplifiedTransactionReportTxTree instance) =>
    <String, dynamic>{
      'raw_tx': instance.rawTx,
      'child_raw_txs': instance.childTawTxs,
    };
