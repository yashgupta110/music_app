import 'package:flutter/material.dart';

class YtmusicHome extends StatefulWidget {
  const YtmusicHome({Key? key}) : super(key: key);

  @override
  State<YtmusicHome> createState() => _YtmusicHomeState();
}

class _YtmusicHomeState extends State<YtmusicHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Ytmusic Home'),
      ),
    );
  }
}