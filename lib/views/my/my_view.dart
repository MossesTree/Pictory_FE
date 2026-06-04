import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/navigation/app_router.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/models/my_page_summary.dart';
import 'package:picktory/viewmodels/my_view_model.dart';
import 'package:picktory/views/my/my_theme.dart';
import 'package:picktory/views/my/widgets/my_menu_tile.dart';
import 'package:picktory/views/my/widgets/my_profile_edit_sheet.dart';

/// IA MY-1 마이 메인
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

  Future<void> _copyInviteCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('초대코드가 복사됐어요!')),
    );
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
                : summary == null
                    ? const Center(
                        child: Text(
                          '정보를 불러올 수 없어요',
                          style: TextStyle(color: MyTheme.textSecondary),
                        ),
                      )
                    : CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(child: _TopBar()),
                          SliverToBoxAdapter(
                            child: _ProfileRow(
                              summary: summary,
                              onEdit: _openProfileEdit,
                            ),
                          ),
                          SliverToBoxAdapter(
                              child: _RankingCardsRow(summary: summary)),
                          SliverToBoxAdapter(
                            child: _PicksCard(
                              summary: summary,
                              onCharge: () =>
                                  context.go(AppRoute.benefits.path),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: _GrowthBar(
                              summary: summary,
                              onTapRecord: () => context
                                  .push(AppRoute.rankingGrowth.path),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: _InviteCodeCard(
                              code: summary.inviteCode,
                              onCopy: () => _copyInviteCode(summary.inviteCode),
                            ),
                          ),
                          const SliverToBoxAdapter(
                              child: SizedBox(height: PicktorySpacing.md)),
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
                              const SizedBox(height: PicktorySpacing.xl),
                            ]),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
      child: Row(
        children: [
          const Text(
            '마이',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => context.push(AppRoute.settings.path),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
    );
  }
}

/// IA MY-1: 프로필 이미지 + ✏ 연필 아이콘 + 닉네임 + 성장 뱃지 단계
class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.summary, required this.onEdit});

  final MyPageSummary summary;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: MyTheme.primaryLight,
                child: const Icon(
                  Icons.person,
                  size: 32,
                  color: MyTheme.primary,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: MyTheme.border),
                    ),
                    child: const Icon(Icons.edit, size: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.nickname,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(summary.tierEmoji,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text(
                      summary.tierLabel,
                      style: const TextStyle(
                        color: MyTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// IA MY-1: 시즌/전체/커뮤니티 랭킹 카드 3종, 각 탭 시 랭킹 탭으로 이동
class _RankingCardsRow extends StatelessWidget {
  const _RankingCardsRow({required this.summary});

  final MyPageSummary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _RankingCard(
            label: '시즌',
            rank: summary.seasonRanking,
            onTap: () => context.go(AppRoute.ranking.path),
          ),
          const SizedBox(width: 8),
          _RankingCard(
            label: '전체',
            rank: summary.totalRanking,
            onTap: () => context.go(AppRoute.ranking.path),
          ),
          const SizedBox(width: 8),
          _RankingCard(
            label: '커뮤니티',
            rank: summary.communityRanking,
            onTap: () => context.go(AppRoute.ranking.path),
          ),
        ],
      ),
    );
  }
}

class _RankingCard extends StatelessWidget {
  const _RankingCard({
    required this.label,
    required this.rank,
    required this.onTap,
  });

  final String label;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: MyTheme.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: MyTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$rank위',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// IA MY-1: 보유 픽 + 충전 › / 누적 포인트
class _PicksCard extends StatelessWidget {
  const _PicksCard({required this.summary, required this.onCharge});

  final MyPageSummary summary;
  final VoidCallback onCharge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: MyTheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: onCharge,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Text(
                      '보유 픽',
                      style: TextStyle(color: MyTheme.textSecondary),
                    ),
                    const Spacer(),
                    Text(
                      '${summary.currentPoints} Pick',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: MyTheme.primary,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '충전',
                      style: TextStyle(
                        fontSize: 13,
                        color: MyTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: MyTheme.primary, size: 18),
                  ],
                ),
              ),
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Text(
                  '전체 누적 포인트',
                  style: TextStyle(color: MyTheme.textSecondary),
                ),
                const Spacer(),
                Text(
                  '${summary.accumulatedPoints} pt',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// IA MY-1: 성장 바 + 성장 기록 › 버튼 (탭 시 성장 뱃지 맵)
class _GrowthBar extends StatelessWidget {
  const _GrowthBar({required this.summary, required this.onTapRecord});

  final MyPageSummary summary;
  final VoidCallback onTapRecord;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '성장 단계',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: onTapRecord,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '성장 기록',
                        style: TextStyle(
                          fontSize: 12,
                          color: MyTheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(Icons.chevron_right,
                          size: 14, color: MyTheme.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: summary.tierProgress,
              minHeight: 8,
              backgroundColor: MyTheme.border,
              color: MyTheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(summary.tierProgress * 100).round()}% · 다음 단계까지 화이팅!',
            style: const TextStyle(
              fontSize: 11,
              color: MyTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// IA MY-1: 내 초대코드 + 복사하기 버튼
class _InviteCodeCard extends StatelessWidget {
  const _InviteCodeCard({required this.code, required this.onCopy});

  final String code;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: MyTheme.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '내 초대코드',
                  style: TextStyle(
                    fontSize: 11,
                    color: MyTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  code,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: MyTheme.primary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: onCopy,
              style: OutlinedButton.styleFrom(
                foregroundColor: MyTheme.primary,
                side: const BorderSide(color: MyTheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '복사하기',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
