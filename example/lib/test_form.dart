import 'package:flutter/material.dart';

class TestForm extends StatelessWidget {
  final TextEditingController _resultController = TextEditingController();

  TestForm({super.key});

  void _test() async {
    _resultController.text = "test";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Form')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _resultController,
            maxLines: 8,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const Divider(),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 0, bottom: 0),
                  child: ElevatedButton(
                    onPressed: _test,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size((MediaQuery.of(context).size.width - 40) * 0.5 - 5, 60),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Text("Start", style: TextStyle(fontSize: 22)),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 0, bottom: 0),
                  child: ElevatedButton(
                    onPressed: _test,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size((MediaQuery.of(context).size.width - 40) * 0.5 - 5, 60),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: const Text("Stop", style: TextStyle(fontSize: 22)),
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
