import 'package:picktory/models/home_feed.dart';

abstract class HomeRepository {
  Future<HomeFeed> fetchFeed({Set<String>? programIds});
}
