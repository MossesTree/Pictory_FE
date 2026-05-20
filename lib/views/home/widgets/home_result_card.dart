import 'package:flutter/material.dart';
import 'package:picktory/models/mission_result.dart';

class HomeResultCard extends StatelessWidget {
  const HomeResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  final MissionResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('결과공개'),
              ),
              const SizedBox(height: 8),
              Text(
                result.programLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(result.resultLabel),
              const SizedBox(height: 4),
              Text('${result.participantCount}명 참여'),
            ],
          ),
        ),
      ),
    );
  }
}
