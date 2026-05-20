/// 앱 라우트 정의
enum AppRoute {
  splash('/'),
  login('/login'),
  signupTerms('/signup/terms'),
  signupProfile('/signup/profile'),
  signupPrograms('/signup/programs'),
  signupInvite('/signup/invite'),
  signupComplete('/signup/complete'),
  findId('/account/find-id'),
  resetPassword('/account/reset-password'),
  home('/home'),
  ranking('/ranking'),
  rankingGrowth('/ranking/growth'),
  community('/community'),
  benefits('/benefits'),
  my('/my'),
  communityPost('/community/post/:id'),
  communityCompose('/community/compose'),
  communityMissionSuggest('/community/mission-suggest'),
  communityReport('/community/report'),
  userMissionCreate('/community/user-missions/create'),
  userMissionDetail('/community/user-missions/:id'),
  storyDetail('/story/:id'),
  missionDetail('/mission/:id'),
  missionResult('/mission/:id/result'),
  missionShare('/mission/:id/share'),
  notifications('/notifications');

  const AppRoute(this.path);

  final String path;

  static String storyDetailPath(String id) => '/story/$id';

  static String missionDetailPath(String id) => '/mission/$id';

  static String missionResultPath(String id) => '/mission/$id/result';

  static String missionSharePath(String id) => '/mission/$id/share';

  static String communityPostPath(String id) => '/community/post/$id';

  static String communityComposePath({String? editPostId}) {
    if (editPostId == null) {
      return communityCompose.path;
    }
    return '${communityCompose.path}?editId=$editPostId';
  }

  static String communityReportPath({
    required String targetType,
    required String targetId,
  }) =>
      '${communityReport.path}?targetType=$targetType&targetId=$targetId';

  static String userMissionDetailPath(String id) =>
      '/community/user-missions/$id';
}
