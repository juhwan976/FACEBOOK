import 'package:rxdart/rxdart.dart';

class NewAccountBloc {
  final _idButton = BehaviorSubject<bool>.seeded(false);
  final _pwButton = BehaviorSubject<bool>.seeded(false);
  final _nameButton = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get idButton => _idButton.stream;
  Stream<bool> get pwButton => _pwButton.stream;
  Stream<bool> get nameButton => _nameButton.stream;
  Function(bool) get updateIdButton => _idButton.sink.add;
  Function(bool) get updatePwButton => _pwButton.sink.add;
  Function(bool) get updateNameButton => _nameButton.sink.add;

  void setButtonFalse() {
    updateIdButton(false);
    updatePwButton(false);
    updateNameButton(false);
  }

  void dispose() {
    _idButton.close();
    _pwButton.close();
    _nameButton.close();
  }
}