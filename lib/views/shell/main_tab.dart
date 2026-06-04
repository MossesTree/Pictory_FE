import 'package:picktory/core/navigation/app_route.dart';

/// GUI 탭 순서: 홈 → 랭킹 → 커뮤니티 → 보상 → MY
enum MainTab {
  home,
  ranking,
  community,
  benefits,
  my;

  String get label => switch (this) {
        MainTab.home => '홈',
        MainTab.ranking => '랭킹',
        MainTab.community => '커뮤니티',
        MainTab.benefits => '보상',
        MainTab.my => 'MY',
      };

  String get routePath => switch (this) {
        MainTab.home => AppRoute.home.path,
        MainTab.ranking => AppRoute.ranking.path,
        MainTab.community => AppRoute.community.path,
        MainTab.benefits => AppRoute.benefits.path,
        MainTab.my => AppRoute.my.path,
      };
}
