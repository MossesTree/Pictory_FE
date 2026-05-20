import 'package:flutter/material.dart';
import 'package:picktory/services/dummy/dummy_ranking_data.dart';
import 'package:picktory/viewmodels/ranking_view_model.dart';
import 'package:picktory/views/ranking/widgets/ranking_activity_score_banner.dart';
import 'package:picktory/views/ranking/widgets/ranking_list_header.dart';
import 'package:picktory/views/ranking/widgets/ranking_list_row.dart';
import 'package:picktory/views/ranking/widgets/ranking_main_tab_bar.dart';
import 'package:picktory/views/ranking/widgets/ranking_my_rank_bar.dart';
import 'package:picktory/views/ranking/widgets/ranking_period_selector.dart';
import 'package:picktory/views/ranking/widgets/ranking_profile_sheet.dart';
import 'package:picktory/views/ranking/widgets/ranking_top3_podium.dart';

class RankingView extends StatefulWidget {
  const RankingView({super.key, required this.viewModel});

  final RankingViewModel viewModel;

  @override
  State<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> {
  final ScrollController _scrollController = ScrollController();

  RankingViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    viewModel.load();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final max = _scrollController.position.maxScrollExtent;
    if (_scrollController.position.pixels >= max - 200) {
      viewModel.loadMore();
    }
  }

  Future<void> _openProfile(String userId) async {
    final profile = await viewModel.loadProfilePreview(userId);
    if (!mounted || profile == null) {
      return;
    }
    await showRankingProfileSheet(
      context: context,
      profile: profile,
      onEditProfile: profile.isCurrentUser ? _onEditProfile : null,
    );
  }

  void _onEditProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('프로필 수정 화면은 준비 중입니다.')),
    );
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
        ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return RankingMainTabBar(
              selected: viewModel.mainTab,
              onSelected: viewModel.selectMainTab,
            );
          },
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) {
              if (viewModel.isLoading && viewModel.podium.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.errorMessage != null && viewModel.podium.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(viewModel.errorMessage!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: viewModel.load,
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  if (viewModel.isRefreshing)
                    const LinearProgressIndicator(minHeight: 2),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => viewModel.load(isRefresh: true),
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: RankingPeriodSelector(
                              options: viewModel.periodOptions,
                              selectedId: viewModel.selectedPeriodId,
                              onSelected: viewModel.selectPeriod,
                            ),
                          ),
                          if (viewModel.activityScoreFormula != null)
                            SliverToBoxAdapter(
                              child: RankingActivityScoreBanner(
                                formula: viewModel.activityScoreFormula!,
                              ),
                            ),
                          SliverToBoxAdapter(
                            child: RankingTop3Podium(
                              entries: viewModel.podium,
                              scoreLabel: viewModel.scoreColumnLabel,
                              onUserTap: _openProfile,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: RankingListHeader(
                              scoreLabel: viewModel.scoreColumnLabel,
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= viewModel.entries.length) {
                                  if (viewModel.isLoadingMore) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (viewModel.hasMore) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(child: Text('· · ·')),
                                    );
                                  }
                                  return null;
                                }
                                final entry = viewModel.entries[index];
                                return RankingListRow(
                                  entry: entry,
                                  onTap: () => _openProfile(entry.userId),
                                );
                              },
                              childCount: viewModel.entries.length +
                                  (viewModel.hasMore || viewModel.isLoadingMore
                                      ? 1
                                      : 0),
                            ),
                          ),
                          const SliverToBoxAdapter(child: SizedBox(height: 8)),
                        ],
                      ),
                    ),
                  ),
                  if (viewModel.mySummary != null)
                    RankingMyRankBar(
                      summary: viewModel.mySummary!,
                      mainTab: viewModel.mainTab,
                      onTap: () => _openProfile(DummyRankingData.currentUserId),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
