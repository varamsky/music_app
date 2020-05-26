import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_app/model/player_data.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class MusicControls extends StatelessWidget {

  //bool isPlay;
  final AssetsAudioPlayer assetsAudioPlayer;
  final SongInfo currSong;

  //MusicControls({@required this.isPlay,@required this.assetsAudioPlayer});
  MusicControls({@required this.assetsAudioPlayer,@required this.currSong});

  @override
  Widget build(BuildContext context) {
    final playerData = Provider.of<PlayerData>(context,listen: false);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 250.0,
            height: 250.0,
            //color: Colors.transparent,//RandomColor().randomColor(),
            color: RandomColor().randomColor(),
            child: Image.file(File(currSong.albumArtwork.toString()),fit: BoxFit.fill,),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_arrow_left),
                onPressed: (){

                },
              ),
              Consumer<PlayerData>(
                builder: (BuildContext context,PlayerData playerData,Widget widget)=>IconButton(
                  icon: Icon((playerData.isPlay)?Icons.pause:Icons.play_arrow),
                  onPressed: (){
                      playerData.changeIsPlay();

                      assetsAudioPlayer.playOrPause();
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: (){
                  assetsAudioPlayer.seek(Duration(minutes: 2));
                },
              ),
            ],
          ),
          Slider(value: 0.0,
              min: 0,
              max: int.parse(currSong.duration).toDouble(),
              divisions: 100,
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
              onChanged: (double value){},
              /*label: '${sliderValue.round()}',
              onChanged: (double value){
                setState(() {
                  sliderValue = value;
                  assetsAudioPlayer.seek(Duration(minutes: 2));

                  print('\n\nDuration ::: ${widget.currSong.duration} \n\n${int.parse(widget.currSong.duration).toDouble()}\n\n');
                },);
              },*/),
        ],
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

