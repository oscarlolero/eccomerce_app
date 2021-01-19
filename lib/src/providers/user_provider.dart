import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:form_validation/src/shared_preferences/user_preferences.dart';

class UserProvider {
  final String _firebaseToken = 'AIzaSyC5j6KtknYV5Ndy8FBW-l4dBgeyP5LGXcQ';
  final _prefs = new UserPreferences();

  Future login(String email, String password) async {

    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData)
    );

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse);

    if(decodedResponse.containsKey('idToken')) {

      _prefs.token = decodedResponse['idToken'];
      return {'ok': true, 'token': decodedResponse['idToken']};
    } else {
      return {'ok': false, 'message': decodedResponse['error']['message']};
    }
  }

  Future<Map<String, dynamic>> newUser(String email, String password) async {

    final String _firebaseToken = 'AIzaSyC5j6KtknYV5Ndy8FBW-l4dBgeyP5LGXcQ';

    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    print(decodedResponse);

    if(decodedResponse.containsKey('idToken')) {
      _prefs.token = decodedResponse['idToken'];
      return {'ok': true, 'token': decodedResponse['idToken']};
    } else {
      return {'ok': false, 'message': decodedResponse['error']['message']};
    }
  }
}