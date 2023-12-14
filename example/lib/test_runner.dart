import 'package:flutter/material.dart';

import 'test_result.dart';

Stream<TestResult> _runAll() async* {

  List<TestFunction> testFunctions = [];

  for (final testFunction in testFunctions) {
    TestResult testResult;

    try {
      testResult = await testFunction();
    } catch (e) {
      testResult = TestResult("unknown", false, message: e.toString());
    }

    yield testResult;
  }
}

class TestRunnerApp extends StatelessWidget {
  const TestRunnerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Runner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TestRunnerScreen(),
    );
  }
}

class TestRunnerScreen extends StatefulWidget {
  const TestRunnerScreen({super.key});

  @override
  TestRunnerScreenState createState() => TestRunnerScreenState();
}

class TestRunnerScreenState extends State<TestRunnerScreen> {
  final _resultController = TextEditingController();
  bool _isLoop = false;
  bool _work = false;
  bool _stopRequested = false;

  @override
  void dispose() {
    _resultController.dispose();
    super.dispose();
  }

  void _test(BuildContext context) async {
    if (_work) {
      return;
    }

    _stopRequested = false;
    _work = true;

    do {
      if (_stopRequested) {
        break;
      }

      await for (final testResult in _runAll()) {

        if (_stopRequested) {
          break;
        }

        _resultController.text +=
        "[${testResult.success ? "+" : "-"}] ${testResult.name} -> ${testResult.message ?? ""}\r\n>>> ======== <<<\r\n";
      }

      await Future.delayed(const Duration(microseconds: 100));
    } while (_isLoop);

    if (_stopRequested) {
      _resultController.text += "\r\n=== Stopped! ===\r\n";
    }

    _resultController.text += "\r\n=== Done! ===\r\n";

    _work = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test runner')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _resultController,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.top,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Checkbox(
                value: _isLoop,
                onChanged: (bool? value) {
                  setState(() {
                    _isLoop = value ?? false;
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLoop = !_isLoop;
                  });
                },
                child: const Text('Loop'),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      _stopRequested = true;
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      minimumSize: const Size(360, 60),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Stop', style: TextStyle(fontSize: 22)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      _test(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      minimumSize: const Size(360, 60),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Run all tests',
                        style: TextStyle(fontSize: 22)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
