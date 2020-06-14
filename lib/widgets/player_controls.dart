import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:intl/intl.dart';
import 'package:music_app/model/player_data.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class PlayerControls extends StatefulWidget {
  final SongInfo currSong;

  //MusicControls({@required this.isPlay,@required this.assetsAudioPlayer});
  PlayerControls({@required this.currSong});

  @override
  _PlayerControlsState createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  String totalDuration;
  //int sliderSeconds,sliderMinutes,sliderHours;

  @override
  void initState() {
    super.initState();

    //sliderSeconds=0;
    //sliderMinutes=0;
    //sliderHours=0;

    totalDuration = widget.currSong.duration;
    properDuration();
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
    final playerData = Provider.of<PlayerData>(context, listen: false);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            height: 250.0,
            //color: Colors.transparent,
            color: RandomColor().randomColor(),
            child: (widget.currSong.albumArtwork == null)
                ? Image.asset(
                    'lib/assets/default_music_artwork.jpg',
                    fit: BoxFit.fill,
                  )
                : Image.file(
                    File(widget.currSong.albumArtwork),
                    fit: BoxFit.fill,
                  ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {},
              ),
              Consumer<PlayerData>(
                builder: (BuildContext context, PlayerData playerData,
                        Widget widget) =>
                    IconButton(
                  icon: Icon(
                      (playerData.isPlay) ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    playerData.changeIsPlay();

                    assetsAudioPlayer.playOrPause();
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () {
                  assetsAudioPlayer.seek(Duration(minutes: 2));
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Consumer<PlayerData>(
                builder: (BuildContext context, PlayerData playerData,
                        Widget widget) =>
                    Text(playerData.sliderDuration),
              ),
              Consumer<PlayerData>(
                builder: (BuildContext context, PlayerData playerData,
                        Widget consumerWidget) =>
                    Slider(
                  value: playerData.sliderValue,
                  min: 0.0,
                  max: double.parse(widget.currSong.duration),
                  divisions: 100,
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey,
                  onChanged: (double value) {
                    playerData.seekSlider(value, assetsAudioPlayer);
                  },
                ),
              ),
              Text(totalDuration),
            ],
          ),

          //TODO: remove this widget
          Container(
            width: 50.0,
            height: 50.0,
            //color: Colors.transparent,
            color: RandomColor().randomColor(),
            child: Text('test'),
          ),
        ],
      ),
    );
  }

  playSong(SongInfo songInfo) async {
    //final file = new File('${songInfo.filePath}');

    assetsAudioPlayer.open(
      Audio.file('${songInfo.filePath}'),
    );

    print('PATH :: ${songInfo.filePath}  PLAYING');
  }

  properDuration() {
    //For total Duration
    Duration duration = Duration(milliseconds: int.parse(totalDuration));
    String seconds, minutes, hours;

    seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    hours = duration.inHours.toString().padLeft(2, '0');

    totalDuration = (int.parse(hours) == 0)
        ? '$minutes:$seconds'
        : '$hours:$minutes:$seconds';
  }
}
