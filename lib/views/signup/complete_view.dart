import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/viewmodels/onboarding_complete_view_model.dart';
import 'package:picktory/views/widgets/wireframe_button.dart';

class OnboardingCompleteView extends StatefulWidget {
  const OnboardingCompleteView({super.key, required this.viewModel});

  final OnboardingCompleteViewModel viewModel;

  @override
  State<OnboardingCompleteView> createState() => _OnboardingCompleteViewState();
}

class _OnboardingCompleteViewState extends State<OnboardingCompleteView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(viewModel.subtitle),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _CoinCard(
                          amount: '${viewModel.baseCoins}',
                          label: '가입 보상 코인',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CoinCard(
                          amount: '+${viewModel.bonusCoins}',
                          label: '초대코드 보너스',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('총 ${viewModel.totalCoins}코인 지급 완료! 🎁'),
                  if (viewModel.errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      viewModel.errorMessage!,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 24),
                  WireframeButton(
                    label: viewModel.isCompleting
                        ? '처리 중...'
                        : '미션 시작하기',
                    enabled: !viewModel.isCompleting,
                    onPressed: () async {
                      final ok = await viewModel.completeOnboarding();
                      if (!context.mounted || !ok) {
                        return;
                      }
                      context.go(AppRoute.home.path);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CoinCard extends StatelessWidget {
  const _CoinCard({required this.amount, required this.label});

  final String amount;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(amount, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
