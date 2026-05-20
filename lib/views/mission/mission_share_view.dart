import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/viewmodels/mission_share_view_model.dart';
import 'package:picktory/views/home/home_theme.dart';
import 'package:picktory/views/mission/widgets/mission_scaffold.dart';
import 'package:picktory/views/mission/widgets/mission_yellow_button.dart';

class MissionShareView extends StatefulWidget {
  const MissionShareView({super.key, required this.viewModel});

  final MissionShareViewModel viewModel;

  @override
  State<MissionShareView> createState() => _MissionShareViewState();
}

class _MissionShareViewState extends State<MissionShareView> {
  MissionShareViewModel get viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    viewModel.load();
  }

  Future<void> _submit() async {
    final ok = await viewModel.submit();
    if (!mounted || !ok) {
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final result = viewModel.result;

        return MissionScaffold(
          title: '스레드에 공유',
          bottom: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: MissionYellowButton(
                label: '스레드에 생성하기',
                enabled: viewModel.canSubmit,
                onPressed: _submit,
              ),
            ),
          ),
          body: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (result != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: HomeTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.title,
                              style: const TextStyle(
                                color: HomeTheme.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '내 선택: ${result.userChoice.label}',
                              style: const TextStyle(
                                color: HomeTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: viewModel.updateContent,
                      maxLines: 5,
                      style: const TextStyle(color: HomeTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: '이곳에 공유하고 싶은 생각을 적어주세요...',
                        hintStyle: const TextStyle(
                          color: HomeTheme.textSecondary,
                        ),
                        filled: true,
                        fillColor: HomeTheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: viewModel.category,
                      dropdownColor: HomeTheme.surface,
                      style: const TextStyle(color: HomeTheme.textPrimary),
                      decoration: InputDecoration(
                        labelText: '카테고리',
                        labelStyle: const TextStyle(
                          color: HomeTheme.textSecondary,
                        ),
                        filled: true,
                        fillColor: HomeTheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: viewModel.categories
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          viewModel.updateCategory(value);
                        }
                      },
                    ),
                  ],
                ),
        );
      },
    );
  }
}
