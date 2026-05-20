import 'package:picktory/models/mission_detail.dart';
import 'package:picktory/models/mission_participation_result.dart';

abstract class MissionRepository {
  Future<MissionDetail> fetchMissionDetail(String missionId);

  Future<MissionParticipationResult> submitChoice({
    required String missionId,
    required String choiceId,
    required bool notifyOnResult,
  });

  Future<MissionParticipationResult?> fetchParticipationResult(String missionId);
}
