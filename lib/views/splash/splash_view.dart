import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:picktory/core/navigation/app_route.dart';
import 'package:picktory/core/navigation/splash_destination.dart';
import 'package:picktory/viewmodels/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key, required this.viewModel});

  final SplashViewModel viewModel;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    final destination = await widget.viewModel.resolveDestination();
    if (!mounted) {
      return;
    }

    switch (destination) {
      case SplashDestination.home:
        context.go(AppRoute.home.path);
      case SplashDestination.signup:
        context.go(AppRoute.signupTerms.path);
      case SplashDestination.login:
        context.go(AppRoute.login.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: const Text('K'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.appName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    viewModel.tagline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  Text(viewModel.loadingLabel),
                  const SizedBox(height: 12),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
