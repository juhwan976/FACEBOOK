import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final _id = BehaviorSubject<String>();
  final _pw = BehaviorSubject<String>();

  final _appBarHeight = BehaviorSubject<double>();
  late double _minAppBarHeight = 0;
  late double _maxAppBarHeight = 0;

  final _idButton = BehaviorSubject<bool>();
  final _pwButton = BehaviorSubject<bool>();
  final _loginButton = BehaviorSubject<bool>();
  final _indicator = BehaviorSubject<bool>();

  Stream<String> get id => _id.stream;
  Stream<String> get pw => _pw.stream;
  Function(String) get updateId => _id.sink.add;
  Function(String) get updatePw => _pw.sink.add;

  Stream<double> get appBarHeight => _appBarHeight.stream;
  Function(double) get changeAppBarHeight => _appBarHeight.sink.add;
  set setMinAppBarHeight(double height) => _minAppBarHeight = height;
  set setMaxAppBarHeight(double height) => _maxAppBarHeight = height;

  Stream<bool> get idButton => _idButton.stream;
  Stream<bool> get pwButton => _pwButton.stream;
  Stream<bool> get loginButton => _loginButton.stream;
  Stream<bool> get indicator => _indicator.stream;
  Function(bool) get updateIdButton => _idButton.sink.add;
  Function(bool) get updatePwButton => _pwButton.sink.add;
  Function(bool) get updateLoginButton => _loginButton.sink.add;
  Function(bool) get updateIndicator => _indicator.sink.add;

  void setAppBarHeightMax() {
    _appBarHeight.sink.add(_maxAppBarHeight);
  }

  void setAppBarHeightMin() {
    _appBarHeight.sink.add(_minAppBarHeight);
  }

  void onUnfocus() {
    _appBarHeight.sink.add(_maxAppBarHeight);
    _idButton.sink.add(false);
    _pwButton.sink.add(false);
    toggleLoginButton();
  }

  void toggleLoginButton() {
    if(_id.hasValue && _pw.hasValue) {
      if (_id.stream.value.isNotEmpty && _pw.stream.value.isNotEmpty) {
        updateLoginButton(true);
      } else {
        updateLoginButton(false);
      }
    }
  }

  void toggleIdButton() {
    if(_id.stream.value.isEmpty) {
      updateIdButton(false);
    }
    else {
      updateIdButton(true);
    }
  }

  void togglePwButton() {
    if(_pw.stream.value.isEmpty) {
      updatePwButton(false);
    }
    else {
      updatePwButton(true);
    }
  }

  dispose() {
    _id.close();
    _pw.close();

    _appBarHeight.close();

    _idButton.close();
    _pwButton.close();
    _loginButton.close();
    _indicator.close();
  }
}
