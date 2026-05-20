import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/invite_code_view_model.dart';
import 'package:picktory/views/onboarding/onboarding_theme.dart';
import 'package:picktory/views/onboarding/widgets/onboarding_primary_button.dart';
import 'package:picktory/views/onboarding/widgets/onboarding_scaffold.dart';

class InviteCodeView extends StatelessWidget {
  const InviteCodeView({super.key, required this.viewModel});

  final InviteCodeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return OnboardingScaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: OnboardingTheme.yellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🎁', style: TextStyle(fontSize: 24)),
                      const SizedBox(height: 8),
                      Text(
                        viewModel.rewardTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        viewModel.rewardSubtitle,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '초대 코드',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    hintText: '코드 5자리 입력 (대문자)',
                  ),
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 5,
                  onChanged: viewModel.updateCode,
                ),
                if (viewModel.errorMessage != null)
                  Text(
                    viewModel.errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                if (viewModel.successMessage != null)
                  Text(
                    viewModel.successMessage!,
                    style: const TextStyle(color: Colors.green),
                  ),
              ],
            ),
          ),
          bottom: OnboardingPrimaryButton(
            label: viewModel.isApplying
                ? '적용 중...'
                : viewModel.successMessage != null
                    ? '다음'
                    : '코드 적용하기',
            enabled: viewModel.successMessage != null || viewModel.canApply,
            onPressed: () async {
              if (viewModel.successMessage != null) {
                if (context.mounted) {
                  context.go(AppRoute.signupComplete.path);
                }
                return;
              }
              final ok = await viewModel.applyCode();
              if (!context.mounted || !ok) {
                return;
              }
              context.go(AppRoute.signupComplete.path);
            },
          ),
        );
      },
    );
  }
}
