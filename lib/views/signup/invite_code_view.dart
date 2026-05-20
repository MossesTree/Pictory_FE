import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/invite_code_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';
import 'package:picktory/views/widgets/wireframe_scaffold.dart';

class InviteCodeView extends StatelessWidget {
  const InviteCodeView({super.key, required this.viewModel});

  final InviteCodeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return WireframeScaffold(
          title: viewModel.title,
          subtitle: viewModel.subtitle,
          topTrailing: TextButton(
            onPressed: () async {
              await viewModel.skip();
              if (!context.mounted) {
                return;
              }
              context.go(AppRoute.signupComplete.path);
            },
            child: const Text('건너뛰기'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🎁'),
                Text(viewModel.rewardHint),
                Text('예: ${viewModel.codeExample}'),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: '초대 코드',
                    hintText: '코드 8자리 입력 (대문자)',
                  ),
                  onChanged: viewModel.updateCode,
                ),
                if (viewModel.errorMessage != null)
                  Text(
                    viewModel.errorMessage!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                if (viewModel.successMessage != null)
                  Text(viewModel.successMessage!),
                const SizedBox(height: 16),
                WireframeButton(
                  label: viewModel.isApplying ? '적용 중...' : '코드 적용하기',
                  enabled: viewModel.canApply,
                  onPressed: () => viewModel.applyCode(),
                ),
              ],
            ),
          ),
          bottom: WireframeButton(
            label: '다음',
            onPressed: () => context.go(AppRoute.signupComplete.path),
          ),
        );
      },
    );
  }
}
