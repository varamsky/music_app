import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_app/model/player_data.dart';
import 'package:music_app/widgets/player_controls.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatelessWidget {
  final SongInfo currSong;

  PlayerScreen({this.currSong});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider<PlayerData>(
          create: (BuildContext context) => PlayerData(),
          child: PlayerControls(currSong: currSong),
        ),
      ),
    );
  }
}
