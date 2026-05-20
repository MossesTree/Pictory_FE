import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/terms_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';
import 'package:picktory/views/widgets/wireframe_scaffold.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key, required this.viewModel});

  final TermsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final consent = viewModel.consent;
        return WireframeScaffold(
          title: viewModel.title,
          subtitle: viewModel.subtitle,
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              CheckboxListTile(
                value: consent.allAgreed,
                onChanged: (v) => viewModel.toggleAll(v ?? false),
                title: const Text('전체 동의'),
              ),
              CheckboxListTile(
                value: consent.isOver14,
                onChanged: (v) =>
                    viewModel.toggleRequired(isOver14: v ?? false),
                title: const Text('[필수] 만 14세 이상입니다'),
              ),
              CheckboxListTile(
                value: consent.agreedToTerms,
                onChanged: (v) =>
                    viewModel.toggleRequired(agreedToTerms: v ?? false),
                title: const Text('[필수] 이용약관 동의'),
              ),
              CheckboxListTile(
                value: consent.agreedToPrivacy,
                onChanged: (v) =>
                    viewModel.toggleRequired(agreedToPrivacy: v ?? false),
                title: const Text('[필수] 개인정보 수집·이용 동의'),
              ),
              CheckboxListTile(
                value: consent.agreedToMarketing,
                onChanged: (v) =>
                    viewModel.toggleOptional(agreedToMarketing: v ?? false),
                title: const Text('[선택] 마케팅 정보 수신 동의'),
              ),
              CheckboxListTile(
                value: consent.agreedToNightPush,
                onChanged: (v) =>
                    viewModel.toggleOptional(agreedToNightPush: v ?? false),
                title: const Text('[선택] 야간 푸시 알림 동의'),
              ),
              if (viewModel.errorMessage != null)
                Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
          bottom: WireframeButton(
            label: viewModel.isSaving ? '저장 중...' : '동의하고 시작하기',
            enabled: viewModel.canProceed,
            onPressed: () async {
              final ok = await viewModel.saveAndProceed();
              if (!context.mounted || !ok) {
                return;
              }
              context.go(AppRoute.signupProfile.path);
            },
          ),
        );
      },
    );
  }
}
