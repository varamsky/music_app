import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';

class PlayerData extends ChangeNotifier {
  bool isPlay = true;
  double sliderValue = 0.0;
  String sliderDuration = '00:00';

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
