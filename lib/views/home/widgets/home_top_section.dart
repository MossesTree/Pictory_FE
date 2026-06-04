import 'package:flutter/material.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/views/home/home_theme.dart';
import 'package:picktory/views/home/widgets/home_header_bar.dart';
import 'package:picktory/views/home/widgets/home_hero_mission_card.dart';
import 'package:picktory/views/home/widgets/home_search_bar.dart';

/// 홈 상단 라벤더 패널 — 헤더 · 검색 · 히어로 캐러셀 (Figma 상단 GUI)
class HomeTopSection extends StatelessWidget {
  const HomeTopSection({
    super.key,
    required this.nickname,
    required this.points,
    required this.hasUnreadNotifications,
    required this.searchPlaceholder,
    required this.heroMissions,
    required this.onParticipate,
    this.onNotificationTap,
    this.onSearchTap,
    this.onPointsTap,
  });

  final String nickname;
  final int points;
  final bool hasUnreadNotifications;
  final String searchPlaceholder;
  final List<Mission> heroMissions;
  final ValueChanged<Mission> onParticipate;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onPointsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: HomeTheme.headerLavender,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(HomeTheme.headerBottomRadius),
          bottomRight: Radius.circular(HomeTheme.headerBottomRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeHeaderBar(
            nickname: nickname,
            points: points,
            hasUnreadNotifications: hasUnreadNotifications,
            onNotificationTap: onNotificationTap,
            onPointsTap: onPointsTap,
          ),
          HomeSearchBar(
            placeholder: searchPlaceholder,
            onTap: onSearchTap,
          ),
          if (heroMissions.isNotEmpty)
            HomeHeroMissionCarousel(
              missions: heroMissions,
              onParticipate: onParticipate,
            ),
        ],
      ),
    );
  }
}
