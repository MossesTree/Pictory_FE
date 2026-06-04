import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/navigation/app_router.dart';
import 'package:picktory/viewmodels/benefit_view_model.dart';
import 'package:picktory/views/benefits/benefit_theme.dart';
import 'package:picktory/views/benefits/widgets/ad_reward_tile.dart';
import 'package:picktory/views/benefits/widgets/attendance_complete_dialog.dart';
import 'package:picktory/views/benefits/widgets/attendance_week_row.dart';
import 'package:picktory/views/benefits/widgets/benefit_section_card.dart';
import 'package:picktory/views/benefits/widgets/mini_game_section.dart';

class BenefitsView extends StatefulWidget {
  const BenefitsView({super.key, required this.viewModel});

  final BenefitViewModel viewModel;

  @override
  State<BenefitsView> createState() => _BenefitsViewState();
}

class _BenefitsViewState extends State<BenefitsView> with RouteAware {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
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
    widget.viewModel.refresh();
  }

  Future<void> _onCheckIn() async {
    final result = await widget.viewModel.checkInToday();
    if (!mounted) {
      return;
    }
    if (result == null) {
      if (widget.viewModel.feed.checkedInToday) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('오늘은 이미 출석했어요.')),
        );
      }
      return;
    }
    await AttendanceCompleteDialog.show(context, result: result);
    ServiceLocator.instance.homeViewModel.refresh();
  }

  Future<void> _onWatchAd() async {
    if (!widget.viewModel.feed.adReward.canWatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('오늘 광고 시청 횟수를 모두 사용했어요.')),
      );
      return;
    }

    final earned = await context.push<int>(
      AppRoute.benefitsAdWatch.path,
      extra: widget.viewModel.feed.adReward.rewardPicks,
    );

    if (!mounted || earned == null) {
      return;
    }

    await widget.viewModel.onAdWatchCompleted();
    ServiceLocator.instance.homeViewModel.refresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('+$earned Pick 획득!')),
      );
    }
  }

  /// IA B-5: 미니게임 카드 탭 시 서브페이지로 이동
  void _onMiniGameTap() {
    context.push(AppRoute.benefitsMiniGames.path);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final viewModel = widget.viewModel;
        final feed = viewModel.feed;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: viewModel.isLoading && feed.weekSlots.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: viewModel.refresh,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                            child: const Text(
                              '혜택',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: BenefitTheme.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        if (viewModel.errorMessage != null)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: Text(
                                viewModel.errorMessage!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          ),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              BenefitSectionCard(
                                title: '출석체크',
                                subtitle: '매일 출석하면 Pick을 드려요',
                                trailing: viewModel.attendanceStreakLabel ==
                                        null
                                    ? null
                                    : Text(
                                        viewModel.attendanceStreakLabel!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: BenefitTheme.primary,
                                        ),
                                      ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    AttendanceWeekRow(slots: feed.weekSlots),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 48,
                                      child: FilledButton(
                                        onPressed: viewModel.canCheckInToday
                                            ? _onCheckIn
                                            : null,
                                        style: FilledButton.styleFrom(
                                          backgroundColor:
                                              BenefitTheme.primary,
                                          disabledBackgroundColor:
                                              BenefitTheme.disabledButton,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: viewModel.isCheckingIn
                                            ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                viewModel.checkInButtonLabel,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              BenefitSectionCard(
                                title: '광고 보고 Pick 받기',
                                subtitle: '광고를 끝까지 시청하고 Pick 보너스 받기',
                                child: AdRewardTile(
                                  status: feed.adReward,
                                  onWatch: _onWatchAd,
                                ),
                              ),
                              const SizedBox(height: 16),
                              MiniGameSection(
                                games: feed.miniGames,
                                onTapGame: (_) => _onMiniGameTap(),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
