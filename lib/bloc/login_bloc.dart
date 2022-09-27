import 'package:rxdart/rxdart.dart';
import '../models/global_model.dart';

class LoginBloc {
  final _id = BehaviorSubject<String>();
  final _pw = BehaviorSubject<String>();

  final _appBarHeight = BehaviorSubject<double>.seeded(appHeight * 0.24);
  late double _minAppBarHeight = appHeight * 0.12;
  late double _maxAppBarHeight = appHeight * 0.24;

  final _idButton = BehaviorSubject<bool>();
  final _pwButton = BehaviorSubject<bool>();
  final _loginButton = BehaviorSubject<bool>.seeded(false);
  final _indicator = BehaviorSubject<bool>();

  Stream<String> get id => _id.stream;
  Stream<String> get pw => _pw.stream;
  Function(String) get updateId => _id.sink.add;
  Function(String) get updatePw => _pw.sink.add;

  Stream<double> get appBarHeight => _appBarHeight.stream;
  Function(double) get changeAppBarHeight => _appBarHeight.sink.add;
  set setMinAppBarHeight(double height) => _minAppBarHeight = height;
  set setMaxAppBarHeight(double height) => _maxAppBarHeight = height;
  double get maxAppBarHeight => _maxAppBarHeight;
  double get minAppBarHeight => _minAppBarHeight;

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
