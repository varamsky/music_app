import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_app/model/music_data.dart';
import 'package:music_app/model/player_data.dart';
import 'package:music_app/widgets/player_controls.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatelessWidget {
  final List<SongInfo> songList;
  final int index;

  PlayerScreen({this.songList,this.index});

  @override
  Widget build(BuildContext context) {
    print('Inside PlayerScreen build');
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider<PlayerData>(
          create: (BuildContext context) => PlayerData(),
          child: PlayerControls(songList: songList,currIndex: index),
        ),
      ),
    );
  }
}
