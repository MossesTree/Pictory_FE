import 'package:picktory/models/ranking_feed.dart';
import 'package:picktory/models/ranking_profile_preview.dart';
import 'package:picktory/services/dummy/dummy_ranking_data.dart';
import 'package:picktory/services/ranking_repository.dart';

class DummyRankingRepository implements RankingRepository {
  @override
  Future<RankingFeed> fetchRanking({
    required RankingMainTab tab,
    required String periodId,
    int page = 0,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    switch (tab) {
      case RankingMainTab.season:
        return RankingFeed(
          podium: DummyRankingData.seasonPodium(),
          entries: DummyRankingData.seasonEntriesPage(page),
          mySummary: DummyRankingData.seasonMySummary(),
          periodOptions: DummyRankingData.seasonPeriods,
          selectedPeriodId: periodId.isEmpty
              ? DummyRankingData.seasonPeriods.first.id
              : periodId,
          hasMore: page < 2,
        );
      case RankingMainTab.overall:
        return RankingFeed(
          podium: DummyRankingData.seasonPodium(),
          entries: DummyRankingData.seasonEntriesPage(page),
          mySummary: DummyRankingData.seasonMySummary().copyWith(
            topPercentTarget: 5,
            stepsToTopPercent: 15,
          ),
          periodOptions: DummyRankingData.overallPeriods,
          selectedPeriodId: periodId.isEmpty
              ? DummyRankingData.overallPeriods.first.id
              : periodId,
          hasMore: page < 2,
        );
      case RankingMainTab.community:
        return RankingFeed(
          podium: DummyRankingData.communityPodium(),
          entries: DummyRankingData.communityEntriesPage(page),
          mySummary: DummyRankingData.communityMySummary(),
          periodOptions: DummyRankingData.communityPeriods,
          selectedPeriodId: periodId.isEmpty
              ? DummyRankingData.communityPeriods.first.id
              : periodId,
          hasMore: page < 1,
          activityScoreFormula: DummyRankingData.activityScoreFormula,
        );
    }
  }

  @override
  Future<RankingProfilePreview> fetchProfilePreview({
    required String userId,
    required RankingMainTab tab,
    required String periodId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return DummyRankingData.profileFor(userId);
  }
}
