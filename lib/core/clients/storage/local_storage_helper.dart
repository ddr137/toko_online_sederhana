import 'dart:io';

import 'package:flutter/services.dart';

class LocalStorageHelper {
  static Future<T> safeStorage<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on PlatformException catch (e, st) {
      throw LocalStorageException(
        'Gagal mengakses storage: ${e.message ?? e.code}',
        cause: e,
        stackTrace: st,
      );
    } on FileSystemException catch (e, st) {
      throw LocalStorageException(
        'Gagal mengakses file: ${e.message}',
        cause: e,
        stackTrace: st,
      );
    } on FormatException catch (e, st) {
      throw LocalStorageException(
        'Format data tidak valid: ${e.message}',
        cause: e,
        stackTrace: st,
      );
    } catch (e, st) {
      throw LocalStorageException(e.toString(), cause: e, stackTrace: st);
    }
  }
}

class LocalStorageException implements Exception {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  LocalStorageException(this.message, {this.cause, this.stackTrace});

  @override
  String toString() => 'LocalStorageException: $message';
}
