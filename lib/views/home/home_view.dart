import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/navigation/app_router.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/core/widgets/picktory_async_state.dart';
import 'package:picktory/models/notice_banner.dart';
import 'package:picktory/viewmodels/home_view_model.dart';
import 'package:picktory/views/home/home_theme.dart';
import 'package:picktory/views/home/widgets/home_ad_banner_section.dart';
import 'package:picktory/views/home/widgets/home_category_chips.dart';
import 'package:picktory/views/home/widgets/home_inline_ad_banner.dart';
import 'package:picktory/views/home/widgets/home_mission_card.dart';
import 'package:picktory/views/home/widgets/home_mission_suggest_card.dart';
import 'package:picktory/views/home/widgets/home_notice_banner_section.dart';
import 'package:picktory/views/home/widgets/home_pick_section_title.dart';
import 'package:picktory/views/home/widgets/home_program_carousel.dart';
import 'package:picktory/views/home/widgets/home_result_card.dart';
import 'package:picktory/views/home/widgets/home_top_section.dart';
import 'package:picktory/views/search/picktory_search_sheet.dart';
import 'package:picktory/views/shell/shell_theme.dart';

/// H-1 홈 메인 View
/// IA 컴포넌트 순서:
///   1. 상단 광고 배너
///   2. 헤더 (로고/닉네임/Pick 잔고 칩/알림벨)
///   3. 검색창
///   4. 공지 배너 (Pick 충전/이벤트)
///   5. 히어로 카드 슬라이드
///   6. 섹션 타이틀 + 카테고리 칩 (ALL/연애/서바이벌/음악)
///   7. 프로그램 캐러셀
///   8. 미션 카드 리스트
///   9. 새 미션 건의하기 카드 (점선 테두리 💡)
///  10. 하단 인라인 광고 배너
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

  void _openBenefitsTab() {
    // IA H-1: Pick 잔고 칩 / Pick 충전 공지 → 혜택 탭으로 이동
    context.go(AppRoute.benefits.path);
  }

  void _openMissionSuggest() {
    context.push(AppRoute.communityMissionSuggest.path);
  }

  void _handleSearchTap() {
    PicktorySearchSheet.show(
      context,
      placeholder: viewModel.searchPlaceholder,
    );
  }

  void _handleNoticeBannerTap(NoticeBanner banner) {
    switch (banner.action) {
      case NoticeBannerAction.pickRecharge:
        _openBenefitsTab();
      case NoticeBannerAction.event:
      case NoticeBannerAction.notice:
        // 이벤트/공지 상세는 별도 화면이 없으므로 임시 안내
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(banner.title),
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: HomeTheme.background,
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading && !viewModel.hasData) {
            return PicktoryAsyncState.loading(
              color: HomeTheme.primaryPurple,
            );
          }

          if (viewModel.errorMessage != null && !viewModel.hasData) {
            return PicktoryAsyncState.error(
              message: viewModel.errorMessage!,
              onRetry: viewModel.loadFeed,
            );
          }

          final feed = viewModel.feed;
          final missions = viewModel.filteredMissions;
          final bottomInset = ShellTheme.scrollBottomPadding(context);

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: HomeTheme.primaryPurple,
                  onRefresh: () => viewModel.loadFeed(isRefresh: true),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // 1) 상단 광고 배너 (IA H-1 광고 배너 상단)
                      SliverToBoxAdapter(
                        child: HomeAdBannerSection(banners: feed.adBanners),
                      ),

                      // 2~3) 헤더 + 검색창 + 4) 히어로 카드
                      SliverToBoxAdapter(
                        child: HomeTopSection(
                          nickname: viewModel.displayNickname,
                          points: feed.points,
                          hasUnreadNotifications:
                              feed.hasUnreadNotifications,
                          searchPlaceholder: viewModel.searchPlaceholder,
                          heroMissions: feed.heroMissions,
                          onParticipate: (m) => _openMissionDetail(m.id),
                          onNotificationTap: _openNotifications,
                          onSearchTap: _handleSearchTap,
                          onPointsTap: _openBenefitsTab,
                        ),
                      ),

                      // 5) 공지 배너 섹션
                      SliverToBoxAdapter(
                        child: HomeNoticeBannerSection(
                          banners: feed.noticeBanners,
                          onTap: _handleNoticeBannerTap,
                        ),
                      ),

                      // 6) 섹션 타이틀
                      SliverToBoxAdapter(
                        child: HomePickSectionTitle(
                          title: viewModel.pickSectionTitle,
                        ),
                      ),

                      // 7) 카테고리 탭 (ALL/연애/서바이벌/음악)
                      SliverToBoxAdapter(
                        child: HomeCategoryChips(
                          categories: feed.categories,
                          selected: viewModel.selectedCategory,
                          onSelected: viewModel.selectCategory,
                        ),
                      ),

                      // 8) 관심 프로그램 캐러셀
                      SliverToBoxAdapter(
                        child: HomeProgramCarousel(
                          programs: feed.programs,
                          selectedId: viewModel.selectedProgramId,
                          onSelected: viewModel.selectProgram,
                        ),
                      ),

                      // 9) 미션 카드 리스트 (또는 빈 상태)
                      if (missions.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              PicktorySpacing.md,
                              PicktorySpacing.xl,
                              PicktorySpacing.md,
                              PicktorySpacing.md,
                            ),
                            child: Center(
                              child: Text(
                                viewModel.interestEmptyMessage,
                                style: const TextStyle(
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
                                padding: const EdgeInsets.only(
                                  bottom: PicktorySpacing.sm,
                                ),
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

                      // 10) 결과 공개 섹션 (IA H-1: 결과 카드 → M-4)
                      if (feed.results.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: HomePickSectionTitle(
                            title: viewModel.resultSectionTitle,
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final result = feed.results[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: PicktorySpacing.sm,
                                ),
                                child: HomeResultCard(
                                  result: result,
                                  onTap: () =>
                                      _openMissionResult(result.id),
                                ),
                              );
                            },
                            childCount: feed.results.length,
                          ),
                        ),
                      ],

                      // 11) 새 미션 건의하기 카드 (점선 테두리 💡)
                      SliverToBoxAdapter(
                        child: HomeMissionSuggestCard(
                          title: viewModel.suggestCardTitle,
                          subtitle: viewModel.suggestCardSubtitle,
                          onTap: _openMissionSuggest,
                        ),
                      ),

                      // 11) 하단 인라인 광고 배너
                      if (feed.inlineAdTitle != null)
                        SliverToBoxAdapter(
                          child: HomeInlineAdBanner(
                            title: feed.inlineAdTitle!,
                          ),
                        ),

                      // 하단 안전 여백 (탭바와 겹치지 않도록)
                      SliverToBoxAdapter(
                        child: SizedBox(height: bottomInset),
                      ),
                    ],
                  ),
                ),
              ),
              if (viewModel.isRefreshing)
                const LinearProgressIndicator(
                  minHeight: 2,
                  color: HomeTheme.primaryPurple,
                  backgroundColor: HomeTheme.border,
                ),
            ],
          );
        },
      ),
    );
  }
}
