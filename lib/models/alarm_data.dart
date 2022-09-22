// ignore_for_file: file_names
/// ****************************************************************************
///
///
///*****************************************************************************

class AlarmData {
  final String user;
  final UserType userType;
  final String uid;
  final PostType postType;
  final String content;
  final String? video;
  final List<String>? images;
  final int timeStamp;
  bool isRead;

  AlarmData({
    required this.user,
    required this.userType,
    required this.uid,
    required this.postType,
    required this.content,
    this.video,
    this.images,
    required this.timeStamp,
    required this.isRead,
  });
      /*: assert(postType == PostType.video && video == null,
            'PostType is video, but video is null'),
        assert(postType == PostType.image && images == null,
            'PostType is image, but images is null');

       */
}

enum UserType {
  individualPerson,
  groupPerson,
  individualPage,
  groupPage,
}

enum PostType {
  video,
  image,
  onlyText,
}

final List<AlarmData> alarms = [
  AlarmData(
    user: 'NVIDIA GeForce Korea',
    userType: UserType.groupPage,
    uid: 'eidlsfkdf',
    postType: PostType.video,
    content: 'Portal RTX',
    video: '131313',
    timeStamp: 1663725600 * 1000,
    isRead: false,
  ),
  AlarmData(
    user: 'Hardwell',
    userType: UserType.groupPerson,
    uid: 'asdfqwer',
    postType: PostType.video,
    content:
        'Can\'t wait to be back in NYC again next week. Grab your tickets ..',
    video: '121212',
    timeStamp: 1662897600 * 1000,
    isRead: false,
  ),
  AlarmData(
    user: 'NVIDIA GeForce Korea',
    userType: UserType.groupPage,
    uid: 'eidlsfkdf',
    postType: PostType.video,
    content: '<더 위쳐3> - 게임 플레이',
    video: '131314',
    timeStamp: 1662120000 * 1000,
    isRead: false,
  ),
  AlarmData(
    user: 'NVIDIA GeForce Korea',
    userType: UserType.groupPage,
    uid: 'eidlsfkdf',
    postType: PostType.video,
    content: 'GeForce Garage - Hydropower PC',
    video: '131315',
    timeStamp: 1661994000 * 1000,
    isRead: false,
  ),
  AlarmData(
    user: 'NVIDIA GeForce Korea',
    userType: UserType.groupPage,
    uid: 'eidlsfkdf',
    postType: PostType.video,
    content: 'GeForce Garage - Hydropower PC',
    video: '131315',
    timeStamp: 1661994000 * 1000,
    isRead: false,
  ),
  AlarmData(
    user: 'NVIDIA GeForce Korea',
    userType: UserType.groupPage,
    uid: 'eidlsfkdf',
    postType: PostType.video,
    content: 'GeForce Garage - Hydropower PC',
    video: '131315',
    timeStamp: 1661994000 * 1000,
    isRead: false,
  ),
];
