import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class PlayerData extends ChangeNotifier{
  bool isPlay = true;
  double sliderValue = 0.0;
  String sliderDuration = '00:00';
  Duration songRunTime;

  int currIndex;

  int get getCurrIndex => currIndex;

  set setCurrIndex(int value) {
    currIndex = value;
  }

  /*int setCurrIndex(int index){
    currIndex = index;

    //notifyListeners();//TODO: Try removing this line
    return currIndex;
  }*/


  increaseIndex(){
    currIndex++;

    notifyListeners();
  }

  decreaseIndex(){
    currIndex--;

    notifyListeners();
  }

  void changeIsPlay() {
    isPlay = !isPlay;

    notifyListeners();
  }

  playSong(SongInfo songInfo,AssetsAudioPlayer assetsAudioPlayer,String totalDuration) async {
    //final file = new File('${songInfo.filePath}');

    assetsAudioPlayer.open(
      Audio.file('${songInfo.filePath}'),
    );
    
    assetsAudioPlayer.currentPosition.listen((event) {
      songRunTime = event;
      
      updateSliderValue(songRunTime,totalDuration);
    });

    print('PATH :: ${songInfo.filePath}  PLAYING');
  }

  updateSliderValue(Duration songRunTime,String totalDuration){
    Duration total = Duration(milliseconds: int.parse(totalDuration));
    sliderValue = (songRunTime.inMilliseconds / total.inMilliseconds) * 100;
    //print('songRunTime.inMilliseconds / total.inMilliseconds :: ${songRunTime.inMilliseconds} / ${total.inMilliseconds}');
    //print('sliderValue $sliderValue');
    if(songRunTime.inHours == 0){
      sliderDuration = songRunTime.inMinutes.remainder(60).toString().padLeft(2, '0') + ':' + songRunTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    }
    else{
      sliderDuration = songRunTime.inHours.remainder(60).toString().padLeft(2, '0') + ':' + songRunTime.inMinutes.remainder(60).toString().padLeft(2, '0') + ':' + songRunTime.inSeconds.remainder(60).toString().padLeft(2, '0');
    }

    notifyListeners();
  }




  void seekSlider(double value, AssetsAudioPlayer assetsAudioPlayer) {
    sliderValue = value;
    assetsAudioPlayer.seek(Duration(milliseconds: value.round()));

    Duration duration = Duration(milliseconds: value.toInt());
    String seconds, minutes, hours;

    seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    hours = duration.inHours.toString().padLeft(2, '0');

    sliderDuration = (int.parse(hours) == 0)
        ? '$minutes:$seconds'
        : '$hours:$minutes:$seconds';

    notifyListeners();
  }
}