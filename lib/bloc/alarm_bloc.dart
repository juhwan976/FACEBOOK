import 'dart:developer';

import 'package:rxdart/rxdart.dart';

import '../models/alarm_data.dart';

class AlarmBloc {
  final _scrollOffset = BehaviorSubject<double>();
  final _alarmLength = BehaviorSubject<int>();
  final _isEnd = BehaviorSubject<bool>();
  final _isReads = BehaviorSubject<List<bool>>();

  bool _isLoading = false;
  int _readMoreCount = 3;
  int _count = 0;
  List<bool> _temp = [];

  Stream<double> get scrollOffset => _scrollOffset.stream;
  Stream<int> get alarmLength => _alarmLength.stream;
  Stream<bool> get isEnd => _isEnd.stream;
  Stream<List<bool>> get isReads => _isReads.stream;
  Function(double) get updateScrollOffset => _scrollOffset.sink.add;
  Function(int) get updateAlarmLength => _alarmLength.sink.add;
  Function(bool) get updateIsEnd => _isEnd.sink.add;
  Function(List<bool>) get updateIsReads => _isReads.sink.add;

  bool get isLoading => _isLoading;
  int get readMoreCount => _readMoreCount;
  int get count => _count;

  List<bool> get temp => _temp;

  void setTemp(List<bool> list) {
    _temp = [...list];
  }

  void setTempElementAt(int index, bool value) {
    _temp[index] = value;
  }

  void clearTemp() {
    _temp = [];
  }

  List<bool> parseIsReadsToList(List<bool> temp) {

    for(int i = 0 ; i < alarms.length ; i++) {
      temp = [...temp, alarms.elementAt(i).isRead];
    }

    return temp;
  }

  Future refresh() async {
    await Future.delayed(const Duration(seconds: 2)).whenComplete(() {
      log('refresh done!');
    });
  }

  Future readMore() async {
    if (!_isLoading) {
      _isLoading = true;
      updateIsEnd(false);
      await Future.delayed(const Duration(seconds: 2)).whenComplete(
        () {
          log('loading done!');
          if (_readMoreCount-- > 0) {
            for (int i = 0; i < 5; i++) {
              alarms.add(
                AlarmData(
                  user: 'Test Tile ${_count++}',
                  userType: UserType.individualPerson,
                  uid: '1111111',
                  postType: PostType.onlyText,
                  content: 'Test',
                  timeStamp: 1661994000 * 1000,
                  isRead: false,
                ),
              );

              clearTemp();
              setTemp(parseIsReadsToList(_temp));
              updateIsReads(_temp);
            }
          } else {
            updateIsEnd(true);
          }
          updateAlarmLength(alarms.length);
          _isLoading = false;
        },
      );
    }
  }

  void init() {
    updateAlarmLength(alarms.length);
    updateIsEnd(false);

    clearTemp();
    setTemp(parseIsReadsToList(_temp));
    updateIsReads(_temp);
  }

  void dispose() {
    _scrollOffset.close();
    _alarmLength.close();
    _isEnd.close();
    _isReads.close();
    _temp.clear();
  }
}
