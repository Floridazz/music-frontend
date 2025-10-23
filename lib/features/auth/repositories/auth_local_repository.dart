import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  // This is used to store something locally on mobiles, in this case is JWT token
  late SharedPreferences _sharedPreferences;
  Future<void> init() async {
    // This is a static async method provided by the shared_preferences package
    // What it does:
    // Opens (or creates) a small on-device storage file used for key–value pairs.
    // Loads its contents into memory.
    // Returns a SharedPreferences object that lets you call .setString(), .getString(), etc.
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void setToken(String? token) {
    if (token != null) {
      //setString receive 2 params, one is key which is what type of data we are storing, the other is the value
      _sharedPreferences.setString('x-auth-token', token);
    }
  }

  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }
}
