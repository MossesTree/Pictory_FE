import 'package:picktory/models/ranking_entry.dart';
import 'package:picktory/models/ranking_my_summary.dart';
import 'package:picktory/models/ranking_period.dart';

/// 랭킹 탭 종류 (시즌 → 커뮤니티 → 전체)
enum RankingMainTab {
  season,
  community,
  overall;

  String get label => switch (this) {
        RankingMainTab.season => '시즌',
        RankingMainTab.community => '커뮤니티',
        RankingMainTab.overall => '전체',
      };

  bool get isMissionBased =>
      this == RankingMainTab.season || this == RankingMainTab.overall;
}

/// 랭킹 피드 응답
class RankingFeed {
  const RankingFeed({
    required this.podium,
    required this.entries,
    required this.mySummary,
    required this.periodOptions,
    required this.selectedPeriodId,
    required this.hasMore,
    this.infoBannerMessage,
    this.useCommunityTitles = false,
  });

  final List<RankingPodiumEntry> podium;
  final List<RankingEntry> entries;
  final RankingMySummary mySummary;
  final List<RankingPeriodOption> periodOptions;
  final String selectedPeriodId;
  final bool hasMore;
  final String? infoBannerMessage;
  final bool useCommunityTitles;
}
