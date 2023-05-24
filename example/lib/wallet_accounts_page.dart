import 'package:flutter/material.dart';
import 'package:monero_flutter/account_api.dart' as api;

class WalletAccountsPage extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  WalletAccountsPage({super.key});

  void _getAddress() {
    try {
      _resultController.text = api.getAddress().toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getBalance() {
    try {
      _resultController.text = api.getFullBalance().toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monero :: Addresses')),
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
                      child: Text("Main address", style: TextStyle(fontSize: 22)),
                      onPressed: _getAddress,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        minimumSize: Size(360, 60),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Balance", style: TextStyle(fontSize: 22)),
                      onPressed: _getBalance,
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
