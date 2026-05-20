import 'package:picktory/models/ad_banner.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/models/mission_result.dart';

class HomeFeed {
  const HomeFeed({
    required this.nickname,
    required this.points,
    required this.hasUnreadNotifications,
    required this.adBanners,
    required this.heroMissions,
    required this.activeMissions,
    required this.results,
    required this.hasInterestPrograms,
    this.categories = const ['전체', '드라마', '예능', '영화', '스포츠'],
    this.inlineAdTitle,
  });

  final String nickname;
  final int points;
  final bool hasUnreadNotifications;
  final List<AdBanner> adBanners;
  final List<Mission> heroMissions;
  final List<Mission> activeMissions;
  final List<MissionResult> results;
  final bool hasInterestPrograms;
  final List<String> categories;
  final String? inlineAdTitle;

  static const empty = HomeFeed(
    nickname: '게스트',
    points: 0,
    hasUnreadNotifications: false,
    adBanners: [],
    heroMissions: [],
    activeMissions: [],
    results: [],
    hasInterestPrograms: false,
    categories: ['전체', '드라마', '예능', '영화', '스포츠'],
  );
}
