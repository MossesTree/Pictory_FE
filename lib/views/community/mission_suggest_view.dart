import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/core/widgets/program_episode_picker.dart';
import 'package:picktory/viewmodels/mission_suggest_view_model.dart';
import 'package:picktory/views/mission/mission_theme.dart';
import 'package:picktory/views/mission/widgets/mission_form_widgets.dart';

/// IA M-5 미션 건의하기 (Figma 543:891)
class MissionSuggestView extends StatefulWidget {
  const MissionSuggestView({super.key, required this.viewModel});

  final MissionSuggestViewModel viewModel;

  @override
  State<MissionSuggestView> createState() => _MissionSuggestViewState();
}

class _MissionSuggestViewState extends State<MissionSuggestView> {
  MissionSuggestViewModel get viewModel => widget.viewModel;
  final List<TextEditingController> _choiceControllers = [];
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncChoiceControllers();
  }

  void _syncChoiceControllers() {
    while (_choiceControllers.length < viewModel.choices.length) {
      _choiceControllers.add(TextEditingController());
    }
    while (_choiceControllers.length > viewModel.choices.length) {
      _choiceControllers.removeLast().dispose();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _choiceControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await viewModel.submit();
    if (!mounted || !ok) {
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('건의 완료'),
        content: const Text(
          '검토 후 미션으로 등록됩니다.\n채택 시 30 Pick과 함께 참여 권한이 지급됩니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('확인'),
          ),
        ],
      ),
    );
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        _syncChoiceControllers();

        return Scaffold(
          backgroundColor: MissionTheme.background,
          appBar: const MissionFormAppBar(title: '미션 건의하기'),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MissionSuggestTermsBox(),
                  const SizedBox(height: 12),
                  MissionFormSubmitButton(
                    label: viewModel.isSubmitting ? '제출 중...' : '건의하기',
                    enabled: viewModel.canSubmit,
                    partial: viewModel.hasPartialProgress,
                    isLoading: viewModel.isSubmitting,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const Text(
                '원하는 미션을 제안해보세요',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: MissionTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '채택 시 보너스 Pick 지급!',
                style: TextStyle(
                  fontSize: 13,
                  color: MissionTheme.textSecondary,
                ),
              ),
              const SizedBox(height: PicktorySpacing.lg),
              const MissionFormSectionLabel(
                label: '카테고리',
                isRequired: true,
              ),
              const SizedBox(height: 8),
              MissionCategoryChips(
                options: MissionSuggestViewModel.categoryOptions,
                selected: viewModel.selectedCategory,
                onSelected: viewModel.selectCategory,
              ),
              const SizedBox(height: PicktorySpacing.lg),
              const MissionFormSectionLabel(
                label: '프로그램 · 회차',
                isRequired: true,
              ),
              const SizedBox(height: 8),
              ProgramEpisodePickerSplit(
                selection: viewModel.programEpisode,
                tvProgramRepository:
                    ServiceLocator.instance.tvProgramRepository,
                onChanged: viewModel.selectProgramEpisode,
              ),
              const SizedBox(height: PicktorySpacing.lg),
              const MissionFormSectionLabel(
                label: '미션 제목',
                isRequired: true,
              ),
              const SizedBox(height: 8),
              MissionOutlineTextField(
                controller: _titleController,
                hintText: '예) 5화 마지막 커플은 누구?',
                onChanged: viewModel.updateTitle,
              ),
              const SizedBox(height: PicktorySpacing.lg),
              const MissionFormSectionLabel(
                label: '예상 선택지',
                isRequired: true,
              ),
              const SizedBox(height: 8),
              for (var i = 0; i < viewModel.choices.length; i++)
                _ChoiceField(
                  index: i,
                  controller: _choiceControllers[i],
                  initialText: viewModel.choices[i],
                  onChanged: (value) => viewModel.updateChoice(i, value),
                  onClear: viewModel.choices[i].trim().isNotEmpty
                      ? () {
                          _choiceControllers[i].clear();
                          viewModel.updateChoice(i, '');
                        }
                      : null,
                ),
              if (viewModel.canAddChoice) ...[
                const SizedBox(height: 4),
                MissionAddChoiceButton(onPressed: viewModel.addChoice),
              ],
              if (viewModel.errorMessage != null) ...[
                const SizedBox(height: PicktorySpacing.sm),
                Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: MissionTheme.countdown),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ChoiceField extends StatefulWidget {
  const _ChoiceField({
    required this.index,
    required this.controller,
    required this.initialText,
    required this.onChanged,
    this.onClear,
  });

  final int index;
  final TextEditingController controller;
  final String initialText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  @override
  State<_ChoiceField> createState() => _ChoiceFieldState();
}

class _ChoiceFieldState extends State<_ChoiceField> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.text != widget.initialText) {
      widget.controller.text = widget.initialText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hints = [
      '예) 수지 & 현준',
      '예) 민이 & 재준',
      '예) 선택지 입력',
    ];
    final hint = widget.index < hints.length
        ? hints[widget.index]
        : '예) 선택지 입력';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MissionOutlineTextField(
        controller: widget.controller,
        hintText: hint,
        onChanged: widget.onChanged,
        suffixIcon: widget.onClear != null
            ? IconButton(
                onPressed: widget.onClear,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: MissionTheme.textTertiary,
                ),
              )
            : null,
      ),
    );
  }
}
