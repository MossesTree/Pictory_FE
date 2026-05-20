import 'package:picktory/models/user_preference.dart';

abstract class UserPreferenceRepository {
  Future<UserPreference> load();

  Future<void> save(UserPreference preference);
}
