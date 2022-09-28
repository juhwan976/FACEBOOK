import 'package:rxdart/rxdart.dart';

import '../models/alarm_data.dart';

class MainBloc {
  final _index = BehaviorSubject<int>.seeded(0);
  final _delay = BehaviorSubject<int>.seeded(50);
  final _target = BehaviorSubject<int>.seeded(0);

  final _alarmToWatch = BehaviorSubject<bool>.seeded(false);
  final _data = BehaviorSubject<AlarmData>();

  final _duration =100;

  Stream<int> get index => _index.stream;
  Stream<int> get delay => _delay.stream;
  Stream<int> get target => _target.stream;
  Function(int) get updateIndex => _index.sink.add;
  Function(int) get updateDelay => _delay.sink.add;
  Function(int) get updateTarget => _target.sink.add;

  Stream<bool> get alarmToWatch => _alarmToWatch.stream;
  Function(bool) get updateAlarmToWatch => _alarmToWatch.sink.add;
  Stream<AlarmData> get data => _data.stream;
  Function(AlarmData) get updateData => _data.sink.add;
  AlarmData get currentData => _data.stream.value;

  int get currentIndex => _index.stream.value;
  int get currentDelay => _delay.stream.value;
  int get currentTarget => _target.stream.value;

  int calDelay(index) {
    if ((_duration / (index - (currentIndex)).abs()).isInfinite) {
      return _duration;
    }
    return (_duration / (index - (currentIndex)).abs()).round();
  }

  void animateIndicator(int index) async {
    if (index > (currentIndex)) {
      for (int i = (currentIndex) + 1; i <= index; i++) {
        updateIndex(i);
        await Future.delayed(Duration(milliseconds: currentDelay));
      }
    } else {
      for (int i = (currentIndex) - 1; i >= index; i--) {
        updateIndex(i);
        await Future.delayed(Duration(milliseconds: currentDelay));
      }
    }
  }

  dispose() {
    _index.close();
    _delay.close();
    _target.close();

    _alarmToWatch.close();
    _data.close();
  }
}
