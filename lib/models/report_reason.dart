enum ReportTargetType { post, comment, userMission }

enum ReportReason {
  spam('스팸/광고'),
  abuse('욕설/비방'),
  inappropriate('부적절한 내용'),
  falseInfo('허위 정보'),
  other('기타');

  const ReportReason(this.label);

  final String label;
}
