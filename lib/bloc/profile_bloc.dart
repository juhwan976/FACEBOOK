import 'dart:developer';

import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final _userName = BehaviorSubject<String>();

  Stream<String> get userName => _userName.stream;
  Function(String) get updateUserName => _userName.sink.add;

  Future refresh() async {
    await Future.delayed(const Duration(seconds: 2)).whenComplete(
      () {
        log('refresh done!');
      },
    );
  }

  init() {

  }

  dispose() {
    _userName.close();
  }
}
