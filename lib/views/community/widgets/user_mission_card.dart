import 'package:flutter/material.dart';
import 'package:picktory/models/user_mission.dart';
import 'package:picktory/views/community/community_theme.dart';

class UserMissionCard extends StatelessWidget {
  const UserMissionCard({
    super.key,
    required this.mission,
    required this.onTap,
  });

  final UserMission mission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: CommunityTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _TypeBadge(isMission: mission.isMissionType),
                  const SizedBox(width: 6),
                  _StatusBadge(isActive: mission.isActive),
                  const SizedBox(width: 6),
                  if (mission.authorBadge != null)
                    _TierBadge(label: mission.authorBadge!),
                  const Spacer(),
                  Text(
                    mission.authorNickname,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                mission.programLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: CommunityTheme.textSecondary,
                ),
              ),
              Text(
                mission.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (mission.choices.length >= 2) ...[
                const SizedBox(height: 8),
                Text(
                  mission.choices.take(2).join('  ·  '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CommunityTheme.textSecondary,
                  ),
                ),
              ],
              if (mission.remainingLabel != null) ...[
                const SizedBox(height: 6),
                Text(
                  mission.remainingLabel!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CommunityTheme.yellow,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  _Stat(Icons.favorite_border, mission.likeCount),
                  const SizedBox(width: 10),
                  _Stat(Icons.chat_bubble_outline, mission.commentCount),
                  const SizedBox(width: 10),
                  _Stat(Icons.remove_red_eye_outlined, mission.viewCount),
                  const Spacer(),
                  Text(
                    mission.createdAtLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: CommunityTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.isMission});

  final bool isMission;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isMission ? CommunityTheme.yellow : CommunityTheme.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isMission ? '미션형' : '투표형',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Text(
      isActive ? '진행중' : '마감',
      style: TextStyle(
        fontSize: 10,
        color: isActive ? Colors.green.shade700 : CommunityTheme.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: CommunityTheme.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.count);

  final IconData icon;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: CommunityTheme.textSecondary),
        const SizedBox(width: 3),
        Text('$count', style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
