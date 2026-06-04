import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/terms_view_model.dart';
import 'package:picktory/views/my/widgets/static_document_view.dart';
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
                onViewTap: () => _openTermsDocument(context, _termsDocument),
              ),
              _TermsTile(
                value: consent.agreedToPrivacy,
                onChanged: (v) =>
                    viewModel.toggleRequired(agreedToPrivacy: v ?? false),
                title: '[필수] 개인정보 수집 및 이용 동의',
                onViewTap: () => _openTermsDocument(context, _privacyDocument),
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
    this.onViewTap,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String title;
  final VoidCallback? onViewTap;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      title: Row(
        children: [
          Expanded(child: Text(title)),
          if (onViewTap != null)
            TextButton(
              onPressed: onViewTap,
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

/// IA O-3: 약관 전문 팝업 — 전체 화면 모달로 띄움
void _openTermsDocument(
  BuildContext context,
  StaticDocumentView document,
) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => document,
      fullscreenDialog: true,
    ),
  );
}

const StaticDocumentView _termsDocument = StaticDocumentView(
  title: '서비스 이용약관',
  sections: [
    StaticDocumentSection(
      heading: '제1조 목적',
      body: '본 약관은 픽토리(이하 "서비스")의 이용과 관련하여 회사와 회원 간의 권리·의무 및 책임사항을 규정합니다.',
    ),
    StaticDocumentSection(
      heading: '제2조 용어 정의',
      body: '"회원"이라 함은 본 약관에 동의하고 서비스를 이용하는 자를 의미합니다.',
    ),
    StaticDocumentSection(
      heading: '제3조 약관의 효력 및 변경',
      body: '본 약관은 서비스를 이용하는 모든 회원에게 적용되며, 회사는 필요 시 약관을 변경할 수 있습니다.',
    ),
  ],
);

const StaticDocumentView _privacyDocument = StaticDocumentView(
  title: '개인정보 수집 및 이용 동의',
  sections: [
    StaticDocumentSection(
      heading: '수집 항목',
      body: '소셜 로그인 식별자, 닉네임, 프로필 이미지, 성별, 생년월일을 수집합니다.',
    ),
    StaticDocumentSection(
      heading: '이용 목적',
      body: '회원 식별, 서비스 제공, 통계 분석, 부정 이용 방지에 활용됩니다.',
    ),
    StaticDocumentSection(
      heading: '보관 기간',
      body: '회원 탈퇴 시 즉시 파기됩니다. 단, 관련 법령에 따라 일정 기간 보관이 필요한 경우 해당 법령에 따릅니다.',
    ),
  ],
);
