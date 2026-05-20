import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/terms_view_model.dart';
import 'package:picktory/views/onboarding/onboarding_theme.dart';
import 'package:picktory/views/onboarding/widgets/onboarding_primary_button.dart';
import 'package:picktory/views/onboarding/widgets/onboarding_scaffold.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key, required this.viewModel});

  final TermsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final consent = viewModel.consent;
        return OnboardingScaffold(
          title: viewModel.title,
          subtitle: viewModel.subtitle,
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: OnboardingTheme.black, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CheckboxListTile(
                  value: consent.allAgreed,
                  onChanged: (v) => viewModel.toggleAll(v ?? false),
                  title: const Text(
                    '전체 동의',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              const SizedBox(height: 16),
              _TermsTile(
                value: consent.isOver14,
                onChanged: (v) => viewModel.toggleRequired(isOver14: v ?? false),
                title: '[필수] 만 14세 이상입니다',
              ),
              _TermsTile(
                value: consent.agreedToTerms,
                onChanged: (v) =>
                    viewModel.toggleRequired(agreedToTerms: v ?? false),
                title: '[필수] 이용약관 동의',
                showViewLink: true,
              ),
              _TermsTile(
                value: consent.agreedToPrivacy,
                onChanged: (v) =>
                    viewModel.toggleRequired(agreedToPrivacy: v ?? false),
                title: '[필수] 개인정보 수집 및 이용 동의',
                showViewLink: true,
              ),
              _TermsTile(
                value: consent.agreedToMarketing,
                onChanged: (v) =>
                    viewModel.toggleOptional(agreedToMarketing: v ?? false),
                title: '[선택] 마케팅 정보 수신 동의',
              ),
              _TermsTile(
                value: consent.agreedToNightPush,
                onChanged: (v) =>
                    viewModel.toggleOptional(agreedToNightPush: v ?? false),
                title: '[선택] 야간 푸시 알림 동의',
              ),
              if (viewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    viewModel.errorMessage!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
            ],
          ),
          bottom: OnboardingPrimaryButton(
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

class _TermsTile extends StatelessWidget {
  const _TermsTile({
    required this.value,
    required this.onChanged,
    required this.title,
    this.showViewLink = false,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String title;
  final bool showViewLink;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      title: Row(
        children: [
          Expanded(child: Text(title)),
          if (showViewLink)
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('보기', style: TextStyle(fontSize: 13)),
            ),
        ],
      ),
    );
  }
}
