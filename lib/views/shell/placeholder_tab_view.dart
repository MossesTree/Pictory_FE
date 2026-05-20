import 'package:flutter/material.dart';
import 'package:picktory/views/shell/main_tab.dart';

class PlaceholderTabView extends StatelessWidget {
  const PlaceholderTabView({super.key, required this.tab});

  final MainTab tab;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('${tab.label} (준비 중)'),
    );
  }
}
