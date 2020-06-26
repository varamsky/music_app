import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_app/model/player_data.dart';
import 'package:music_app/screens/queue_screen.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class PlayerControls extends StatefulWidget {
  final List<SongInfo> songList;
  int currIndex;

  //MusicControls({@required this.isPlay,@required this.assetsAudioPlayer});
  PlayerControls({@required this.songList, @required this.currIndex});

  @override
  _PlayerControlsState createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  String totalDuration;
  SongInfo currSong;

  @override
  void dispose() {
    super.dispose();

    assetsAudioPlayer.stop();
    assetsAudioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Inside PlayerControls build');
    final playerData = Provider.of<PlayerData>(context, listen: false);
    print('Inside PlayerControls build after provider instantiation');
    playerData.setCurrIndex = widget.currIndex;
    print(
        'widget.currIndex :: ${widget.currIndex} playerData.getCurrIndex :: ${playerData.getCurrIndex}');
    print('currSong ${widget.songList[playerData.getCurrIndex]}');
    currSong = widget.songList[playerData.getCurrIndex];
    totalDuration = currSong.duration;
    playerData.playSong(currSong, assetsAudioPlayer, totalDuration);
    properDuration();
    print('Inside PlayerControls build before return');
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //selector ensures that the widget is rebuild only when there is a change to PlayerData.currIndex
          Selector<PlayerData, int>(
            selector: (_, model) => model.currIndex,
            builder: (BuildContext context, int index, Widget widget) =>
                Container(
              width: 250.0,
              height: 250.0,
              //color: Colors.transparent,
              color: RandomColor().randomColor(),
              child: (currSong.albumArtwork == null)
                  ? Image.asset(
                      'lib/assets/default_music_artwork.jpg',
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(currSong.albumArtwork),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Selector<PlayerData, int>(
            selector: (_, model) => model.currIndex,
            builder: (BuildContext context, int index, Widget widget) => Text(
              currSong.title,
              style: TextStyle(color: Colors.black, fontSize: 25.0),
            ),
          ),
          Selector<PlayerData, int>(
            selector: (_, model) => model.currIndex,
            builder: (BuildContext context, int index, Widget widget) => Text(
              currSong.artist,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: () {
                  if (playerData.getCurrIndex != 0) {
                    playerData.decreaseIndex();
                  }
                  playerData.isPlay = true;
                  //currIndex = playerData.getCurrIndex;
                  assetsAudioPlayer.stop();
                  playerData.sliderValue = 0.0;
                  currSong = widget.songList[playerData.getCurrIndex];
                  playerData.playSong(
                      currSong, assetsAudioPlayer, totalDuration);
                },
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
                  if (playerData.getCurrIndex != (widget.songList.length - 1)) {
                    playerData.increaseIndex();
                  }
                  playerData.isPlay = true;
                  //currIndex = musicData.getCurrIndex;
                  assetsAudioPlayer.stop();
                  playerData.sliderValue = 0.0;
                  currSong = widget.songList[playerData.getCurrIndex];
                  playerData.playSong(
                      currSong, assetsAudioPlayer, totalDuration);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Consumer<PlayerData>(builder:
                  (BuildContext context, PlayerData playerData, Widget widget) {
                return Text(playerData.sliderDuration);
              }),
              Column(
                children: <Widget>[
                  Selector<PlayerData, double>(
                      selector: (_, model) => model.sliderValue,
                      builder: (BuildContext context, double sliderValue,
                          Widget consumerWidget) {
                        return Slider(
                          //TODO: update sliderValue as song plays
                          value: playerData
                              .sliderValue, // TODO: sliderValue changes but nothing observed on screen
                          min: 0.0,
                          max: double.parse(currSong.duration),
                          divisions: 100,
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                          onChanged: (double value) {
                            playerData.sliderValue = value;
                            playerData.seekSlider(value, assetsAudioPlayer);
                          },
                        );
                      }),
                ],
              ),
              Consumer<PlayerData>(builder:
                  (BuildContext context, PlayerData playerData, Widget widget) {
                totalDuration = currSong.duration;
                properDuration();
                return Text(totalDuration);
              }),
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
          IconButton(
            color: Colors.amber,
            icon: Icon(Icons.queue_music),
            tooltip: 'Queue',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      QueueScreen(queue: widget.songList,currIndex: widget.currIndex)));
            },
          ),
        ],
      ),
    );
  }

  /*playSong(SongInfo songInfo) async {
    //final file = new File('${songInfo.filePath}');

    assetsAudioPlayer.open(
      Audio.file('${songInfo.filePath}'),
    );

    print('PATH :: ${songInfo.filePath}  PLAYING');
  }*/

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
