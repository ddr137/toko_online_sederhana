import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClient {
  const SharedPreferencesClient();

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  Future<String> getString(String key, {String defaultValue = ''}) async {
    final p = await _prefs;
    return p.getString(key) ?? defaultValue;
  }

  Future<int?> getInt(String key, {int? defaultValue}) async {
    final p = await _prefs;
    return p.getInt(key) ?? defaultValue;
  }

  Future<double> getDouble(String key, {double defaultValue = 0.0}) async {
    final p = await _prefs;
    return p.getDouble(key) ?? defaultValue;
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final p = await _prefs;
    return p.getBool(key) ?? defaultValue;
  }

  Future<List<String>> getStringList(
    String key, {
    List<String> defaultValue = const [],
  }) async {
    final p = await _prefs;
    return p.getStringList(key) ?? defaultValue;
  }

  Future<void> setString(String key, String value) async {
    final p = await _prefs;
    await p.setString(key, value);
  }

  Future<void> setInt(String key, int value) async {
    final p = await _prefs;
    await p.setInt(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    final p = await _prefs;
    await p.setDouble(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    final p = await _prefs;
    await p.setBool(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    final p = await _prefs;
    await p.setStringList(key, value);
  }

  Future<void> remove(String key) async {
    final p = await _prefs;
    await p.remove(key);
  }

  Future<void> clear() async {
    final p = await _prefs;
    await p.clear();
  }

  Future<bool> containsKey(String key) async {
    final p = await _prefs;
    return p.containsKey(key);
  }

  Future<void> reload() async {
    final p = await _prefs;
    await p.reload();
  }
}
