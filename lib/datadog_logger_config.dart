class DatadogLoggerConfig {
  final String datadogApiKey;
  final String datadogAppKey;
  final String datadogEndpoint;
  final String ddTags;
  final String ddSource;
  final String hostname;
  final String service;

  DatadogLoggerConfig({
    required this.datadogApiKey,
    required this.datadogAppKey,
    required this.datadogEndpoint,
    required this.ddTags,
    required this.ddSource,
    required this.hostname,
    required this.service,
  });
}
