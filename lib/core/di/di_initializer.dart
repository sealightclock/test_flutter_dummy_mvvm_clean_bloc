import '../../shared/di/di_config.dart';

/// Helper to initialize Dependency Injection configuration
/// based on environment, platform, or test context.
///
/// For now, hardcoded to Hive + Simulator.
/// In the future, can be driven by user config or test flags.
class DiInitializer {
  static void init() {
    // Default DI configuration
    DiConfig.useHiveAndSimulator();

    // TODO (future):
    // - Read from environment or platform
    // - Use debug/testing overrides
  }
}
