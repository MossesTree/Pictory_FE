import 'package:picktory/models/ranking_feed.dart';
import 'package:picktory/models/ranking_growth_record.dart';
import 'package:picktory/models/ranking_profile_preview.dart';

abstract class RankingRepository {
  Future<RankingFeed> fetchRanking({
    required RankingMainTab tab,
    required String periodId,
    int page = 0,
  });

  Future<RankingProfilePreview> fetchProfilePreview({
    required String userId,
    required RankingMainTab tab,
    required String periodId,
  });

  Future<RankingGrowthRecord> fetchGrowthRecord();
}
