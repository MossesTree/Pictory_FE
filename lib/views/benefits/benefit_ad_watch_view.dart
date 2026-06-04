import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/viewmodels/benefit_ad_watch_view_model.dart';
import 'package:picktory/views/benefits/benefit_theme.dart';

class BenefitAdWatchView extends StatefulWidget {
  const BenefitAdWatchView({
    super.key,
    required this.viewModel,
    required this.rewardPicks,
  });

  final BenefitAdWatchViewModel viewModel;
  final int rewardPicks;

  @override
  State<BenefitAdWatchView> createState() => _BenefitAdWatchViewState();
}

class _BenefitAdWatchViewState extends State<BenefitAdWatchView> {
  bool _didPopWithReward = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
    widget.viewModel.start();
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (!widget.viewModel.isCompleted || _didPopWithReward || !mounted) {
      return;
    }
    _didPopWithReward = true;
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.pop(widget.rewardPicks);
      }
    });
  }

  void _closeWithoutReward() {
    context.pop();
  }

  void _onSkipOrComplete() {
    if (widget.viewModel.isCompleted) {
      context.pop(widget.rewardPicks);
      return;
    }
    if (widget.viewModel.canSkip) {
      _closeWithoutReward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final vm = widget.viewModel;

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
                  child: Row(
                    children: [
                      const Text(
                        '광고 시청 중',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed:
                            vm.canSkip || vm.isCompleted ? _onSkipOrComplete : null,
                        child: Text(
                          vm.isCompleted ? '완료' : vm.skipLabel,
                          style: TextStyle(
                            color: vm.canSkip || vm.isCompleted
                                ? BenefitTheme.primary
                                : Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _closeWithoutReward,
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 280,
                      height: 280,
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('📺', style: TextStyle(fontSize: 48)),
                          SizedBox(height: 12),
                          Text(
                            '광고 영상',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: vm.progress,
                          minHeight: 4,
                          backgroundColor: Colors.white24,
                          color: BenefitTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        vm.isCompleted
                            ? '시청 완료! +${widget.rewardPicks} Pick 지급'
                            : vm.remainingTimeLabel,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
