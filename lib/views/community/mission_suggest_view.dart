import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/viewmodels/mission_suggest_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';
import 'package:picktory/views/widgets/wireframe_scaffold.dart';

class MissionSuggestView extends StatelessWidget {
  const MissionSuggestView({super.key, required this.viewModel});

  final MissionSuggestViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return WireframeScaffold(
          title: '미션 건의하기',
          subtitle: '운영팀이 검토 후 미션으로 등록해드려요.',
          showBackButton: true,
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              DropdownButtonFormField<String>(
                initialValue: viewModel.programLabel,
                decoration: const InputDecoration(labelText: '프로그램'),
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
                decoration: const InputDecoration(
                  labelText: '미션 배경 또는 참고할 내용',
                ),
                maxLines: 4,
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
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
          bottom: WireframeButton(
            label: viewModel.isSubmitting ? '제출 중...' : '건의 제출하기',
            enabled: viewModel.canSubmit,
            onPressed: () async {
              final ok = await viewModel.submit();
              if (!context.mounted || !ok) {
                return;
              }
              await showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('건의 완료'),
                  content: const Text('검토 후 미션으로 등록됩니다. 채택 시 추가 포인트가 지급됩니다.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
              if (context.mounted) {
                context.pop();
              }
            },
          ),
        );
      },
    );
  }
}
