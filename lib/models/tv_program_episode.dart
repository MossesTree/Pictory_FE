/// TV 프로그램 회차
class TvProgramEpisode {
  const TvProgramEpisode({
    required this.id,
    required this.programId,
    required this.label,
    this.airedAt,
  });

  /// 회차 고유 ID
  final String id;

  /// 부모 프로그램 ID
  final String programId;

  /// "5화", "10회", "1라운드" 등 표시 텍스트
  final String label;

  /// 방영일 (선택)
  final DateTime? airedAt;
}
