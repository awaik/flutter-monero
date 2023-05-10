import 'package:flutter/material.dart';

import 'package:monero_api/account_api.dart' as api;

class WalletAccountsWidget extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

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
                      child: Text("Основной адрес",
                          style: TextStyle(fontSize: 22)),
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
                      child: Text("Баланс", style: TextStyle(fontSize: 22)),
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
