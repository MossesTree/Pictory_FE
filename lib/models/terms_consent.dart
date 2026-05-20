class TermsConsent {
  const TermsConsent({
    this.isOver14 = false,
    this.agreedToTerms = false,
    this.agreedToPrivacy = false,
    this.agreedToMarketing = false,
    this.agreedToNightPush = false,
  });

  final bool isOver14;
  final bool agreedToTerms;
  final bool agreedToPrivacy;
  final bool agreedToMarketing;
  final bool agreedToNightPush;

  bool get requiredAgreed =>
      isOver14 && agreedToTerms && agreedToPrivacy;

  bool get allAgreed =>
      isOver14 &&
      agreedToTerms &&
      agreedToPrivacy &&
      agreedToMarketing &&
      agreedToNightPush;

  TermsConsent copyWith({
    bool? isOver14,
    bool? agreedToTerms,
    bool? agreedToPrivacy,
    bool? agreedToMarketing,
    bool? agreedToNightPush,
  }) {
    return TermsConsent(
      isOver14: isOver14 ?? this.isOver14,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      agreedToPrivacy: agreedToPrivacy ?? this.agreedToPrivacy,
      agreedToMarketing: agreedToMarketing ?? this.agreedToMarketing,
      agreedToNightPush: agreedToNightPush ?? this.agreedToNightPush,
    );
  }
}
