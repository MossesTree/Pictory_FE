import 'package:picktory/models/tv_program.dart';
import 'package:picktory/services/dummy/dummy_data_provider.dart';
import 'package:picktory/services/tv_program_repository.dart';

class DummyTvProgramRepository implements TvProgramRepository {
  @override
  Future<List<TvProgram>> fetchPrograms({
    String? category,
    String? query,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));

    var results = List<TvProgram>.from(DummyDataProvider.programs);

    if (category != null && category != '전체') {
      results = results.where((p) => p.category == category).toList();
    }

    if (query != null && query.isNotEmpty) {
      final lower = query.toLowerCase();
      results = results
          .where(
            (p) =>
                p.title.toLowerCase().contains(lower) ||
                p.channel.toLowerCase().contains(lower),
          )
          .toList();
    }

    return results;
  }
}
