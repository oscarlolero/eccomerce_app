import 'dart:convert';

import 'package:http/http.dart' as http;
class UserProvider {

  Future login(String email, String password) async {
    final String _firebaseToken = 'AIzaSyC5j6KtknYV5Ndy8FBW-l4dBgeyP5LGXcQ';

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
      //todo: guardar token en storage
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
      //todo: guardar token en storage
      return {'ok': true, 'token': decodedResponse['idToken']};
    } else {
      return {'ok': false, 'message': decodedResponse['error']['message']};
    }
  }
}