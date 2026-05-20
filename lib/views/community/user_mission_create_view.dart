import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/models/user_mission.dart';
import 'package:picktory/viewmodels/user_mission_create_view_model.dart';
import 'package:picktory/views/community/community_theme.dart';

class UserMissionCreateView extends StatelessWidget {
  const UserMissionCreateView({super.key, required this.viewModel});

  final UserMissionCreateViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: CommunityTheme.background,
          appBar: AppBar(
            backgroundColor: CommunityTheme.background,
            leading: TextButton(
              onPressed: () => context.pop(),
              child: const Text('취소'),
            ),
            title: const Text('유저 미션'),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: viewModel.canSubmit
                      ? () => _submit(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CommunityTheme.textPrimary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: CommunityTheme.surface,
                  ),
                  child: Text(
                    viewModel.isSubmitting ? '등록 중...' : '유저 미션 올리기',
                  ),
                ),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                '유형 선택',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              SegmentedButton<UserMissionType>(
                segments: const [
                  ButtonSegment(
                    value: UserMissionType.mission,
                    label: Text('미션형'),
                  ),
                  ButtonSegment(
                    value: UserMissionType.poll,
                    label: Text('투표형'),
                  ),
                ],
                selected: {viewModel.type},
                onSelectionChanged: (set) {
                  viewModel.selectType(set.first);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: viewModel.programLabel,
                decoration: const InputDecoration(labelText: '프로그램 *'),
                items: const [
                  DropdownMenuItem(
                    value: '환승연애4 · 5화',
                    child: Text('환승연애4 · 5화'),
                  ),
                  DropdownMenuItem(
                    value: '나는솔로 · 10기',
                    child: Text('나는솔로 · 10기'),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) {
                    viewModel.updateProgram(v);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(labelText: '미션 제목 *'),
                onChanged: viewModel.updateTitle,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(labelText: '선택지 A *'),
                onChanged: viewModel.updateChoiceA,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(labelText: '선택지 B *'),
                onChanged: viewModel.updateChoiceB,
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('선택지 추가'),
              ),
              if (viewModel.type == UserMissionType.mission) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: viewModel.deadlineLabel,
                  decoration: const InputDecoration(
                    labelText: '마감 시간 * (미션형 필수)',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: '24시간 후',
                      child: Text('24시간 후'),
                    ),
                    DropdownMenuItem(
                      value: '48시간 후',
                      child: Text('48시간 후'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      viewModel.updateDeadline(v);
                    }
                  },
                ),
              ],
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: CommunityTheme.danger),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit(BuildContext context) async {
    final mission = await viewModel.submit();
    if (!context.mounted || mission == null) {
      return;
    }
    context.pop(mission.id);
  }
}
