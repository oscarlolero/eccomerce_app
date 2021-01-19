import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  //esto es para que cada vez que se llame el new, siempre sera la misma instancia
  static final UserPreferences _instace = new UserPreferences._internal();
  factory UserPreferences() {
    return _instace;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();

  }

  //GET y SET del genero
  get token {
    //si no existe, por defecto sera 1
    return _prefs.getString('token') ?? '';
  }

  set token(String token) {
    _prefs.setString('token', token);
  }
}