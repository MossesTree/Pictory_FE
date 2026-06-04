import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/models/user_mission.dart';
import 'package:picktory/models/user_mission_choice_stat.dart';
import 'package:picktory/viewmodels/user_mission_detail_view_model.dart';
import 'package:picktory/views/community/community_theme.dart';

class UserMissionDetailView extends StatefulWidget {
  const UserMissionDetailView({super.key, required this.viewModel});

  final UserMissionDetailViewModel viewModel;

  @override
  State<UserMissionDetailView> createState() => _UserMissionDetailViewState();
}

class _UserMissionDetailViewState extends State<UserMissionDetailView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  Future<void> _participate() async {
    final ok = await widget.viewModel.participate();
    if (!mounted || !ok) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('선택이 완료되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return Scaffold(
      backgroundColor: CommunityTheme.background,
      appBar: AppBar(
        backgroundColor: CommunityTheme.background,
        title: Text(
          viewModel.mission?.isMissionType == true
              ? '유저 미션'
              : '유저 투표',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              final id = viewModel.mission?.id;
              if (id != null) {
                context.push(
                  AppRoute.communityReportPath(
                    targetType: 'userMission',
                    targetId: id,
                  ),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final mission = viewModel.mission;
          if (mission == null ||
              mission.hasParticipated ||
              !mission.isActive) {
            return const SizedBox.shrink();
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: viewModel.canParticipate ? _participate : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CommunityTheme.textPrimary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: CommunityTheme.surface,
                  ),
                  child: Text(
                    viewModel.isSubmitting
                        ? '처리 중...'
                        : viewModel.participateButtonLabel,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          }
          final mission = viewModel.mission;
          if (mission == null) {
            return const SizedBox.shrink();
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _AuthorHeader(mission: mission),
              const SizedBox(height: 16),
              Text(
                mission.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${mission.participantCount}명 참여',
                style: const TextStyle(color: CommunityTheme.textSecondary),
              ),
              if (mission.isMissionType && mission.remainingLabel != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: CommunityTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '마감까지 ${mission.remainingLabel}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: CommunityTheme.yellow,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '마감 후 결과가 공개됩니다',
                  style: TextStyle(
                    fontSize: 12,
                    color: CommunityTheme.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (mission.hasParticipated && mission.isPollType)
                ...mission.choiceStats.map(
                  (stat) => _PollResultBar(stat: stat),
                )
              else
                ...mission.choices.asMap().entries.map(
                  (entry) => _ChoiceTile(
                    label: entry.value,
                    selected: viewModel.selectedChoiceIndex == entry.key,
                    enabled: !mission.hasParticipated && mission.isActive,
                    onTap: () => viewModel.selectChoice(entry.key),
                  ),
                ),
              if (mission.userSelectedChoice != null) ...[
                const SizedBox(height: 12),
                Text(
                  '내 선택: ${mission.userSelectedChoice}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
              const SizedBox(height: 24),
              // IA UM-4 → C-2: 이 미션과 연결된 스레드로 이동
              _RelatedThreadCard(
                onTap: () => context.push(
                  AppRoute.communityPostPath(
                    viewModel.relatedPostId,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.push(
                    AppRoute.communityReportPath(
                      targetType: 'userMission',
                      targetId: mission.id,
                    ),
                  );
                },
                child: const Text('신고하기'),
              ),
              Row(
                children: [
                  _Stat(Icons.favorite_border, mission.likeCount),
                  const SizedBox(width: 12),
                  _Stat(Icons.chat_bubble_outline, mission.commentCount),
                  const SizedBox(width: 12),
                  _Stat(Icons.remove_red_eye_outlined, mission.viewCount),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                mission.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: CommunityTheme.textSecondary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AuthorHeader extends StatelessWidget {
  const _AuthorHeader({required this.mission});

  final UserMission mission;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: CommunityTheme.surface,
          child: Text(mission.authorNickname[0]),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    mission.authorNickname,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (mission.authorBadge != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: CommunityTheme.yellow.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        mission.authorBadge!,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                '${mission.programLabel} · ${mission.createdAtLabel}',
                style: const TextStyle(
                  fontSize: 12,
                  color: CommunityTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? CommunityTheme.yellow
                  : CommunityTheme.border,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: selected
                ? CommunityTheme.yellow.withValues(alpha: 0.15)
                : null,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

class _PollResultBar extends StatelessWidget {
  const _PollResultBar({required this.stat});

  final UserMissionChoiceStat stat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(stat.label)),
              Text(
                '${stat.percent}%',
                style: TextStyle(
                  fontWeight: stat.isUserChoice ? FontWeight.w700 : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stat.percent / 100,
              minHeight: 8,
              backgroundColor: CommunityTheme.surface,
              color: stat.isUserChoice
                  ? CommunityTheme.yellow
                  : CommunityTheme.border,
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedThreadCard extends StatelessWidget {
  const _RelatedThreadCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CommunityTheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CommunityTheme.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.forum_outlined,
                size: 18,
                color: CommunityTheme.yellow,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '관련 스레드 보기',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: CommunityTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '같은 미션에 대한 사용자들의 의견을 확인하세요',
                      style: TextStyle(
                        fontSize: 12,
                        color: CommunityTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: CommunityTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
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
        Icon(icon, size: 16, color: CommunityTheme.textSecondary),
        const SizedBox(width: 4),
        Text('$count'),
      ],
    );
  }
}
