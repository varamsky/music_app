import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class PlayerData extends ChangeNotifier{
  bool isPlay = true;
  double sliderValue = 0.0;
  String sliderDuration = '00:00';

  int _currIndex;

  int get getCurrIndex => _currIndex;

  set setCurrIndex(int value) {
    _currIndex = value;
  }

  /*int setCurrIndex(int index){
    _currIndex = index;

    //notifyListeners();//TODO: Try removing this line
    return _currIndex;
  }*/


  increaseIndex(){
    _currIndex++;

    notifyListeners();
  }

  decreaseIndex(){
    _currIndex--;

    notifyListeners();
  }

  void changeIsPlay() {
    isPlay = !isPlay;

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