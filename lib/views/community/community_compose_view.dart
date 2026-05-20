import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/viewmodels/community_compose_view_model.dart';
import 'package:picktory/views/community/community_theme.dart';

class CommunityComposeView extends StatefulWidget {
  const CommunityComposeView({super.key, required this.viewModel});

  final CommunityComposeViewModel viewModel;

  @override
  State<CommunityComposeView> createState() => _CommunityComposeViewState();
}

class _CommunityComposeViewState extends State<CommunityComposeView> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _loadEdit();
  }

  Future<void> _loadEdit() async {
    await widget.viewModel.loadForEdit();
    if (!mounted) {
      return;
    }
    _titleController.text = widget.viewModel.title;
    _contentController.text = widget.viewModel.content;
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

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
            title: Text(viewModel.isEditMode ? '글 수정' : '글 작성'),
            actions: [
              TextButton(
                onPressed: viewModel.canSubmit
                    ? () async {
                        final post = await viewModel.submit();
                        if (context.mounted && post != null) {
                          context.pop();
                        }
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: viewModel.canSubmit
                        ? CommunityTheme.yellow
                        : CommunityTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    viewModel.isSubmitting ? '게시 중' : '게시',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: CommunityTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: viewModel.programLabel,
                      decoration: const InputDecoration(
                        labelText: '카테고리',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: '환승연애4 · 5화',
                          child: Text('환승연애4'),
                        ),
                        DropdownMenuItem(
                          value: '나는솔로 · 10기',
                          child: Text('나는솔로'),
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
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: '제목 *',
                        hintText: '제목을 입력해주세요',
                      ),
                      onChanged: viewModel.updateTitle,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: '내용 *',
                        hintText: '이 미션에 대한 생각을 자유롭게 적어주세요...',
                      ),
                      maxLines: 8,
                      onChanged: viewModel.updateContent,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${viewModel.content.length} / ${CommunityComposeViewModel.maxContentLength}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: CommunityTheme.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '이미지 (선택 · 최대 3장)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: CommunityTheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: CommunityTheme.border),
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('닉네임 공개'),
                      subtitle: const Text("비공개 시 '익명'으로 표시"),
                      value: viewModel.showNickname,
                      activeThumbColor: CommunityTheme.yellow,
                      onChanged: viewModel.toggleShowNickname,
                    ),
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
}
