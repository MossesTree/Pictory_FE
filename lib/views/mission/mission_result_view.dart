import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/widgets/picktory_share_sheet.dart';
import 'package:picktory/viewmodels/mission_result_view_model.dart';
import 'package:picktory/views/mission/mission_theme.dart';
import 'package:picktory/views/mission/widgets/mission_ad_banner.dart';
import 'package:picktory/views/mission/widgets/mission_scaffold.dart';
import 'package:picktory/views/mission/widgets/mission_yellow_button.dart';

class MissionResultView extends StatefulWidget {
  const MissionResultView({super.key, required this.viewModel});

  final MissionResultViewModel viewModel;

  @override
  State<MissionResultView> createState() => _MissionResultViewState();
}

class _MissionResultViewState extends State<MissionResultView> {
  MissionResultViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.load();
  }

  /// IA M-4 관련 스레드 → C-2
  static String _relatedPostIdFor(int index) {
    const posts = ['post-1', 'post-2', 'post-3', 'post-4'];
    return posts[index % posts.length];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.isLoading) {
          return const MissionScaffold(
            title: '미션 결과',
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final result = viewModel.result;
        if (result == null) {
          return MissionScaffold(
            title: '미션 결과',
            body: Center(
              child: Text(
                viewModel.errorMessage ?? '결과 없음',
                style: const TextStyle(color: MissionTheme.textSecondary),
              ),
            ),
          );
        }

        return MissionScaffold(
          title: '미션 결과',
          actions: [
            IconButton(
              onPressed: () => PicktoryShareSheet.show(
                context,
                shareUrl:
                    'https://picktory.app/mission/${result.missionId}/result',
                title: result.title,
                subtitle: result.programLabel,
              ),
              icon: const Icon(
                Icons.ios_share_outlined,
                color: MissionTheme.primary,
              ),
            ),
          ],
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
                        const _ResultBadge(),
                        const SizedBox(width: 8),
                        Text(
                          result.programLabel,
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
                      result.title,
                      style: const TextStyle(
                        color: MissionTheme.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _CorrectAnswerCard(
                      isCorrect: result.isCorrect,
                      label: result.userChoice.label,
                      earnedPoints: result.earnedPoints,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '참여자 선택 비율',
                      style: TextStyle(
                        color: MissionTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...result.choiceStats.map(
                      (stat) => _ChoicePercentBar(
                        label: stat.choice.label,
                        percent: stat.percent,
                        isUserChoice: stat.isUserChoice,
                        isCorrect: stat.isCorrect,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Center(
                      child: Text(
                        '출처: ENA 환승연애4 5화 방영 결과',
                        style: TextStyle(
                          color: MissionTheme.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    MissionYellowButton(
                      label: '스레드에 공유하기',
                      onPressed: () => context
                          .push(AppRoute.missionSharePath(result.missionId)),
                    ),
                    const SizedBox(height: 24),
                    _RelatedSection(
                      title: '관련 스레드',
                      children: result.relatedThreadTitles
                          .asMap()
                          .entries
                          .map(
                            (entry) => _RelatedCard(
                              title: entry.value,
                              subtitle:
                                  '다들 최종 커플 누구라고 생각해요? 근데 아니 이거 행복 만들지 말고…',
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

class _ResultBadge extends StatelessWidget {
  const _ResultBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: MissionTheme.badgeFill,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        '결과 공개',
        style: TextStyle(
          color: MissionTheme.primary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CorrectAnswerCard extends StatelessWidget {
  const _CorrectAnswerCard({
    required this.isCorrect,
    required this.label,
    required this.earnedPoints,
  });

  final bool isCorrect;
  final String label;
  final int earnedPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: MissionTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MissionTheme.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: MissionTheme.badgeFill,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isCorrect ? '정답' : '오답',
              style: TextStyle(
                color: isCorrect ? MissionTheme.primary : MissionTheme.wrong,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: MissionTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (earnedPoints > 0)
            Text(
              '+${earnedPoints}pt',
              style: const TextStyle(
                color: MissionTheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }
}

class _ChoicePercentBar extends StatelessWidget {
  const _ChoicePercentBar({
    required this.label,
    required this.percent,
    required this.isUserChoice,
    required this.isCorrect,
  });

  final String label;
  final int percent;
  final bool isUserChoice;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final highlighted = isUserChoice || isCorrect;
    final fillColor = highlighted ? MissionTheme.progress : MissionTheme.progressTrack;
    final textColor = highlighted ? MissionTheme.primary : MissionTheme.textSecondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 48,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              decoration: BoxDecoration(
                color: MissionTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: highlighted ? MissionTheme.primary : MissionTheme.border,
                  width: highlighted ? 1.5 : 1,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FractionallySizedBox(
                widthFactor: (percent / 100).clamp(0.0, 1.0),
                child: Container(color: fillColor.withValues(alpha: 0.18)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  if (highlighted)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.check_circle,
                        size: 16,
                        color: MissionTheme.primary,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: MissionTheme.textPrimary,
                        fontSize: 14,
                        fontWeight:
                            highlighted ? FontWeight.w700 : FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
