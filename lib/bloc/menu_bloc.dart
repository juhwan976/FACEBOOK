import 'package:rxdart/rxdart.dart';

class MenuBloc {
  final _scrollOffset = BehaviorSubject<double>();
  final _isShowingShortCut = BehaviorSubject<bool>();
  final _isShowingCommunityResource = BehaviorSubject<bool>();
  final _isShowingHelp = BehaviorSubject<bool>();

  Stream<double> get scrollOffset => _scrollOffset.stream;
  Stream<bool> get isShowingShortCut => _isShowingShortCut.stream;
  Stream<bool> get isShowingCommunityResource => _isShowingCommunityResource.stream;
  Stream<bool> get isShowingHelp => _isShowingHelp.stream;
  Function(double) get updateScrollOffset => _scrollOffset.sink.add;
  Function(bool) get updateIsShowingShortCut => _isShowingShortCut.sink.add;
  Function(bool) get updateIsShowingCommunityResource => _isShowingCommunityResource.sink.add;
  Function(bool) get updateIsShowingHelp => _isShowingHelp.sink.add;

  init() {
    updateIsShowingShortCut(false);
    updateIsShowingCommunityResource(false);
    updateIsShowingHelp(false);
  }

  dispose() {
    _scrollOffset.close();
    _isShowingShortCut.close();
    _isShowingCommunityResource.close();
    _isShowingHelp.close();
  }
}
