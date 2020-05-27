import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_app/model/player_data.dart';
import 'package:music_app/widgets/player_controls.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatefulWidget {
  final SongInfo currSong;

  PlayerScreen({this.currSong});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  //bool isPlay;
  //double sliderValue;

  @override
  void initState() {
    super.initState();

    //isPlay = true;
    //sliderValue = 0.0;
    playSong(widget.currSong);
  }

  @override
  void dispose() {
    super.dispose();

    assetsAudioPlayer.stop();
    assetsAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider<PlayerData>(
          create: (BuildContext context) => PlayerData(),
          child: MusicControls(assetsAudioPlayer: assetsAudioPlayer,currSong: widget.currSong),
        ),
      ),
    );
  }

  playSong(SongInfo songInfo) async {
    final file = new File('${songInfo.filePath}');

    assetsAudioPlayer.open(
      Audio.file('${songInfo.filePath}'),);

    print('PATH :: ${songInfo.filePath}  PLAYING');

  }
}
