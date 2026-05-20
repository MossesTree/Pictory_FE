import 'package:picktory/models/mission.dart';
import 'package:picktory/models/mission_choice.dart';
import 'package:picktory/models/mission_detail.dart';
import 'package:picktory/models/mission_participation_result.dart';
import 'package:picktory/services/dummy/dummy_data_provider.dart';
import 'package:picktory/services/mission_repository.dart';

class DummyMissionRepository implements MissionRepository {
  DummyMissionRepository() {
    _seedDemoResult();
  }

  final Map<String, MissionParticipationResult> _results = {};

  void _seedDemoResult() {
    const options = [
      MissionChoice(id: 'a', label: 'A. 김하준'),
      MissionChoice(id: 'b', label: 'B. 박서진'),
    ];
    _results['mission-hero-1'] = MissionParticipationResult(
      missionId: 'mission-hero-1',
      programLabel: '프로듀서101 · 6화 1위',
      title: '프로듀서101 · 6화 1위',
      userChoice: options[0],
      correctChoice: options[0],
      earnedPoints: 80,
      choiceStats: [
        MissionChoiceStat(
          choice: options[0],
          percent: 52,
          isCorrect: true,
          isUserChoice: true,
        ),
        MissionChoiceStat(
          choice: options[1],
          percent: 48,
          isCorrect: false,
          isUserChoice: false,
        ),
      ],
    );
  }
  @override
  Future<MissionDetail> fetchMissionDetail(String missionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final mission = _findMission(missionId);
    return MissionDetail(
      mission: mission,
      options: _detailOptions(missionId),
      totalPointPool: 1450,
      relatedMissions: DummyDataProvider.activeMissions
          .where((m) => m.id != missionId)
          .take(2)
          .toList(),
      relatedThreadTitles: const [
        '마지막 커플 예측 근거',
        '5화 스포 방지 스레드',
      ],
    );
  }

  @override
  Future<MissionParticipationResult> submitChoice({
    required String missionId,
    required String choiceId,
    required bool notifyOnResult,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final mission = _findMission(missionId);
    final options = _detailOptions(missionId);
    final userChoice = options.firstWhere((o) => o.id == choiceId);
    final correct = options.first;

    final result = MissionParticipationResult(
      missionId: missionId,
      programLabel: mission.programLabel,
      title: mission.title,
      userChoice: userChoice,
      correctChoice: correct,
      earnedPoints: userChoice.id == correct.id ? 120 : 0,
      choiceStats: [
        MissionChoiceStat(
          choice: options[0],
          percent: 53,
          isCorrect: true,
          isUserChoice: userChoice.id == options[0].id,
        ),
        MissionChoiceStat(
          choice: options[1],
          percent: 20,
          isCorrect: false,
          isUserChoice: userChoice.id == options[1].id,
        ),
        MissionChoiceStat(
          choice: options[2],
          percent: 11,
          isCorrect: false,
          isUserChoice: userChoice.id == options[2].id,
        ),
        MissionChoiceStat(
          choice: options[3],
          percent: 16,
          isCorrect: false,
          isUserChoice: userChoice.id == options[3].id,
        ),
      ],
      relatedMissions: DummyDataProvider.activeMissions.take(2).toList(),
      relatedThreadTitles: const ['마지막 커플 예측 근거'],
    );
    _results[missionId] = result;
    return result;
  }

  @override
  Future<MissionParticipationResult?> fetchParticipationResult(
    String missionId,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _results[missionId];
  }

  Mission _findMission(String id) {
    final all = [
      ...DummyDataProvider.heroMissions,
      ...DummyDataProvider.activeMissions,
    ];
    return all.firstWhere(
      (m) => m.id == id,
      orElse: () => DummyDataProvider.heroMissions.first,
    );
  }

  List<MissionChoice> _detailOptions(String missionId) => const [
        MissionChoice(id: 'a', label: 'A. 수지 & 민호'),
        MissionChoice(id: 'b', label: 'B. 민희 & 태환'),
        MissionChoice(id: 'c', label: 'C. 영수 & 다은'),
        MissionChoice(id: 'd', label: 'D. 기타'),
      ];
}
