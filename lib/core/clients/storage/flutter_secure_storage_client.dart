import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageClient {
  final FlutterSecureStorage _ss;

  SecureStorageClient({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
  }) : _ss = FlutterSecureStorage(
         iOptions:
             iOptions ??
             const IOSOptions(
               accessibility: KeychainAccessibility.first_unlock_this_device,
             ),
         aOptions:
             aOptions ?? const AndroidOptions(encryptedSharedPreferences: true),
         lOptions: lOptions ?? const LinuxOptions(),
         wOptions: wOptions ?? const WindowsOptions(),
         webOptions: webOptions ?? const WebOptions(),
         mOptions: mOptions ?? const MacOsOptions(),
       );

  Future<String> getString(String key, {String defaultValue = ''}) async {
    final v = await _ss.read(key: key);
    return v ?? defaultValue;
  }

  Future<int> getInt(String key, {int defaultValue = 0}) async {
    final v = await _ss.read(key: key);
    return v == null ? defaultValue : int.tryParse(v) ?? defaultValue;
  }

  Future<double> getDouble(String key, {double defaultValue = 0.0}) async {
    final v = await _ss.read(key: key);
    return v == null ? defaultValue : double.tryParse(v) ?? defaultValue;
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final v = await _ss.read(key: key);
    if (v == null) return defaultValue;
    if (v == 'true') return true;
    if (v == 'false') return false;
    return defaultValue;
  }

  Future<List<String>> getStringList(
    String key, {
    List<String> defaultValue = const [],
  }) async {
    final v = await _ss.read(key: key);
    if (v == null) return defaultValue;
    try {
      final decoded = jsonDecode(v);
      if (decoded is List && decoded.every((e) => e is String)) {
        return List<String>.from(decoded);
      }
      return defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  Future<Map<String, dynamic>> getJson(
    String key, {
    Map<String, dynamic> defaultValue = const {},
  }) async {
    final v = await _ss.read(key: key);
    if (v == null) return defaultValue;
    try {
      final decoded = jsonDecode(v);
      return decoded is Map<String, dynamic> ? decoded : defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  Future<void> setString(String key, String value) async {
    await _ss.write(key: key, value: value);
  }

  Future<void> setInt(String key, int value) async {
    await _ss.write(key: key, value: value.toString());
  }

  Future<void> setDouble(String key, double value) async {
    await _ss.write(key: key, value: value.toString());
  }

  Future<void> setBool(String key, bool value) async {
    await _ss.write(key: key, value: value.toString());
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _ss.write(key: key, value: jsonEncode(value));
  }

  Future<void> setJson(String key, Map<String, dynamic> value) async {
    await _ss.write(key: key, value: jsonEncode(value));
  }

  Future<void> remove(String key) async => _ss.delete(key: key);
  Future<void> clear() async => _ss.deleteAll();

  Future<bool> containsKey(String key) async {
    final all = await _ss.readAll();
    return all.containsKey(key);
  }

  Future<Map<String, String>> readAll() => _ss.readAll();
}

