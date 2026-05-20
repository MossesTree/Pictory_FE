import 'package:picktory/models/mission_choice.dart';

class Mission {
  const Mission({
    required this.id,
    required this.programLabel,
    required this.title,
    required this.pointCost,
    required this.remainingLabel,
    required this.participantCount,
    this.choices = const [],
    this.isUrgent = false,
    this.category = '전체',
  });

  final String id;
  final String programLabel;
  final String title;
  final int pointCost;
  final String remainingLabel;
  final int participantCount;
  final List<MissionChoice> choices;
  final bool isUrgent;
  final String category;
}
