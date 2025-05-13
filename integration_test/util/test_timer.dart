// ignore_for_file: avoid_print

/// A small utility to measure test durations.
class TestTimer {
  late final DateTime _startTime;
  final String testName;

  TestTimer(this.testName);

  /// Call this at the beginning of the test.
  void start() {
    _startTime = DateTime.now();
    // For testing code, use print() instead of logger for simplicity, speed,
    // and console output:
    print('⏱️ Test "$testName" started at $_startTime');
  }

  /// Call this at the end of the test.
  void stop() {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime);
    // For testing code, use print() instead of logger for simplicity, speed,
    // and console output:
    print('✅ Test "$testName" finished at $endTime, duration: ${duration
        .inMilliseconds} ms');
  }
}
