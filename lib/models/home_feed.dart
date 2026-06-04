import 'package:picktory/models/ad_banner.dart';
import 'package:picktory/models/home_program_item.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/models/mission_result.dart';
import 'package:picktory/models/notice_banner.dart';

/// IA H-1 홈 메인 카테고리 (ALL / 연애 / 서바이벌 / 음악)
const List<String> kHomeMissionCategories = <String>[
  'ALL',
  '연애',
  '서바이벌',
  '음악',
];

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
    required this.programs,
    this.noticeBanners = const [],
    this.categories = kHomeMissionCategories,
    this.inlineAdTitle,
  });

  final String nickname;
  final int points;
  final bool hasUnreadNotifications;
  final List<AdBanner> adBanners;
  final List<NoticeBanner> noticeBanners;
  final List<Mission> heroMissions;
  final List<Mission> activeMissions;
  final List<MissionResult> results;
  final bool hasInterestPrograms;
  final List<String> categories;
  final List<HomeProgramItem> programs;
  final String? inlineAdTitle;

  static const empty = HomeFeed(
    nickname: '게스트',
    points: 0,
    hasUnreadNotifications: false,
    adBanners: [],
    noticeBanners: [],
    heroMissions: [],
    activeMissions: [],
    results: [],
    hasInterestPrograms: false,
    programs: [],
  );
}
