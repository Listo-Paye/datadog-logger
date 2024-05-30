library datadog_logger;

import 'package:logger/logger.dart';

import 'datadog_logger_config.dart';
import 'datadog_logger_output.dart';

class DDLogger extends Logger {
  final DatadogLoggerConfig config;

  DDLogger(this.config)
      : super(
            printer: PrettyPrinter(),
            // level: config.isProduction ? Level.error : Level.debug,
            output: DatadogLoggerOutput(config: config));
}
