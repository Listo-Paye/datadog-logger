import 'package:dio/dio.dart';

import 'datadog_logger_config.dart';

class DatadogDio {
  static Dio? _instance;
  static DatadogLoggerConfig? _config;

  DatadogDio._();

  static Dio getInstance(DatadogLoggerConfig config) {
    if (_instance == null || _config != config) {
      _config = config;
      _instance = Dio(BaseOptions(baseUrl: config.datadogEndpoint, headers: {
        'DD-API-KEY': config.datadogApiKey,
        'DD-APPLICATION-KEY': config.datadogAppKey,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }));
    }
    return _instance!;
  }
}
