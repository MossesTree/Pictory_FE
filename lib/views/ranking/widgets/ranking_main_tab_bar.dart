import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_feed.dart';
import 'package:picktory/views/ranking/ranking_theme.dart';

class RankingMainTabBar extends StatelessWidget {
  const RankingMainTabBar({
    super.key,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      labelColor: RankingTheme.primary,
      unselectedLabelColor: RankingTheme.textSecondary,
      indicatorColor: RankingTheme.primary,
      indicatorWeight: 2,
      tabs: RankingMainTab.values
          .map((tab) => Tab(text: tab.label))
          .toList(),
    );
  }
}
