import 'package:flutter/material.dart';
import 'package:monero_flutter/account_api.dart' as api;

class WalletAccountsPage extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  WalletAccountsPage({super.key});

  void _getAddress() async {
    try {
      _resultController.text = (await api.getAddress()).toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getReceiveAddress() async {
    try {
      _resultController.text = await api.getReceiveAddress();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _getBalance() async {
    try {
      _resultController.text = (await api.getFullBalance()).toString();
    } catch (e) {
      _resultController.text = e.toString();
    }
  }

  void _subaddressTest() async {
    try {
      //await api.addAccount(label: "test1");

      await api.refreshAccounts();
      final accountCount = await api.getAccountCount();

      if (accountCount > 0){
        int index = accountCount - 1;
        await api.addSubaddress(accountIndex: index, label: "test subaddress 1");
      }

      for (int i = 0; i < accountCount; i++) {
        await api.refreshSubaddresses(accountIndex: i);
      }

      final accounts = await api.getAllAccounts();
      final subaddresses = await api.getAllSubaddresses();

      if (accounts.isNotEmpty) {
        int accountIndex = accounts.length - 1;
        int subaddressIndex = subaddresses.length - 1;
        _resultController.text = "${accounts[accountIndex].label} ${subaddresses[subaddressIndex].label}=${subaddresses[subaddressIndex].address}";
      }
      else{
        _resultController.text = "empty";
      }
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
                      child:
                          Text("Main address", style: TextStyle(fontSize: 22)),
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
                      child: Text("Receive address",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _getReceiveAddress,
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
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: Text("Subaddress test",
                          style: TextStyle(fontSize: 22)),
                      onPressed: _subaddressTest,
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
