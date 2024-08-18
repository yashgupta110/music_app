import 'package:demo/ytmusic/model/video.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerUI extends StatefulWidget {
  final Video currentVideo;
  final AudioPlayer audioPlayer;
  final Duration duration;
  final Duration position;
  final bool isPlaying;
  final Color? backgroundColor;
  final Function() onPlayPause;

  const PlayerUI({
    Key? key,
    required this.currentVideo,
    required this.audioPlayer,
    required this.duration,
    required this.position,
    required this.isPlaying,
    required this.backgroundColor,
    required this.onPlayPause,
  }) : super(key: key);

  @override
  _PlayerUIState createState() => _PlayerUIState();
}

class _PlayerUIState extends State<PlayerUI> {
  late double _minValue;
  late double _maxValue;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _minValue = 0;
    _maxValue = widget.duration.inMilliseconds.toDouble();
    _currentValue = widget.position.inMilliseconds.toDouble();
    _validateCurrentValue();
  }

  @override
  void didUpdateWidget(PlayerUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maxValue = widget.duration.inMilliseconds.toDouble();
    _currentValue = widget.position.inMilliseconds.toDouble();
    _validateCurrentValue();
  }

  void _validateCurrentValue() {
    if (_currentValue < _minValue) {
      _currentValue = _minValue;
    }
    if (_currentValue > _maxValue) {
      _currentValue = _maxValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.black,
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
              Image.network(
                widget.currentVideo.thumbnailUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.currentVideo.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.currentVideo.author,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  widget.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: widget.onPlayPause,
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
              trackShape: RectangularSliderTrackShape(),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
            ),
            child: Slider(
              value: _currentValue,
              min: _minValue,
              max: _maxValue,
              onChanged: (value) {
                final newPosition = Duration(milliseconds: value.toInt());
                setState(() {
                  _currentValue = value;
                  widget.audioPlayer.seek(newPosition);
                });
              },
              activeColor: Colors.white,
              inactiveColor: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
