import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class MusicData extends ChangeNotifier{
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  Future<List<SongInfo>> songsList;

  getSongs() async{
    songsList = audioQuery.getSongs();
  }

}
