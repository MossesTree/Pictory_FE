import 'package:flutter/material.dart';
import 'package:picktory/views/community/community_theme.dart';

class CommunityMainTabs extends StatelessWidget {
  const CommunityMainTabs({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      labelColor: CommunityTheme.textPrimary,
      unselectedLabelColor: CommunityTheme.textSecondary,
      indicatorColor: CommunityTheme.yellow,
      indicatorWeight: 3,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      tabs: const [
        Tab(text: '전체'),
        Tab(text: '스레드'),
        Tab(text: '유저 미션'),
      ],
    );
  }
}
