import 'dart:async';
import 'package:demo/ytmusic/model/video.dart';
import 'package:demo/ytmusic/model/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;
import 'package:palette_generator/palette_generator.dart';

class YtmusicSearch extends StatefulWidget {
  const YtmusicSearch({Key? key}) : super(key: key);

  @override
  State<YtmusicSearch> createState() => _YtmusicSearchState();
}

class _YtmusicSearchState extends State<YtmusicSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hello, YtmusicSearch!'),
      ),
    );
  }
}