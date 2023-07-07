import 'package:flutter/material.dart';
import 'package:monero_flutter/transaction_api.dart' as api;

class TransferPage extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  TransferPage({super.key});

  void _getOutputs() {
    try {
      String jsonRequest = _resultController.text;
      _resultController.text = api.getOutputs(jsonRequest);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getTxs() {
    try {
      String jsonRequest = _resultController.text;
      _resultController.text = api.getTxs(jsonRequest);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }


  void _describeTxSet() {
    try {
      String jsonRequest = _resultController.text;
      _resultController.text = api.describeTxSet(jsonRequest);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getTransfers() {
    try {
      _resultController.text = api.getAllTransfersAsJson();
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
                      child: Text("Get Outputs",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _getOutputs,
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
                      child:
                          Text("Get transfers", style: TextStyle(fontSize: 22)),
                      onPressed: _getTransfers,
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
