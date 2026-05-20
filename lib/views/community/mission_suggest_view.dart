import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/viewmodels/mission_suggest_view_model.dart';
import 'package:picktory/views/community/community_theme.dart';
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
          showBackButton: true,
          topTrailing: viewModel.isSubmitting
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
                  onPressed: viewModel.canSubmit
                      ? () => _submit(context)
                      : null,
                  child: const Text('제출'),
                ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CommunityTheme.notice,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '운영팀의 검토 후 미션으로 등록해드려요. 채택 시 추가 포인트가 지급됩니다 🤩',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: viewModel.programLabel,
                decoration: const InputDecoration(labelText: '프로그램'),
                items: const [
                  DropdownMenuItem(
                    value: '환승연애4',
                    child: Text('환승연애4'),
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
                decoration: const InputDecoration(
                  labelText: '회차',
                  hintText: '예: 5화, 마지막화',
                ),
                onChanged: viewModel.updateEpisode,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: '미션 제목 *',
                  hintText: '예: 5화 마지막 커플은 누구?',
                ),
                onChanged: viewModel.updateTitle,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'A. 선택지 입력 *',
                ),
                onChanged: viewModel.updateChoiceA,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'B. 선택지 입력 *',
                ),
                onChanged: viewModel.updateChoiceB,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'C. 선택지 입력 (선택)',
                ),
                onChanged: viewModel.updateChoiceC,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('선택지 추가'),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: '예상 마감 시점 (선택)',
                  hintText: '날짜 직접 입력',
                ),
                onChanged: viewModel.updateExpectedClose,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: '추가 설명 (선택)',
                  hintText: '미션 배경 또는 참고할 내용을 적어주세요',
                ),
                maxLines: 4,
                onChanged: viewModel.updateDescription,
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: '결과 확인 가능한 출처 (선택)',
                  hintText: '예: OTT 스트리밍',
                ),
                onChanged: viewModel.updateResultSource,
              ),
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: CommunityTheme.danger),
                ),
            ],
          ),
          bottom: WireframeButton(
            label: viewModel.isSubmitting ? '제출 중...' : '건의 제출하기',
            enabled: viewModel.canSubmit,
            onPressed: () => _submit(context),
          ),
        );
      },
    );
  }

  Future<void> _submit(BuildContext context) async {
    final ok = await viewModel.submit();
    if (!context.mounted || !ok) {
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('건의 완료'),
        content: const Text(
          '검토 후 미션으로 등록됩니다. 채택 시 추가 포인트가 지급됩니다.',
        ),
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
  }
}
