import 'package:flutter/material.dart';

class WireframeScaffold extends StatelessWidget {
  const WireframeScaffold({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.showBackButton = false,
    this.topTrailing,
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final bool showBackButton;
  final Widget? topTrailing;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
        title: Text(title),
        actions: topTrailing != null ? [topTrailing!] : null,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitle != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
            Expanded(child: body),
            if (bottom != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: bottom!,
              ),
          ],
        ),
      ),
    );
  }
}
