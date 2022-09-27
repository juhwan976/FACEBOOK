import 'package:rxdart/rxdart.dart';

class MainBloc {
  late final BehaviorSubject<int> _index;
  late final BehaviorSubject<int> _delay;
  late final BehaviorSubject<int> _target;

  final _duration =100;

  MainBloc({
    required int initialIndex,
    required initialDelay,
    required initialTarget,
  }) {
    _index = BehaviorSubject<int>.seeded(initialIndex);
    _delay = BehaviorSubject<int>.seeded(initialDelay);
    _target = BehaviorSubject<int>.seeded(initialTarget);
  }

  Stream<int> get index => _index.stream;

  Stream<int> get delay => _delay.stream;

  Stream<int> get target => _target.stream;

  Function(int) get updateIndex => _index.sink.add;

  Function(int) get updateDelay => _delay.sink.add;

  Function(int) get updateTarget => _target.sink.add;

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
  }
}
