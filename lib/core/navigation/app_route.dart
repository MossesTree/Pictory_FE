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
  community('/community'),
  storyDetail('/story/:id');

  const AppRoute(this.path);

  final String path;

  static String storyDetailPath(String id) => '/story/$id';
}
