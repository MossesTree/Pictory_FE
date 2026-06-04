import 'package:flutter/material.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/models/mission.dart';
import 'package:picktory/views/home/home_theme.dart';

/// 홈 IA H-1: 오늘의 추천 미션 카드 — Figma 521:1596 하단 카드
class HomeMissionCard extends StatelessWidget {
  const HomeMissionCard({
    super.key,
    required this.mission,
    required this.onTap,
    required this.onChoiceTap,
  });

  final Mission mission;
  final VoidCallback onTap;
  final void Function(String choiceId) onChoiceTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PicktorySpacing.md),
      child: Material(
        color: HomeTheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: HomeTheme.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _CategoryBadge(label: mission.category),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${mission.programLabel} · 5화',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: HomeTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _PointPill(amount: mission.pointCost),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  mission.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: HomeTheme.textPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      '마감 ',
                      style: TextStyle(
                        fontSize: 12,
                        color: HomeTheme.textSecondary,
                      ),
                    ),
                    Text(
                      mission.remainingLabel,
                      style: const TextStyle(
                        fontSize: 12,
                        color: HomeTheme.progressOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.people_outline,
                      size: 13,
                      color: HomeTheme.textSecondary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '참여 ${_formatParticipants(mission.participantCount)}명',
                      style: const TextStyle(
                        fontSize: 12,
                        color: HomeTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (mission.choices.length >= 2) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _ChoiceButton(
                          label: mission.choices[0].label,
                          onPressed: () => onChoiceTap(mission.choices[0].id),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ChoiceButton(
                          label: mission.choices[1].label,
                          onPressed: () => onChoiceTap(mission.choices[1].id),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _formatParticipants(int count) {
    return count.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}

/// 카테고리 pill (보라 fill + 흰 글자, Figma 카드 좌상단)
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: HomeTheme.primaryPurple.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: HomeTheme.primaryPurple,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PointPill extends StatelessWidget {
  const _PointPill({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: HomeTheme.primaryPurple.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '+${amount}P',
        style: const TextStyle(
          color: HomeTheme.primaryPurple,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HomeTheme.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: HomeTheme.primaryPurple, width: 1.2),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: HomeTheme.primaryPurple,
            ),
          ),
        ),
      ),
    );
  }
}
