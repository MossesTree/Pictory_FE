import 'package:picktory/models/community_category.dart';
import 'package:picktory/models/community_comment.dart';
import 'package:picktory/models/community_post.dart';
import 'package:picktory/models/report_reason.dart';
import 'package:picktory/models/user_mission.dart';

abstract class CommunityRepository {
  Future<List<CommunityPost>> fetchThreadPosts({String? categoryId});

  Future<List<CommunityCategory>> fetchCategories();

  Future<CommunityPost?> fetchPostById(String id);

  Future<List<CommunityComment>> fetchComments(String postId);

  Future<List<UserMission>> fetchUserMissions({
    UserMissionFilter filter,
    UserMissionSort sort,
    String? categoryId,
  });

  Future<UserMission?> fetchUserMissionById(String id);

  Future<CommunityPost> createPost({
    required String programLabel,
    required String title,
    required String content,
    required bool showNickname,
  });

  Future<CommunityPost> updatePost({
    required String id,
    required String programLabel,
    required String title,
    required String content,
    required bool showNickname,
  });

  Future<void> deletePost(String id);

  Future<CommunityComment> addComment({
    required String postId,
    required String content,
  });

  Future<void> updateComment({
    required String commentId,
    required String content,
  });

  Future<void> deleteComment(String commentId);

  Future<void> togglePostLike(String postId);

  Future<void> toggleCommentLike(String commentId);

  Future<void> blockUser(String nickname);

  Future<void> submitReport({
    required ReportTargetType targetType,
    required String targetId,
    required ReportReason reason,
    String? detail,
  });

  Future<void> submitMissionSuggestion({
    required String title,
    required String programLabel,
    required String episode,
    required String description,
    required List<String> choices,
    String? expectedCloseLabel,
    String? resultSource,
  });

  Future<UserMission> participateUserMission({
    required String missionId,
    required int choiceIndex,
  });

  Future<UserMission> createUserMission({
    required UserMissionType type,
    required String title,
    required String programLabel,
    required String description,
    required List<String> choices,
    String? deadlineLabel,
    int pointCost,
  });
}
