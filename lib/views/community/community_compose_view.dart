import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/app/di/service_locator.dart';
import 'package:picktory/core/theme/picktory_spacing.dart';
import 'package:picktory/core/widgets/picktory_async_state.dart';
import 'package:picktory/core/widgets/program_episode_picker.dart';
import 'package:picktory/models/community_post_kind.dart';
import 'package:picktory/viewmodels/community_compose_view_model.dart';
import 'package:picktory/views/community/community_theme.dart';

/// IA C-5 통합 글 작성 화면
/// 글 종류 칩에 따라 입력 폼이 분기됩니다.
class CommunityComposeView extends StatefulWidget {
  const CommunityComposeView({super.key, required this.viewModel});

  final CommunityComposeViewModel viewModel;

  @override
  State<CommunityComposeView> createState() => _CommunityComposeViewState();
}

class _CommunityComposeViewState extends State<CommunityComposeView> {
  CommunityComposeViewModel get viewModel => widget.viewModel;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<TextEditingController> _choiceControllers = [];

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await viewModel.loadForEdit();
    if (!mounted) return;
    _titleController.text = viewModel.title;
    _contentController.text = viewModel.content;
    _syncChoiceControllers();
    setState(() {});
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
    _contentController.dispose();
    for (final c in _choiceControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final result = await viewModel.submit();
    if (!mounted || result == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${result.kind.label} 글이 게시되었어요')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        _syncChoiceControllers();
        return Scaffold(
          backgroundColor: CommunityTheme.background,
          appBar: AppBar(
            backgroundColor: CommunityTheme.background,
            leading: TextButton(
              onPressed: () => context.pop(),
              child: const Text('취소'),
            ),
            title: Text(viewModel.isEditMode ? '글 수정' : '글 작성'),
            actions: [_PublishButton(viewModel: viewModel, onTap: _submit)],
          ),
          body: viewModel.isLoading
              ? PicktoryAsyncState.loading()
              : ListView(
                  padding: const EdgeInsets.all(PicktorySpacing.md),
                  children: [
                    // 1) 글 종류 칩 (스레드/유저미션/유저투표) — IA 필수
                    if (!viewModel.isEditMode)
                      _PostKindChips(
                        selected: viewModel.kind,
                        onSelected: viewModel.selectKind,
                      ),
                    if (!viewModel.isEditMode)
                      const SizedBox(height: PicktorySpacing.lg),

                    // 2) 카테고리 드롭다운 칩 — IA 필수
                    const _SectionLabel(label: '카테고리', isRequired: true),
                    const SizedBox(height: 8),
                    _CategoryDropdownChip(
                      options: CommunityComposeViewModel.categoryOptions,
                      selected: viewModel.category,
                      onSelected: viewModel.selectCategory,
                    ),
                    const SizedBox(height: PicktorySpacing.lg),

                    // 3) 프로그램·회차 드롭다운 (연결형) — IA 필수
                    const _SectionLabel(
                      label: '프로그램 · 회차',
                      isRequired: true,
                    ),
                    const SizedBox(height: 8),
                    ProgramEpisodePickerChip(
                      selection: viewModel.programEpisode,
                      placeholder: '프로그램과 회차를 선택하세요',
                      tvProgramRepository:
                          ServiceLocator.instance.tvProgramRepository,
                      onChanged: viewModel.selectProgramEpisode,
                    ),
                    const SizedBox(height: PicktorySpacing.lg),

                    // 4) 종류별 폼 — 분기
                    _KindSpecificFields(
                      viewModel: viewModel,
                      titleController: _titleController,
                      contentController: _contentController,
                      choiceControllers: _choiceControllers,
                    ),

                    const SizedBox(height: PicktorySpacing.lg),

                    // 5) 사진 추가 (선택, 최대 5장)
                    _ImagePickerSection(viewModel: viewModel),

                    // 6) 닉네임 공개 (스레드 전용 - UI는 모든 종류에 표시)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('닉네임 공개'),
                      subtitle: const Text("비공개 시 '익명'으로 표시"),
                      value: viewModel.showNickname,
                      activeThumbColor: CommunityTheme.yellow,
                      onChanged: viewModel.toggleShowNickname,
                    ),

                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(color: CommunityTheme.danger),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class _PublishButton extends StatelessWidget {
  const _PublishButton({required this.viewModel, required this.onTap});

  final CommunityComposeViewModel viewModel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = viewModel.canSubmit;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: enabled
                ? const Color(0xFFFF6B00)
                : CommunityTheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            viewModel.isSubmitting ? '게시 중' : '게시하기',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: enabled ? Colors.white : CommunityTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _PostKindChips extends StatelessWidget {
  const _PostKindChips({required this.selected, required this.onSelected});

  final CommunityPostKind selected;
  final ValueChanged<CommunityPostKind> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: CommunityPostKind.values.map((kind) {
        final isSelected = selected == kind;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelected(kind),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFEDD8)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF6B00)
                      : const Color(0xFFE0E0E0),
                  width: 1.4,
                ),
              ),
              child: Text(
                kind.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFFD25400)
                      : CommunityTheme.textPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CategoryDropdownChip extends StatelessWidget {
  const _CategoryDropdownChip({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (_) => options
          .map(
            (option) => PopupMenuItem<String>(
              value: option,
              child: Text(option),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PicktorySpacing.md,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected != null
                ? const Color(0xFFFF6B00)
                : const Color(0xFFE0E0E0),
            width: selected != null ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selected ?? '카테고리 선택',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected != null
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: selected != null
                      ? CommunityTheme.textPrimary
                      : const Color(0xFF9E9E9E),
                ),
              ),
            ),
            const Icon(
              Icons.expand_more_rounded,
              color: Color(0xFF9E9E9E),
            ),
          ],
        ),
      ),
    );
  }
}

class _KindSpecificFields extends StatelessWidget {
  const _KindSpecificFields({
    required this.viewModel,
    required this.titleController,
    required this.contentController,
    required this.choiceControllers,
  });

