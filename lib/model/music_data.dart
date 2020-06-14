import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class MusicData {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songsList;

  /*MusicData musicData = MusicData();

  Future<List<SongInfo>> findSongs() async {
    int f = 0;
    f++;
    print('\nsongs() time $f\n');

    musicData.songsList = await musicData.audioQuery.getSongs();

    for (int i = 0; i < musicData.songsList.length; i++) {
      print('@@  I  i = $i');
      print('Song name :: ${musicData.songsList[i].title}');
      print('AlbumArt :: ${musicData.songsList[i].albumArtwork}');
      print('Track :: ${musicData.songsList[i].track}');
    }

    print('\n\nLoop done.Songs added : ');

    return musicData.songsList;
  }*/
}
