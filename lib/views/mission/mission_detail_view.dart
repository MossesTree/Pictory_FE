import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/widgets/picktory_share_sheet.dart';
import 'package:picktory/viewmodels/mission_detail_view_model.dart';
import 'package:picktory/views/mission/mission_theme.dart';
import 'package:picktory/views/mission/mission_confirm_sheet.dart';
import 'package:picktory/views/mission/widgets/mission_ad_banner.dart';
import 'package:picktory/views/mission/widgets/mission_scaffold.dart';
import 'package:picktory/views/mission/widgets/mission_yellow_button.dart';

class MissionDetailView extends StatefulWidget {
  const MissionDetailView({super.key, required this.viewModel});

  final MissionDetailViewModel viewModel;

  @override
  State<MissionDetailView> createState() => _MissionDetailViewState();
}

class _MissionDetailViewState extends State<MissionDetailView> {
  MissionDetailViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.load();
  }

  Future<void> _openShareSheet(String missionId, String missionTitle) {
    return PicktoryShareSheet.show(
      context,
      shareUrl: 'https://picktory.app/mission/$missionId',
      title: missionTitle,
      subtitle: 'picktory.app/mission/$missionId',
    );
  }

  /// IA M-1 관련 스레드 → C-2
  /// Phase 3 서버 연동 전까지 인덱스에 대응되는 더미 게시물로 라우팅
  static String _relatedPostIdFor(int index) {
    const posts = ['post-1', 'post-2', 'post-3', 'post-4'];
    return posts[index % posts.length];
  }

  Future<void> _onSubmit() async {
    final result = await viewModel.submitChoice();
    if (!mounted || result == null) {
      return;
    }

    final label = viewModel.selectedChoiceLabel;
    if (label == null) {
      return;
    }

    final mission = viewModel.detail!.mission;
    final userBalance = viewModel.detail!.totalPointPool;

    await MissionConfirmSheet.show(
      context,
      selectedLabel: label,
      pointCost: mission.pointCost,
      balanceAfter: (userBalance - mission.pointCost).clamp(0, userBalance),
      participantCount: mission.participantCount,
      isSubmitting: viewModel.isSubmitting,
      onShare: () => context.push(AppRoute.missionSharePath(mission.id)),
      onHome: () => context.go(AppRoute.home.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const MissionScaffold(
            title: '미션 상세',
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final detail = viewModel.detail;
        if (detail == null) {
          return MissionScaffold(
            title: '미션 상세',
            body: Center(
              child: Text(
                viewModel.errorMessage ?? '미션을 찾을 수 없습니다.',
                style: const TextStyle(color: MissionTheme.textSecondary),
              ),
            ),
          );
        }

        final mission = detail.mission;

        return MissionScaffold(
          title: '미션 상세',
          actions: [
            IconButton(
              onPressed: () => _openShareSheet(mission.id, mission.title),
              icon: const Icon(
                Icons.ios_share_outlined,
                color: MissionTheme.primary,
              ),
            ),
          ],
          bottom: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: MissionYellowButton(
                label: '예측 참여하기',
                enabled: viewModel.canSubmit,
                onPressed: _onSubmit,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const MissionAdBanner(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _StatusBadge(label: '진행중'),
                        const SizedBox(width: 8),
                        Text(
                          mission.programLabel,
                          style: const TextStyle(
                            color: MissionTheme.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mission.title,
                      style: const TextStyle(
                        color: MissionTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 16),
                    MissionCountdownCard(
                      remainingLabel: mission.remainingLabel,
                      participantCount: mission.participantCount,
                      pointCost: mission.pointCost,
                      userPoints: detail.totalPointPool,
                      rewardPoints: mission.pointCost,
                    ),
                    const SizedBox(height: 20),
                    ...detail.options.map((option) {
                      return MissionChoiceTile(
                        label: option.label,
                        selected: viewModel.selectedChoiceId == option.id,
                        onTap: () => viewModel.selectChoice(option.id),
                      );
                    }),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: MissionTheme.textTertiary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '선택 후에는 변경할 수 없습니다',
                          style: TextStyle(
                            color: MissionTheme.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _RelatedSection(
                      title: '관련 미션',
                      children: detail.relatedMissions
                          .map(
                            (m) => _RelatedCard(
                              title: m.title,
                              subtitle:
                                  '마감 ${m.remainingLabel} · ${m.pointCost}포인트',
                              onTap: () => context
                                  .push(AppRoute.missionDetailPath(m.id)),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    _RelatedSection(
                      title: '관련 스레드',
                      children: detail.relatedThreadTitles
                          .asMap()
                          .entries
                          .map(
                            (entry) => _RelatedCard(
                              title: entry.value,
                              subtitle: '다들 최종 커플 누구라고 생각해요? 근데 아니 이거 행복 만들지 말고…',
                              onTap: () => context.push(
                                AppRoute.communityPostPath(
                                  _relatedPostIdFor(entry.key),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: MissionTheme.badgeFill,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: MissionTheme.primary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RelatedSection extends StatelessWidget {
  const _RelatedSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: MissionTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }
}

class _RelatedCard extends StatelessWidget {
  const _RelatedCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: MissionTheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            decoration: BoxDecoration(
              border: Border.all(color: MissionTheme.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MissionTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MissionTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: MissionTheme.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