  final CommunityComposeViewModel viewModel;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final List<TextEditingController> choiceControllers;

  @override
  Widget build(BuildContext context) {
    switch (viewModel.kind) {
      case CommunityPostKind.thread:
        return _ThreadFields(
          viewModel: viewModel,
          titleController: titleController,
          contentController: contentController,
        );
      case CommunityPostKind.userMission:
        return _UserMissionFields(
          viewModel: viewModel,
          titleController: titleController,
          choiceControllers: choiceControllers,
        );
      case CommunityPostKind.userPoll:
        return _UserPollFields(
          viewModel: viewModel,
          titleController: titleController,
          choiceControllers: choiceControllers,
        );
    }
  }
}

class _ThreadFields extends StatelessWidget {
  const _ThreadFields({
    required this.viewModel,
    required this.titleController,
    required this.contentController,
  });

  final CommunityComposeViewModel viewModel;
  final TextEditingController titleController;
  final TextEditingController contentController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(label: '제목', isRequired: true),
        const SizedBox(height: 8),
        TextField(
          controller: titleController,
          onChanged: viewModel.updateTitle,
          decoration: const InputDecoration(hintText: '제목을 입력해주세요'),
          maxLength: CommunityComposeViewModel.maxTitleLength,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
              CommunityComposeViewModel.maxTitleLength,
            ),
          ],
        ),
        const SizedBox(height: PicktorySpacing.md),
        const _SectionLabel(label: '내용', isRequired: true),
        const SizedBox(height: 8),
        TextField(
          controller: contentController,
          onChanged: viewModel.updateContent,
          decoration: const InputDecoration(
            hintText: '이 미션에 대한 생각을 자유롭게 적어주세요...',
          ),
          maxLines: 8,
          maxLength: CommunityComposeViewModel.maxContentLength,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
              CommunityComposeViewModel.maxContentLength,
            ),
          ],
        ),
      ],
    );
  }
}

class _UserMissionFields extends StatelessWidget {
  const _UserMissionFields({
    required this.viewModel,
    required this.titleController,
    required this.choiceControllers,
  });

  final CommunityComposeViewModel viewModel;
  final TextEditingController titleController;
  final List<TextEditingController> choiceControllers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel(label: '마감 시간', isRequired: true),
        const SizedBox(height: 8),
        _DeadlineDropdown(viewModel: viewModel),
        const SizedBox(height: PicktorySpacing.md),
        const _SectionLabel(label: '미션 제목', isRequired: true),
        const SizedBox(height: 8),
        TextField(
          controller: titleController,
          onChanged: viewModel.updateTitle,
          decoration: const InputDecoration(
            hintText: '예: 5화 마지막 커플 예측',
          ),
        ),
        const SizedBox(height: PicktorySpacing.md),
        _ChoiceFields(
          viewModel: viewModel,
          controllers: choiceControllers,
          sectionLabel: '선택지',
        ),
      ],
    );
  }
}

class _UserPollFields extends StatelessWidget {
  const _UserPollFields({
    required this.viewModel,
    required this.titleController,
    required this.choiceControllers,
  });

