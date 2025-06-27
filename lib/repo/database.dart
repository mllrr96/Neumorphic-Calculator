import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class DatabaseRepository {
  DatabaseRepository(SharedPreferences sharedPreferences)
      : _preferences = sharedPreferences;
  final SharedPreferences _preferences;

  Future<bool> set<T>(String key, T value) async {
    try {
      switch (T) {
        case const (String):
          return await _preferences.setString(key, value as String);
        case const (List<String>):
          return await _preferences.setStringList(key, value as List<String>);
        case const (bool):
          return await _preferences.setBool(key, value as bool);
        case const (int):
          return await _preferences.setInt(key, value as int);
        default:
          throw UnsupportedError('Type $T is not supported');
      }
    } catch (_) {
      return false;
    }
  }

  T? get<T>(String key) {
    try {
      switch (T) {
        case const (String):
          return _preferences.getString(key) as T?;
        case const (List<String>):
          return _preferences.getStringList(key) as T?;
        case const (bool):
          return _preferences.getBool(key) as T?;
        case const (int):
          return _preferences.getInt(key) as T?;
        default:
          throw UnsupportedError('Type $T is not supported');
      }
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
