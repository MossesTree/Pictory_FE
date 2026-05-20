import 'package:picktory/models/tv_program.dart';

abstract class TvProgramRepository {
  Future<List<TvProgram>> fetchPrograms({
    String? category,
    String? query,
  });
}
