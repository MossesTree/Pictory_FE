import 'package:picktory/models/story_item.dart';
import 'package:picktory/services/dummy/dummy_data_provider.dart';
import 'package:picktory/services/story_repository.dart';

class DummyStoryRepository implements StoryRepository {
  @override
  Future<List<StoryItem>> fetchStories({Set<String>? programIds}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final items = DummyDataProvider.stories;
    if (programIds == null || programIds.isEmpty) {
      return List<StoryItem>.from(items);
    }
    return items;
  }

  @override
  Future<StoryItem?> fetchStoryById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));

    for (final story in DummyDataProvider.stories) {
      if (story.id == id) {
        return story;
      }
    }
    return null;
  }
}
