import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String prefsKeyIsUserLoggedin = "Pref_Key_Is_User_Loggedin";
const String userEmail = "User_Email";

class AppPreferences {
  final SharedPreferences _preferences;
  String? _email;
  String? get email {
    return _email;
  }

  AppPreferences(
    this._preferences,
  );

  Future<void> setUserLoggedin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _preferences.setString(userEmail, user.email!);
        _preferences.setBool(prefsKeyIsUserLoggedin, true);
      }
    });
  }

  bool isUserLoggedin() {
    _email = _preferences.getString(userEmail) ?? "";
    return _preferences.getBool(prefsKeyIsUserLoggedin) ?? false;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _preferences.remove(prefsKeyIsUserLoggedin);
  }
}
