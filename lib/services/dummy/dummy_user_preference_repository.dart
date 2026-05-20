import 'package:picktory/models/user_preference.dart';
import 'package:picktory/services/dummy/dummy_data_provider.dart';
import 'package:picktory/services/user_preference_repository.dart';

class DummyUserPreferenceRepository implements UserPreferenceRepository {
  UserPreference _cached = DummyDataProvider.defaultPreference;

  @override
  Future<UserPreference> load() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _cached;
  }

  @override
  Future<void> save(UserPreference preference) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    _cached = preference;
  }
}
