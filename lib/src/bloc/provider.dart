import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget {

  //Para mantener los datos al hacer hotreload
  static Provider _instance;

  factory Provider({Key key, Widget child}) {
    if(_instance == null) {
      _instance = new Provider._internal(key: key, child: child);
    }
    return _instance;
  }

  Provider._internal({Key key, Widget child})
    : super(key: key, child: child);

  final loginBloc = LoginBloc();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context) {
    //buscar la instancia de loginbloc en el arbol de widgets
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
}