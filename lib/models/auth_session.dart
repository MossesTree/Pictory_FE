/// IA O-2 / S-1 소셜 로그인 제공자
enum SocialProvider {
  kakao,
  google,
  apple;

  String get displayLabel => switch (this) {
        SocialProvider.kakao => '카카오',
        SocialProvider.google => '구글',
        SocialProvider.apple => '애플',
      };
}

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.isOnboardingCompleted,
    this.socialProvider,
  });

  final String accessToken;
  final bool isOnboardingCompleted;

  /// IA S-1 환경설정 - 연결 계정 표시용
  final SocialProvider? socialProvider;

  bool get isValid => accessToken.isNotEmpty;
}
