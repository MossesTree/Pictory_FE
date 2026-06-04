/// IA MY-2 내 픽 기록 필터
enum PickHistoryFilter {
  all,

  /// 정답 — 결과 발표 후 맞힌 미션
  correct,

  /// 오답 — 결과 발표 후 틀린 미션
  incorrect,

  /// 대기 — 결과 미공개
  pending,
}

/// IA MY-2 내 픽 기록 결과 상태
enum PickHistoryResult {
  correct,
  incorrect,
  pending,
}

class PickHistoryItem {
  const PickHistoryItem({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.points,
    required this.result,
    required this.missionId,
  });

  final String id;
  final String title;
  final String timeLabel;
  final int points;
  final PickHistoryResult result;

  /// 탭 시 이동할 미션 ID (IA: 미션 결과로 이동)
  final String missionId;
}
