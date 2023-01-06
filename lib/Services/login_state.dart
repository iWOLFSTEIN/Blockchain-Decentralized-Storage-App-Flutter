import 'package:shared_preferences/shared_preferences.dart';

class LoginState {
  static getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    bool loginState = prefs.getBool('isLoggedIn') ?? false;
    return loginState;
  }

  static setLoginState({value}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', value);
  }
}
