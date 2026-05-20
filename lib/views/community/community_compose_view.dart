import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/viewmodels/community_compose_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';
import 'package:picktory/views/widgets/wireframe_scaffold.dart';

class CommunityComposeView extends StatefulWidget {
  const CommunityComposeView({super.key, required this.viewModel});

  final CommunityComposeViewModel viewModel;

  @override
  State<CommunityComposeView> createState() => _CommunityComposeViewState();
}

class _CommunityComposeViewState extends State<CommunityComposeView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadForEdit();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return WireframeScaffold(
          title: viewModel.isEditMode ? '글 수정' : '글 작성',
          showBackButton: true,
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
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
                      decoration: InputDecoration(
                        labelText: '제목',
                        hintText: viewModel.title.isEmpty ? '제목 입력' : null,
                      ),
                      onChanged: viewModel.updateTitle,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: '내용',
                        hintText: '이 미션에 대한 생각을 자유롭게 적어주세요...',
                      ),
                      maxLines: 6,
                      onChanged: viewModel.updateContent,
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('닉네임 공개'),
                      subtitle: const Text('OFF 시 익명으로 게시'),
                      value: viewModel.showNickname,
                      onChanged: viewModel.toggleShowNickname,
                    ),
                    if (viewModel.errorMessage != null)
                      Text(
                        viewModel.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
          bottom: WireframeButton(
            label: viewModel.isSubmitting ? '게시 중...' : '게시하기',
            enabled: viewModel.canSubmit,
            onPressed: () async {
              final post = await viewModel.submit();
              if (!context.mounted || post == null) {
                return;
              }
              context.pop();
            },
          ),
        );
      },
    );
  }
}
