import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'youtube_service.dart';
import 'video.dart';

final youTubeServiceProvider = Provider((ref) => YouTubeService());

final videoProvider = StateNotifierProvider<VideoNotifier, AsyncValue<List<Video>>>((ref) {
  final service = ref.watch(youTubeServiceProvider);
  return VideoNotifier(service);
});

class VideoNotifier extends StateNotifier<AsyncValue<List<Video>>> {
  final YouTubeService _youTubeService;

  VideoNotifier(this._youTubeService) : super(AsyncValue.data([]));

  Future<void> fetchMusicVideos(String query) async {
    state = AsyncValue.loading();
    try {
      final videos = await _youTubeService.fetchMusicVideos(query);
      state = AsyncValue.data(videos);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}