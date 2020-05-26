import 'package:flutter/foundation.dart';

class PlayerData extends ChangeNotifier{
  bool isPlay = true;
  double sliderValue=0.0;

  void changeIsPlay(){
    isPlay = !isPlay;

    notifyListeners();
  }
}