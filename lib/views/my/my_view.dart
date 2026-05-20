import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/navigation/app_router.dart';
import 'package:picktory/viewmodels/my_view_model.dart';
import 'package:picktory/views/my/my_theme.dart';
import 'package:picktory/views/my/widgets/my_menu_tile.dart';
import 'package:picktory/views/my/widgets/my_profile_edit_sheet.dart';

class MyView extends StatefulWidget {
  const MyView({super.key, required this.viewModel});

  final MyViewModel viewModel;

  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> with RouteAware {
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
    widget.viewModel.load();
  }

  Future<void> _openProfileEdit() async {
    final summary = widget.viewModel.summary;
    if (summary == null) {
      return;
    }
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MyProfileEditSheet(
        initialNickname: summary.nickname,
        onSave: widget.viewModel.updateNickname,
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필이 저장되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final summary = widget.viewModel.summary;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: widget.viewModel.isLoading && summary == null
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                          child: Row(
                            children: [
                              const Text(
                                '마이',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () =>
                                    context.push(AppRoute.settings.path),
                                icon: const Icon(Icons.settings_outlined),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (summary != null) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: InkWell(
                              onTap: _openProfileEdit,
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 32,
                                    child: Icon(Icons.person, size: 32),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          summary.nickname,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          summary.tierLabel,
                                          style: const TextStyle(
                                            color: MyTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                _StatBox(
                                  label: '전체 랭킹',
                                  value: '${summary.totalRanking}위',
                                ),
                                const SizedBox(width: 8),
                                _StatBox(
                                  label: '커뮤니티',
                                  value: '${summary.communityRanking}위',
                                ),
                                const SizedBox(width: 8),
                                _StatBox(
                                  label: '미션 달성',
                                  value: '${summary.missionRanking}위',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: MyTheme.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  _PointRow(
                                    label: '누적 포인트',
                                    value: '${summary.accumulatedPoints} pt',
                                  ),
                                  const Divider(height: 24),
                                  _PointRow(
                                    label: '현재 보유 포인트',
                                    value: '${summary.currentPoints} pt',
                                    highlight: true,
                                  ),
                                  const Divider(height: 24),
                                  _PointRow(
                                    label: '보유 티켓',
                                    value: '${summary.ticketCount}개',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            MyMenuTile(
                              title: '내 픽 기록',
                              onTap: () =>
                                  context.push(AppRoute.myPickHistory.path),
                            ),
                            const Divider(height: 1, indent: 16),
                            MyMenuTile(
                              title: '내 커뮤니티 활동',
                              onTap: () => context
                                  .push(AppRoute.myCommunityActivity.path),
                            ),
                            const Divider(height: 1, indent: 16),
                            MyMenuTile(
                              title: '스페셜 뱃지',
                              onTap: () =>
                                  context.push(AppRoute.myBadges.path),
                            ),
                            const Divider(height: 1, indent: 16),
                            MyMenuTile(
                              title: '관심 프로그램',
                              onTap: () => context
                                  .push(AppRoute.myInterestedPrograms.path),
                            ),
                          ]),
                        ),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: MyTheme.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: MyTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointRow extends StatelessWidget {
  const _PointRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: MyTheme.textSecondary)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: highlight ? MyTheme.primary : MyTheme.textPrimary,
            fontSize: highlight ? 18 : 14,
          ),
        ),
      ],
    );
  }
}
