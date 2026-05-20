import 'package:flutter/material.dart';
import 'package:picktory/models/user_mission.dart';

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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _TypeBadge(mission: mission),
                  const SizedBox(width: 8),
                  _StatusBadge(status: mission.status),
                  const Spacer(),
                  Text(mission.authorNickname),
                ],
              ),
              const SizedBox(height: 8),
              Text(mission.programLabel),
              Text(
                mission.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (mission.remainingLabel != null) ...[
                const SizedBox(height: 4),
                Text(mission.remainingLabel!),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('♡ ${mission.likeCount}'),
                  const SizedBox(width: 8),
                  Text('👤 ${mission.participantCount}'),
                  const SizedBox(width: 8),
                  Text('□ ${mission.commentCount}'),
                  const SizedBox(width: 8),
                  Text('👁 ${mission.viewCount}'),
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
  const _TypeBadge({required this.mission});

  final UserMission mission;

  @override
  Widget build(BuildContext context) {
    final label = mission.isMissionType ? '미션형' : '투표형';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final UserMissionStatus status;

  @override
  Widget build(BuildContext context) {
    final label = status == UserMissionStatus.active ? '진행중' : '마감';
    return Text(label, style: const TextStyle(fontSize: 11));
  }
}
