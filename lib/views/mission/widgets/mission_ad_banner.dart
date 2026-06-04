import 'package:flutter/material.dart';
import 'package:picktory/views/mission/mission_theme.dart';

/// 미션 화면 상단 광고 배너 (Figma 524:3397 광고 슬롯)
/// 실제 광고 SDK 연동 전까지 컬러풀한 placeholder 사용
class MissionAdBanner extends StatelessWidget {
  const MissionAdBanner({
    super.key,
    this.height = 68,
    this.label = '제주로 떠나는 워케이션',
  });

  final double height;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4A90D9),
                      Color(0xFF2E6B8A),
                      Color(0xFF1A4D5C),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: -16,
                bottom: -10,
                child: Icon(
                  Icons.beach_access_rounded,
                  size: 60,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD600),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '광고',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 6,
                child: _AdPageDots(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdPageDots extends StatelessWidget {
  const _AdPageDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: i == 0 ? 6 : 5,
            height: i == 0 ? 6 : 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == 0
                  ? Colors.white
                  : const Color(0xFF1A1A1A).withValues(alpha: 0.4),
            ),
          ),
      ],
    );
  }
}

/// Pick 잔고·마감·참여수가 들어가는 큰 카운트다운 카드 (Figma 524:3397 마감 카드)
class MissionCountdownCard extends StatelessWidget {
  const MissionCountdownCard({
    super.key,
    required this.remainingLabel,
    required this.participantCount,
    required this.pointCost,
    required this.userPoints,
    this.rewardPoints,
  });

  final String remainingLabel;
  final int participantCount;
  final int pointCost;
  final int userPoints;
  final int? rewardPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: MissionTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MissionTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '마감까지',
                style: TextStyle(
                  fontSize: 13,
                  color: MissionTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (rewardPoints != null && rewardPoints! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: MissionTheme.pointPill,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '+${rewardPoints!}P',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            remainingLabel,
            style: const TextStyle(
              color: MissionTheme.countdown,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _MetaItem(
                icon: Icons.people_outline,
                label: '참여 ${_formatCount(participantCount)}',
              ),
              const SizedBox(width: 18),
              _MetaItem(
                icon: Icons.savings_outlined,
                label: '참여비용 ${pointCost}P',
              ),
              const Spacer(),
              Text(
                '보유 ${_formatCount(userPoints)}P',
                style: const TextStyle(
                  color: MissionTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatCount(int n) {
    return n.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: MissionTheme.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: MissionTheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// 미션 선택지 (라디오형, Figma 524:3397 4개 선택지)
class MissionChoiceTile extends StatelessWidget {
  const MissionChoiceTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: selected ? MissionTheme.badgeFill : MissionTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? MissionTheme.primary : MissionTheme.border,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MissionTheme.textPrimary,
                      fontSize: 15,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                _RadioMark(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? MissionTheme.primary : MissionTheme.textTertiary,
          width: 2,
        ),
        color: selected ? MissionTheme.primary : Colors.transparent,
      ),
      child: selected
          ? const Icon(Icons.circle, size: 8, color: Colors.white)
          : null,
    );
  }
}
