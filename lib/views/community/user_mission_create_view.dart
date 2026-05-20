import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/models/user_mission.dart';
import 'package:picktory/viewmodels/user_mission_create_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';
import 'package:picktory/views/widgets/wireframe_scaffold.dart';

class UserMissionCreateView extends StatelessWidget {
  const UserMissionCreateView({super.key, required this.viewModel});

  final UserMissionCreateViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return WireframeScaffold(
          title: '유저 미션 올리기',
          showBackButton: true,
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
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
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: viewModel.programLabel,
                decoration: const InputDecoration(labelText: '프로그램 *'),
                items: const [
                  DropdownMenuItem(
                    value: '환승연애4 · 5화',
                    child: Text('환승연애4 · 5화'),
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
                decoration: const InputDecoration(labelText: '설명'),
                maxLines: 3,
                onChanged: viewModel.updateDescription,
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
              if (viewModel.type == UserMissionType.mission) ...[
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '마감 시간 * (미션형 필수)',
                  ),
                  onChanged: viewModel.updateDeadline,
                ),
              ],
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
          bottom: WireframeButton(
            label: viewModel.isSubmitting ? '등록 중...' : '등록하기',
            enabled: viewModel.canSubmit,
            onPressed: () async {
              final mission = await viewModel.submit();
              if (!context.mounted || mission == null) {
                return;
              }
              await showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('등록 완료'),
                  content: const Text('작성한 유저 미션으로 이동할 수 있습니다.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
              if (context.mounted) {
                context.pop(mission.id);
              }
            },
          ),
        );
      },
    );
  }
}
