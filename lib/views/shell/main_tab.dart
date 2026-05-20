import 'package:picktory/core/navigation/app_route.dart';

enum MainTab {
  ranking,
  community,
  home,
  benefits,
  my;

  String get label => switch (this) {
        MainTab.ranking => '랭킹',
        MainTab.community => '커뮤니티',
        MainTab.home => '홈',
        MainTab.benefits => '혜택',
        MainTab.my => '마이',
      };

  String get icon => switch (this) {
        MainTab.ranking => '🏆',
        MainTab.community => '💬',
        MainTab.home => '홈',
        MainTab.benefits => '🎁',
        MainTab.my => '👤',
      };

  String get routePath => switch (this) {
        MainTab.ranking => AppRoute.ranking.path,
        MainTab.community => AppRoute.community.path,
        MainTab.home => AppRoute.home.path,
        MainTab.benefits => AppRoute.benefits.path,
        MainTab.my => AppRoute.my.path,
      };
}
