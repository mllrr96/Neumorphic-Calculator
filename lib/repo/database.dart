import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class Database {
  Database(SharedPreferences sharedPreferences)
      : _preferences = sharedPreferences;
  final SharedPreferences _preferences;

  Future<bool> setString(String key, String value) async {
    try {
      return await _preferences.setString(key, value);
    } catch (_) {
      return false;
    }
  }

  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _preferences.setStringList(key, value);
    } catch (_) {
      return false;
    }
  }

  Future<bool> setBool(String key, bool value) async {
    try {
      return await _preferences.setBool(key, value);
    } catch (_) {
      return false;
    }
  }

  bool? getBool(String key) {
    try {
      return _preferences.getBool(key);
    } catch (_) {
      return null;
    }
  }

  String? getString(String key) {
    try {
      return _preferences.getString(key);
    } catch (_) {
      return null;
    }
  }

  List<String>? getStringList(String key) {
    try {
      return _preferences.getStringList(key);
    } catch (_) {
      return null;
    }
  }

  Future<bool> remove(String key) async {
    try {
      return await _preferences.remove(key);
    } catch (_) {
      return false;
    }
  }
}
