import 'package:flutter/material.dart';
import 'package:picktory/models/ranking_feed.dart';
import 'package:picktory/viewmodels/ranking_view_model.dart';
import 'package:picktory/views/ranking/widgets/ranking_info_banner.dart';
import 'package:picktory/views/ranking/widgets/ranking_list_header.dart';
import 'package:picktory/views/ranking/widgets/ranking_list_row.dart';
import 'package:picktory/views/ranking/widgets/ranking_period_selector.dart';
import 'package:picktory/views/ranking/widgets/ranking_top3_podium.dart';

class RankingTabContent extends StatefulWidget {
  const RankingTabContent({
    super.key,
    required this.tab,
    required this.viewModel,
    required this.onUserTap,
  });

  final RankingMainTab tab;
  final RankingViewModel viewModel;
  final ValueChanged<String> onUserTap;

  @override
  State<RankingTabContent> createState() => _RankingTabContentState();
}

class _RankingTabContentState extends State<RankingTabContent>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (widget.viewModel.mainTab != widget.tab) {
      return;
    }
    if (!_scrollController.hasClients) {
      return;
    }
    final max = _scrollController.position.maxScrollExtent;
    if (_scrollController.position.pixels >= max - 200) {
      widget.viewModel.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final podium = widget.viewModel.podiumFor(widget.tab);
        final entries = widget.viewModel.entriesFor(widget.tab);
        final isLoading = widget.viewModel.isLoadingFor(widget.tab);
        final error = widget.viewModel.errorMessageFor(widget.tab);

        if (isLoading && podium.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null && podium.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    widget.viewModel.selectMainTab(widget.tab);
                    widget.viewModel.load();
                  },
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          );
        }

        if (podium.isEmpty && !widget.viewModel.hasCacheFor(widget.tab)) {
          return const SizedBox.shrink();
        }

        final scoreLabel =
            widget.tab == RankingMainTab.community ? '활동점수' : '점수';

        return RefreshIndicator(
          onRefresh: () async {
            widget.viewModel.selectMainTab(widget.tab);
            await widget.viewModel.load(isRefresh: true);
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: RankingPeriodSelector(
                  options: widget.viewModel.periodOptionsFor(widget.tab),
                  selectedId: widget.viewModel.selectedPeriodIdFor(widget.tab),
                  onSelected: (id) =>
                      widget.viewModel.selectPeriodForTab(widget.tab, id),
                ),
              ),
              if (widget.viewModel.infoBannerFor(widget.tab) != null)
                SliverToBoxAdapter(
                  child: RankingInfoBanner(
                    message: widget.viewModel.infoBannerFor(widget.tab)!,
                  ),
                ),
              SliverToBoxAdapter(
                child: RankingTop3Podium(
                  entries: podium,
                  useCommunityTitles:
                      widget.viewModel.useCommunityTitlesFor(widget.tab),
                  onUserTap: widget.onUserTap,
                ),
              ),
              SliverToBoxAdapter(
                child: RankingListHeader(scoreLabel: scoreLabel),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= entries.length) {
                      if (widget.viewModel.isLoadingMoreFor(widget.tab)) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      return null;
                    }
                    final entry = entries[index];
                    return RankingListRow(
                      entry: entry,
                      onTap: () => widget.onUserTap(entry.userId),
                    );
                  },
                  childCount: entries.length +
                      (widget.viewModel.isLoadingMoreFor(widget.tab) ? 1 : 0),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
            ],
          ),
        );
      },
    );
  }
}
