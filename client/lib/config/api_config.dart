import 'package:flutter/foundation.dart';

class ApiConfig {
  ApiConfig._();

  static const String _overrideUrl = String.fromEnvironment('API_URL');

  static const int _localPort = 8000;

  static const Duration timeout = Duration(seconds: 10);

  static Uri get loginUri {
    if (_overrideUrl.isNotEmpty) return Uri.parse(_overrideUrl);

    final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : '127.0.0.1';
    return Uri.parse('http://$host:$_localPort/login_tst_local.php');
  }
}
