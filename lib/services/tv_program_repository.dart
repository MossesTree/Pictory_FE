import 'package:picktory/models/tv_program.dart';
import 'package:picktory/models/tv_program_episode.dart';

abstract class TvProgramRepository {
  Future<List<TvProgram>> fetchPrograms({
    String? category,
    String? query,
  });

  /// 프로그램의 회차 목록 조회 (IA M-4/M-5/C-5 드롭다운 연결용)
  Future<List<TvProgramEpisode>> fetchEpisodes({required String programId});
}
