class ApiConfig {
  ApiConfig._();

  static const String _defaultUrl = 'https://localhost:8443/login';

  static const String _url =
      String.fromEnvironment('API_URL', defaultValue: _defaultUrl);

  static const Duration timeout = Duration(seconds: 10);

  static Uri get loginUri => Uri.parse(_url);
}
