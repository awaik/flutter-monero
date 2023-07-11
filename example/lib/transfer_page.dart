import 'package:flutter/material.dart';
import 'package:monero_flutter/entities/describe_multisig_tx_request.dart';
import 'package:monero_flutter/entities/sweep_unlocked_request.dart';
import 'package:monero_flutter/entities/txs_request.dart';
import 'package:monero_flutter/transaction_api.dart' as api;

class TransferPage extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  TransferPage({super.key});

  void _getUtxos() {
    try {
      _resultController.text = "hash=${api.getUtxos().blocks[0].txs[0].hash}; amount=${api.getUtxos().blocks[0].txs[0].outputs[0].amount}";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getTxs() {
    try {
      final hash = _resultController.text;
      _resultController.text = "numConfirmations=${api.getTxs(TxsRequest(txs: [TxsRequestBody(hash: hash)])).blocks[0].txs[0].numConfirmations}";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _describeTxSet() {
    try {
      final request = DescribeMultisigTxRequest(multisigTxHex: _resultController.text);
      _resultController.text = "outputSum=${api.describeTxSet(request).txs[0].outputSum}";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _sweepUnlocked() {
    try {
      final address = _resultController.text;
      final request = SweepUnlockedRequest(destinations: [SweepUnlockedRequestDestination(address: address)]);
      _resultController.text = "hash=${api.sweepUnlocked(request).txSets[0].txs[0].hash}";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getTransfersAsJson() {
    try {
      _resultController.text = api.getAllTransfersAsJson();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getTransfers() {
    try {
      _resultController.text = "amount=${api.getAllTransactions()[0].amount}";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _thaw() {
    try {
      api.thaw(_resultController.text);
      _resultController.text = "ok";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _freeze() {
    try {
      api.freeze(_resultController.text);
      _resultController.text = "ok";
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _isFrozen() {
    try {
      _resultController.text = api.isFrozen(_resultController.text).toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monero :: Transfers')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _resultController,
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Get Utxos",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _getUtxos,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Get Txs",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _getTxs,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Describe TxSet",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _describeTxSet,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Sweep unlocked",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _sweepUnlocked,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                          Text("Get transfers (JSON)", style: TextStyle(fontSize: 22)),
                      onPressed: _getTransfersAsJson,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                      Text("Get transfers", style: TextStyle(fontSize: 22)),
                      onPressed: _getTransfers,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                      Text("Thaw", style: TextStyle(fontSize: 22)),
                      onPressed: _thaw,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                      Text("Freeze", style: TextStyle(fontSize: 22)),
                      onPressed: _freeze,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child:
                      Text("IsFrozen", style: TextStyle(fontSize: 22)),
                      onPressed: _isFrozen,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
