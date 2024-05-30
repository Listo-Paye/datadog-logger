import 'package:datadog_logger/datadog_dio.dart';
import 'package:datadog_logger/datadog_logger.dart';
import 'package:datadog_logger/datadog_logger_config.dart';
import 'package:datadog_logger/datadog_logger_output.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:logger/logger.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  Response<dynamic> response;

  final loggerConfig = DatadogLoggerConfig(
      datadogApiKey: 'api-key',
      datadogAppKey: 'app-key',
      datadogEndpoint: 'http://datadog-endpoint/',
      ddTags: 'env:dev',
      ddSource: 'flutter',
      hostname: 'flutter',
      service: 'listo-app');

  setUp(() {
    dio = DatadogDio.getInstance(loggerConfig);
    dioAdapter = DioAdapter(
        dio: dio, matcher: const FullHttpRequestMatcher(needsExactBody: true));
  });

  group('Basic', () {
    test('should return a response with 200 status code', () async {
      const route = '/';

      dioAdapter.onGet(
        route,
        (server) => server.reply(200, null),
      );

      response = await dio.get(route);

      expect(response.statusCode, 200);
    });

    // Test body
    test('should return a response with 201 created status code', () async {
      const route = '/post-test';
      const exampleData = {'test': 'value'};

      dioAdapter.onPost(
        route,
        (server) => server.reply(201, null),
        data: exampleData,
      );

      response = await dio.post(route, data: exampleData);

      expect(response.statusCode, 201);
    });
  });

  group('Custom logger initialization', () {
    test('should create logger with provided config', () {
      final customLogger = DDLogger(loggerConfig);
      expect(customLogger.config.datadogApiKey, 'api-key');
      expect(customLogger.config.datadogAppKey, 'app-key');
      expect(customLogger.config.datadogEndpoint, 'http://datadog-endpoint/');
      expect(customLogger.config.ddTags, 'env:dev');
      expect(customLogger.config.ddSource, 'flutter');
      expect(customLogger.config.hostname, 'flutter');
      expect(customLogger.config.service, 'listo-app');
    });
  });

  group('logger call datadog', () {
    const logsRoute = '/api/v2/logs';
    final customOutput = DatadogLoggerOutput(config: loggerConfig);

    test('if logger send appropriate data and headers', () async {
      dioAdapter.onPost(
        logsRoute,
        (server) => server.reply(202, {}),
        data: {
          'ddtags': 'env:dev',
          'ddsource': 'flutter',
          'hostname': 'flutter',
          'service': 'listo-app',
          'message': 'test message',
        },
        headers: {
          'Content-Type': 'application/json',
          'DD-API-KEY': 'api-key',
          'DD-APPLICATION-KEY': 'app-key',
        },
      );

      await customOutput.output(
          OutputEvent(LogEvent(Level.debug, 'test message'), ['test message']));
    });
  });
}
