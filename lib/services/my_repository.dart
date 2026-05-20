import 'package:picktory/models/my_community_activity.dart';
import 'package:picktory/models/my_page_summary.dart';
import 'package:picktory/models/notification_settings.dart';
import 'package:picktory/models/pick_history_item.dart';
import 'package:picktory/models/special_badge.dart';

abstract class MyRepository {
  Future<MyPageSummary> fetchSummary();

  Future<void> updateNickname(String nickname);

  Future<List<PickHistoryItem>> fetchPickHistory(PickHistoryFilter filter);

  Future<List<MyCommunityPostItem>> fetchMyPosts();

  Future<List<MyCommunityCommentItem>> fetchMyComments();

  Future<List<SpecialBadge>> fetchSpecialBadges();

  Future<NotificationSettings> fetchNotificationSettings();

  Future<void> saveNotificationSettings(NotificationSettings settings);
}
