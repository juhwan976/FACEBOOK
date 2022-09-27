import 'package:rxdart/rxdart.dart';

class MenuBloc {
  final _scrollOffset = BehaviorSubject<double>();
  final _isShowingShortCut = BehaviorSubject<bool>.seeded(false);
  final _isShowingCommunityResource = BehaviorSubject<bool>.seeded(false);
  final _isShowingHelp = BehaviorSubject<bool>.seeded(false);

  Stream<double> get scrollOffset => _scrollOffset.stream;
  Stream<bool> get isShowingShortCut => _isShowingShortCut.stream;
  Stream<bool> get isShowingCommunityResource => _isShowingCommunityResource.stream;
  Stream<bool> get isShowingHelp => _isShowingHelp.stream;
  Function(double) get updateScrollOffset => _scrollOffset.sink.add;
  Function(bool) get updateIsShowingShortCut => _isShowingShortCut.sink.add;
  Function(bool) get updateIsShowingCommunityResource => _isShowingCommunityResource.sink.add;
  Function(bool) get updateIsShowingHelp => _isShowingHelp.sink.add;

  double calCRScrollOffset() {
    if(_isShowingShortCut.stream.value && _isShowingHelp.stream.value) {
      return 667;
    }

    if (_isShowingShortCut.stream.value) {
      return 562;
    }

    if (_isShowingHelp.stream.value) {
      return 500;
    }

    return 397;
  }

  double calHelpScrollOffset() {
    if (_isShowingShortCut.stream.value && _isShowingCommunityResource.stream.value) {
      return 915;
    }

    if (_isShowingShortCut.stream.value) {
      return 677;
    }

    if (_isShowingCommunityResource.stream.value) {
      return 750;
    }

    return 512;
  }

  init() {

  }

  dispose() {
    _scrollOffset.close();
    _isShowingShortCut.close();
    _isShowingCommunityResource.close();
    _isShowingHelp.close();
  }
}
