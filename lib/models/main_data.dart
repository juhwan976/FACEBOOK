class NavigationData {
  final String activeImage;
  final String inActiveImage;
  final String label;

  NavigationData(
      {required this.activeImage,
      required this.inActiveImage,
      required this.label});
}

final List<NavigationData> navigationData = [
  NavigationData(
    activeImage: 'assets/bottomNavigationBar/home_active.png',
    inActiveImage: 'assets/bottomNavigationBar/home_inactive.png',
    label: '홈',
  ),
  NavigationData(
    activeImage: 'assets/bottomNavigationBar/watch_active.png',
    inActiveImage: 'assets/bottomNavigationBar/watch_inactive.png',
    label: 'Watch',
  ),
  NavigationData(
    activeImage: 'assets/bottomNavigationBar/profile_active.png',
    inActiveImage: 'assets/bottomNavigationBar/profile_inactive.png',
    label: '프로필',
  ),
  NavigationData(
    activeImage: 'assets/bottomNavigationBar/peed_temp_active.png',
    inActiveImage: 'assets/bottomNavigationBar/peed_temp_inactive.png',
    label: '피드',
  ),
  NavigationData(
    activeImage: 'assets/bottomNavigationBar/alarm_active.png',
    inActiveImage: 'assets/bottomNavigationBar/alarm_inactive.png',
    label: '알림',
  ),
  NavigationData(
    activeImage: 'assets/bottomNavigationBar/menu_active.png',
    inActiveImage: 'assets/bottomNavigationBar/menu_inactive.png',
    label: '메뉴',
  ),
];
