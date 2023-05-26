import 'package:flutter/material.dart';
import 'package:monero_flutter/multisig_api.dart' as api;
import 'package:monero_flutter/transaction_api.dart' as transaction_api;

class MultisigPage extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  MultisigPage({super.key});

  void _isMultisig() {
    try {
      _resultController.text = api.isMultisig().toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _prepareMultisig() {
    try {
      _resultController.text = api.prepareMultisig();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getMultisigInfo() {
    try {
      _resultController.text = api.getMultisigInfo();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _exchangeMultisigKeys() {
    try {
      List<String> list = _resultController.text.split(" ");
      _resultController.text = api.exchangeMultisigKeys(infoList: list);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _isMultisigImportNeeded() {
    try {
      _resultController.text = api.isMultisigImportNeeded().toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _makeMultisig() {
    try {
      List<String> list = [_resultController.text];
      _resultController.text = api.makeMultisig(infoList: list,threshold: 2);
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _importMultisigImages() {
    try {
      List<String> list = [_resultController.text];
      _resultController.text = api.importMultisigImages(infoList: list).toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _exportMultisigImages() {
    try {
      _resultController.text = api.exportMultisigImages();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _createTransaction() {
    try {
      final result = transaction_api.createTransactionSync(
          address: "428vUehXqLfAG3udx8MgFNYjuMWs4dAEvZ2h5ttsHV711WLYhbU6Qto4VPoFcKxtYF4ugeMfbLmg2YhPKwC8aLJ2DWMTUkL",
          amount: "0.001");
      _resultController.text = result.multisigSignData;
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _signMultisigTxHex() {
    try {
      final result = api.signMultisigTxHex(_resultController.text);
      _resultController.text = result;
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _submitMultisigTxHex() {
    try {
      final result = api.submitMultisigTxHex(_resultController.text);
      _resultController.text = result[0];
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monero :: Счета')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _resultController,
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
                      child: Text("Check multisig", style: TextStyle(fontSize: 22)),
                      onPressed: _isMultisig,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("1. Prepare_multisig", style: TextStyle(fontSize: 22)),
                      onPressed: _prepareMultisig,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("2. Get_multisig_info", style: TextStyle(fontSize: 22)),
                      onPressed: _getMultisigInfo,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("3. Make_multisig", style: TextStyle(fontSize: 22)),
                      onPressed: _makeMultisig,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("4. Exchange_multisig_keys", style: TextStyle(fontSize: 22)),
                      onPressed: _exchangeMultisigKeys,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("is_multisig_import_needed", style: TextStyle(fontSize: 22)),
                      onPressed: _isMultisigImportNeeded,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("import_multisig_images", style: TextStyle(fontSize: 22)),
                      onPressed: _importMultisigImages,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("export_multisig_images", style: TextStyle(fontSize: 22)),
                      onPressed: _exportMultisigImages,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("sign_multisig", style: TextStyle(fontSize: 22)),
                      onPressed: _signMultisigTxHex,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("submitMultisigTxHex", style: TextStyle(fontSize: 22)),
                      onPressed: _submitMultisigTxHex,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Create transaction", style: TextStyle(fontSize: 22)),
                      onPressed: _createTransaction,
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
