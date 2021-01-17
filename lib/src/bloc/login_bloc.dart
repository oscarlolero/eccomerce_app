import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:form_validation/src/bloc/validators.dart';

class LoginBloc with Validators {
  //el comportamiento por default de un BehaviorSubject es broadcast, esto es para poder usar rxdart
  final _emailController    = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recuperar los datos del stream
  Stream<String> get emailStream     => _emailController.stream.transform(emailValidation);
  //se agrega el with Validators y el transform para hacer validacion de contrasena
  Stream<String> get passwordStream  => _passwordController.stream.transform(passwordValidation);

  //se pasa emailStream y passwordStream ya pasados por el transform()
  Stream<bool> get formValidStream =>
    Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);  //si no se cumple regresa un null

  // Insertar valores al stream, funcion que solo recibe strings
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //obtener el ultimo valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}