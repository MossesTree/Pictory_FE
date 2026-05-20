import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/navigation/app_router.dart';
import 'package:picktory/viewmodels/home_view_model.dart';
import 'package:picktory/views/home/home_theme.dart';
import 'package:picktory/views/home/widgets/home_ad_banner_section.dart';
import 'package:picktory/views/home/widgets/home_category_chips.dart';
import 'package:picktory/views/home/widgets/home_header_bar.dart';
import 'package:picktory/views/home/widgets/home_hero_mission_card.dart';
import 'package:picktory/views/home/widgets/home_inline_ad_banner.dart';
import 'package:picktory/views/home/widgets/home_mission_card.dart';
import 'package:picktory/views/home/widgets/home_result_card.dart';
import 'package:picktory/views/home/widgets/home_section_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with RouteAware {
  HomeViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.loadFeed();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<void>) {
      AppRouter.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    AppRouter.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    viewModel.refresh();
  }

  void _openMissionDetail(String missionId) {
    context.push(AppRoute.missionDetailPath(missionId));
  }

  void _openMissionResult(String missionId) {
    context.push(AppRoute.missionResultPath(missionId));
  }

  void _openNotifications() {
    context.push(AppRoute.notifications.path);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: HomeTheme.background,
      child: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            if (viewModel.isLoading && !viewModel.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: HomeTheme.yellow),
              );
            }

            if (viewModel.errorMessage != null && !viewModel.hasData) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: HomeTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: viewModel.loadFeed,
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              );
            }

            final feed = viewModel.feed;
            final missions = viewModel.filteredMissions;

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    color: HomeTheme.yellow,
                    onRefresh: () => viewModel.loadFeed(isRefresh: true),
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: HomeAdBannerSection(banners: feed.adBanners),
                        ),
                        SliverToBoxAdapter(
                          child: HomeHeaderBar(
                            nickname: feed.nickname,
                            points: feed.points,
                            hasUnreadNotifications:
                                feed.hasUnreadNotifications,
                            onNotificationTap: _openNotifications,
                          ),
                        ),
                        if (feed.heroMissions.isNotEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: HomeHeroMissionCard(
                                mission: feed.heroMissions.first,
                                onParticipate: () => _openMissionDetail(
                                  feed.heroMissions.first.id,
                                ),
                              ),
                            ),
                          ),
                        SliverToBoxAdapter(
                          child: HomeCategoryChips(
                            categories: feed.categories,
                            selected: viewModel.selectedCategory,
                            onSelected: viewModel.selectCategory,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 12)),
                        if (missions.isEmpty)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: Text(
                                  '해당 카테고리의 미션이 없습니다',
                                  style: TextStyle(
                                    color: HomeTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final mission = missions[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: HomeMissionCard(
                                    mission: mission,
                                    onTap: () =>
                                        _openMissionDetail(mission.id),
                                    onChoiceTap: (_) =>
                                        _openMissionDetail(mission.id),
                                  ),
                                );
                              },
                              childCount: missions.length,
                            ),
                          ),
                        if (feed.inlineAdTitle != null)
                          SliverToBoxAdapter(
                            child: HomeInlineAdBanner(
                              title: feed.inlineAdTitle!,
                            ),
                          ),
                        if (feed.results.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: HomeSectionHeader(
                              title: viewModel.resultSectionTitle,
                              titleColor: HomeTheme.textPrimary,
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final result = feed.results[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: HomeResultCard(
                                    result: result,
                                    onTap: () => _openMissionResult(
                                      'mission-hero-1',
                                    ),
                                  ),
                                );
                              },
                              childCount: feed.results.length,
                            ),
                          ),
                        ],
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],
                    ),
                  ),
                ),
                if (viewModel.isRefreshing)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    color: HomeTheme.yellow,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
