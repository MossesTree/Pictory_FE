import 'package:picktory/models/attendance_check_in_result.dart';
import 'package:picktory/models/benefit_feed.dart';

abstract class BenefitRepository {
  Future<BenefitFeed> fetchFeed();

  Future<AttendanceCheckInResult?> checkInToday();

  Future<int?> completeAdWatch();
}
