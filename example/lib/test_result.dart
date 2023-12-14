class TestResult {
  String name;
  bool success;
  String? message;

  TestResult(this.name, this.success, {this.message});

  static TestResult get ok => TestResult("...", true);
}

typedef TestFunction = Future<TestResult> Function();