  final CommunityComposeViewModel viewModel;
  final TextEditingController titleController;
  final List<TextEditingController> choiceControllers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: CommunityTheme.notice,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            '유저 투표는 마감일 없이 상시 운영되며, 투표 즉시 결과가 공개됩니다.',
            style: TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: PicktorySpacing.md),
        const _SectionLabel(label: '투표 제목', isRequired: true),
        const SizedBox(height: 8),
        TextField(
          controller: titleController,
          onChanged: viewModel.updateTitle,
          decoration: const InputDecoration(
            hintText: '예: 시즌 베스트 캐릭터는?',
          ),
        ),
        const SizedBox(height: PicktorySpacing.md),
        _ChoiceFields(
          viewModel: viewModel,
          controllers: choiceControllers,
          sectionLabel: '투표 항목',
        ),
      ],
    );
  }
}

class _DeadlineDropdown extends StatelessWidget {
  const _DeadlineDropdown({required this.viewModel});

  final CommunityComposeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final selected = viewModel.deadlineLabel;
    return PopupMenuButton<String>(
      onSelected: viewModel.selectDeadline,
      itemBuilder: (_) => CommunityComposeViewModel.deadlineOptions
          .map(
            (option) => PopupMenuItem<String>(
              value: option,
              child: Text(option),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PicktorySpacing.md,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected != null
                ? const Color(0xFFFF6B00)
                : const Color(0xFFE0E0E0),
            width: selected != null ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.schedule_rounded,
              size: 18,
              color: Color(0xFF9E9E9E),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selected ?? '마감 시간을 선택하세요',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected != null
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: selected != null
                      ? CommunityTheme.textPrimary
                      : const Color(0xFF9E9E9E),
                ),
              ),
            ),
            const Icon(
              Icons.expand_more_rounded,
              color: Color(0xFF9E9E9E),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceFields extends StatelessWidget {
  const _ChoiceFields({
    required this.viewModel,
    required this.controllers,
    required this.sectionLabel,
  });

  final CommunityComposeViewModel viewModel;
  final List<TextEditingController> controllers;
  final String sectionLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: sectionLabel, isRequired: true),
        const SizedBox(height: 4),
        Text(
          'A·B는 필수이며 최대 ${CommunityComposeViewModel.maxChoiceCount}개까지 추가할 수 있어요',
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF757575),
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < viewModel.choices.length; i++)
          _ChoiceRow(
            index: i,
            controller: controllers[i],
            initialText: viewModel.choices[i],
            onChanged: (value) => viewModel.updateChoice(i, value),
            onRemove: viewModel.canRemoveChoice && i >= 2
                ? () => viewModel.removeChoice(i)
                : null,
          ),
        if (viewModel.canAddChoice)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: viewModel.addChoice,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('선택지 추가'),
            ),
          ),
      ],
    );
  }
}

class _ChoiceRow extends StatefulWidget {
  const _ChoiceRow({
    required this.index,
    required this.controller,
    required this.initialText,
    required this.onChanged,
    this.onRemove,
  });

  final int index;
  final TextEditingController controller;
  final String initialText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onRemove;

  @override
  State<_ChoiceRow> createState() => _ChoiceRowState();
}

class _ChoiceRowState extends State<_ChoiceRow> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.text != widget.initialText) {
      widget.controller.text = widget.initialText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final letter = String.fromCharCode('A'.codeUnitAt(0) + widget.index);
    final isRequired = widget.index < 2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: isRequired
                    ? '선택지 $letter (필수)'
                    : '선택지 $letter (선택)',
                isDense: true,
              ),
            ),
          ),
          if (widget.onRemove != null)
            IconButton(
              onPressed: widget.onRemove,
              icon: const Icon(Icons.remove_circle_outline, size: 20),
              color: const Color(0xFF9E9E9E),
            ),
        ],
      ),
    );
  }
}

class _ImagePickerSection extends StatelessWidget {
  const _ImagePickerSection({required this.viewModel});

  final CommunityComposeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final images = viewModel.imageAssetIds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📷 사진 추가 (선택 · 최대 ${CommunityComposeViewModel.maxImageCount}장)',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length + (viewModel.canAddImage ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == images.length) {
                return _AddImageTile(
                  onTap: () {
                    // 실제 카메라/앨범 연동은 Phase 5에서 permission_handler+image_picker로 처리
                    final placeholder =
                        'image-${DateTime.now().millisecondsSinceEpoch}';
                    viewModel.addImage(placeholder);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('이미지 선택은 곧 제공될 예정입니다'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              }
              return _ImageTile(
                onRemove: () => viewModel.removeImage(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AddImageTile extends StatelessWidget {
  const _AddImageTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: const Icon(
          Icons.add_a_photo_outlined,
          color: Color(0xFF9E9E9E),
        ),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({required this.onRemove});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.image_outlined,
            color: Color(0xFF9E9E9E),
          ),
        ),
        Positioned(
          right: 2,
          top: 2,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onRemove,
              child: const Padding(
                padding: EdgeInsets.all(2),
                child: Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.isRequired = false});

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE53935),
            ),
          ),
        ],
      ],
    );
  }
}
