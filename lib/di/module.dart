import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> prefs() async =>
      await SharedPreferences.getInstance();
}
