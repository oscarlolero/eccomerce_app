import 'dart:async';

import 'package:form_validation/src/bloc/validators.dart';

class LoginBloc with Validators {
  final _emailController    = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();

  //Recuperar los datos del stream
  Stream<String> get emailStream     => _emailController.stream.transform(emailValidation);
  //se agrega el with Validators y el transform para hacer validacion de contrasena
  Stream<String> get passwordStream  => _passwordController.stream.transform(passwordValidation);

  // Insertar valores al stream, funcion que solo recibe strings
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}