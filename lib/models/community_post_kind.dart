/// IA C-5 글 종류 (스레드 / 유저미션 / 유저투표)
enum CommunityPostKind {
  /// 일반 스레드 글 (제목 + 내용)
  thread,

  /// 유저 미션 (선택지 + 마감 시간 필수)
  userMission,

  /// 유저 투표 (선택지, 마감일 없음 — 즉시 결과 공개)
  userPoll;

  String get label => switch (this) {
        CommunityPostKind.thread => '스레드',
        CommunityPostKind.userMission => '유저미션',
        CommunityPostKind.userPoll => '유저투표',
      };

  bool get isThread => this == CommunityPostKind.thread;
  bool get isUserMission => this == CommunityPostKind.userMission;
  bool get isUserPoll => this == CommunityPostKind.userPoll;
  bool get hasChoices => isUserMission || isUserPoll;
  bool get needsDeadline => isUserMission;
}
