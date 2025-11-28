import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

extension LogExtension on Object {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: _supportsAnsiOutput(),
      printEmojis: true,
    ),
  );

  static bool _supportsAnsiOutput() {
    return !kDebugMode;
  }

  void logInfo() => _logger.i(this);
  void logWarning() => _logger.w(this);
  void logError() => _logger.e(this);
  void logFatalError([StackTrace? stackTrace]) =>
      _logger.f(this, stackTrace: stackTrace);
}

