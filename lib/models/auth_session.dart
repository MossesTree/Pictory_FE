class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.isOnboardingCompleted,
  });

  final String accessToken;
  final bool isOnboardingCompleted;

  bool get isValid => accessToken.isNotEmpty;
}
