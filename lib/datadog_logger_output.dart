import 'package:datadog_logger/utils.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'datadog_dio.dart';
import 'datadog_logger_config.dart';

class DatadogLoggerOutput extends LogOutput {
  final DatadogLoggerConfig config;

  DatadogLoggerOutput({required this.config});

  @override
  Future<void> output(OutputEvent event) async {
    // ignore: avoid_print
    event.lines.forEach(print);
    var logger = Logger();
    try {
      final Dio dio = DatadogDio.getInstance(config);
      await dio.post(
        '/api/v2/logs',
        data: {
          'ddtags': config.ddTags,
          'ddsource': config.ddSource,
          'hostname': config.hostname,
          'service': config.service,
          'message':
              '${getFormattedDateNow()} ${event.origin.level} ${event.origin.message}',
        },
      );
    } catch (e) {
      logger.e('Error sending log to Datadog: $e');
    }
  }
}
