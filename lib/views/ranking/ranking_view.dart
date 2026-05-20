import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/models/ranking_feed.dart';
import 'package:picktory/services/dummy/dummy_ranking_data.dart';
import 'package:picktory/viewmodels/ranking_view_model.dart';
import 'package:picktory/views/ranking/widgets/ranking_main_tab_bar.dart';
import 'package:picktory/views/ranking/widgets/ranking_my_rank_bar.dart';
import 'package:picktory/views/ranking/widgets/ranking_profile_sheet.dart';
import 'package:picktory/views/ranking/widgets/ranking_tab_content.dart';

class RankingView extends StatefulWidget {
  const RankingView({super.key, required this.viewModel});

  final RankingViewModel viewModel;

  @override
  State<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  RankingViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: RankingMainTab.values.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
    viewModel.load();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      return;
    }
    viewModel.selectMainTab(RankingMainTab.values[_tabController.index]);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openProfile(String userId) async {
    final profile = await viewModel.loadProfilePreview(userId);
    if (!mounted || profile == null) {
      return;
    }
    await showRankingProfileSheet(context: context, profile: profile);
  }

  void _onMyRankTap() {
    context.push(AppRoute.rankingGrowth.path);
  }

  void _onUserTap(String userId) {
    if (userId == DummyRankingData.currentUserId) {
      _onMyRankTap();
      return;
    }
    _openProfile(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(
            '랭킹',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        RankingMainTabBar(controller: _tabController),
        if (viewModel.isRefreshing)
          const LinearProgressIndicator(minHeight: 2),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: RankingMainTab.values
                .map(
                  (tab) => RankingTabContent(
                    tab: tab,
                    viewModel: viewModel,
                    onUserTap: _onUserTap,
                  ),
                )
                .toList(),
          ),
        ),
        ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final summary = viewModel.mySummary;
            if (summary == null) {
              return const SizedBox.shrink();
            }
            return RankingMyRankBar(
              summary: summary,
              mainTab: viewModel.mainTab,
              onTap: _onMyRankTap,
              onGrowthRecordTap: viewModel.mainTab.isMissionBased
                  ? _onMyRankTap
                  : null,
            );
          },
        ),
      ],
    );
  }
}
