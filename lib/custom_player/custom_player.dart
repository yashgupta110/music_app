import 'dart:async';
import 'package:demo/ytmusic/model/video.dart';
import 'package:demo/ytmusic/model/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;
import 'package:palette_generator/palette_generator.dart';

class CustomPlayer extends ConsumerStatefulWidget {
  const CustomPlayer({super.key});

  @override
  _CustomPlayerState createState() => _CustomPlayerState();
}

class _CustomPlayerState extends ConsumerState<CustomPlayer> {
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  Video? _currentVideo;
  final Map<String, yt.StreamInfo?> _prefetchedStreams = {};
  yt.YoutubeExplode youtubeExplode = yt.YoutubeExplode();
  bool _youtubeExplodeClosed = false;
  Color? _backgroundColor;

  @override
  void initState() {
    super.initState();

    _audioPlayer.durationStream.listen((Duration? d) {
      if (d != null) {
        setState(() {
          _duration = d;
        });
      }
    });

    _audioPlayer.positionStream.listen((Duration position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    _audioPlayer.playerStateStream.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
        });
      }
    });

    _prefetchAudioStreams();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    youtubeExplode.close();
    _youtubeExplodeClosed = true;
    super.dispose();
  }

  Future<void> _prefetchAudioStreams() async {
    final videos = ref.read(videoProvider).value ?? [];
    for (var video in videos) {
      if (!_prefetchedStreams.containsKey(video.id)) {
        var streamInfo = await _fetchStreamInfo(video.id);
        if (streamInfo != null) {
          _prefetchedStreams[video.id] = streamInfo;
        }
      }
    }
  }

  Future<void> _playAudio(Video video) async {
    setState(() {
      _currentVideo = video;
    });
    await _setBackgroundColor(video.thumbnailUrl);
    try {
      yt.StreamInfo? streamInfo =
          _prefetchedStreams[video.id] ?? await _fetchStreamInfo(video.id);

      if (streamInfo != null) {
        var audioUrl = streamInfo.url.toString();
        await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));
        await _audioPlayer.play();
        setState(() {
          isPlaying = true;
        });
      } else {
        print("Stream info is null");
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<yt.StreamInfo?> _fetchStreamInfo(String videoId) async {
    // Check if youtubeExplode is closed and reinitialize if necessary
    if (_youtubeExplodeClosed) {
      youtubeExplode = yt.YoutubeExplode();
      _youtubeExplodeClosed = false;
    }

    try {
      var manifest =
          await youtubeExplode.videos.streamsClient.getManifest(videoId);
      return manifest.audioOnly.withHighestBitrate();
    } catch (e) {
      print("Error fetching stream info: $e");
      return null;
    }
  }

  Future<void> _setBackgroundColor(String imageUrl) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
    );
    setState(() {
      _backgroundColor = paletteGenerator.dominantColor?.color ?? Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoState = ref.watch(videoProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
              onSubmitted: (query) {
                ref.read(videoProvider.notifier).fetchMusicVideos(query);
                _prefetchAudioStreams();
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                hintText: "Search",
                hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: videoState.when(
              data: (videos) {
                if (videos.isEmpty) {
                  return const Center(
                      child: Text(
                    'Search what you want to Listen !',
                    style: TextStyle(color: Colors.white),
                  ));
                }
                return ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return ListTile(
                      leading: Image.network(video.thumbnailUrl),
                      title: Text(
                        video.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      subtitle: Text(
                        video.author,
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 12),
                      ),
                      onTap: () => _playAudio(video),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
          if (_currentVideo != null) _buildPlayerUI(),
        ],
      ),
    );
  }

  Widget _buildPlayerUI() {
    // Ensure min and max values for the Slider are valid
    double minValue = 0;
    double maxValue = _duration.inMilliseconds.toDouble();
    double currentValue = _position.inMilliseconds.toDouble();

    // Ensure the current value is within the valid range
    if (currentValue < minValue) {
      currentValue = minValue;
    }
    if (currentValue > maxValue) {
      currentValue = maxValue;
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Container(
            height: 130,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color:
                  _backgroundColor ?? Colors.black, // Use the extracted color
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (_currentVideo != null)
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Image.network(
                          _currentVideo!.thumbnailUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentVideo!.title,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _currentVideo!.author,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        try {
                          if (isPlaying) {
                            await _audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            await _audioPlayer.play();
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        } catch (e) {
                          print("Error toggling play/pause: $e");
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4,right: 4),
                  child: SliderTheme(
                    data: const SliderThemeData(
                      trackHeight: 2,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                      trackShape: RectangularSliderTrackShape(),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                    ),
                    child: Slider(
                      value: currentValue,
                      min: minValue,
                      max: maxValue,
                      onChanged: (value) {
                        final newPosition = Duration(microseconds: value.toInt());
                        setState(() {
                          _position = newPosition;
                          _audioPlayer.seek(newPosition);
                        });
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey[800],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         _formatDuration(_position),
                //         style: const TextStyle(color: Colors.white),
                //       ),
                //       Text(
                //         _formatDuration(_duration),
                //         style: const TextStyle(color: Colors.white),
                //       ),
                //     ],
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     IconButton(
                //       icon: const Icon(Icons.skip_previous, color: Colors.white),
                //       onPressed: _playPrevious,
                //     ),
                //     IconButton(
                //       icon: const Icon(Icons.skip_next, color: Colors.white),
                //       onPressed: _playNext,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _playPrevious() {
    // Implement previous track functionality if available
  }

  void _playNext() {
    // Implement next track functionality if available
  }
}
