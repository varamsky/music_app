import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_app/databases/db_songList.dart';
import 'package:music_app/model/model_Db_Song_Info.dart';

class MusicData extends ChangeNotifier{
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songsList;
  List<ModelDbSongInfo> songListFromDb = List<ModelDbSongInfo>();


  Future<List<ModelDbSongInfo>> findSongs() async{
    int f = 0;

    MusicData musicData = MusicData();
    Future<List<SongInfo>> _mySongs;

    var db = DbSongList();

    f++;
    print('\nsongs() time $f\n');

    print('DATABASE count :: ${await db.getCount()}');
    db.removeAll();
    print('DATABASE count :: ${await db.getCount()}');




    musicData.songsList = await musicData.audioQuery.getSongs();

    print('musicData.songsList.length = ${musicData.songsList.length}');
    for (int i = 0; i < musicData.songsList.length; i++) {
      print('@@  I  i = $i');
      print('Song name :: ${musicData.songsList[i].title}');
      print('AlbumArt :: ${musicData.songsList[i].albumArtwork}');
      print('Track :: ${musicData.songsList[i].track}');

      SongInfo songInfo = musicData.songsList[i];
      print('before DbSongInfoModel newSong ${songInfo.filePath}');

      ModelDbSongInfo newSong = ModelDbSongInfo(
        (int.parse(songInfo.id) != -1) ? int.parse(songInfo.id) : -1,
        (songInfo.title != null) ? songInfo.title : 'NULL',
        (songInfo.track != null) ? songInfo.track : 'NULL',
        (songInfo.duration != null) ? songInfo.duration : 'NULL',
        (songInfo.filePath != null) ? songInfo.filePath : 'NULL',
        (songInfo.albumArtwork != null) ? songInfo.albumArtwork : 'NULL',
      );
      print('after DbSongInfoModel newSong ${newSong.getStSongFilePath}');


      print('DbSongInfoModel newSong $newSong');

      print('before :: savedSongId');

      print('DATABASE count :: ${await db.getCount()}');
      print('\n\nLoop NOT done.Songs added ${await db.getAllSongs()}');


      int savedSongId = await db.saveSong(newSong);
      List<Map> allSongs = await db.getAllSongs();
      print('\n\nLoop NOT done\n\nSongs added $allSongs');

      print('before :: songFromDb');
      print('savedSongId : $savedSongId');

      //var x = await Future.delayed(Duration(seconds: 2));
      //print('x = $x');
      ModelDbSongInfo songFromDb = await db.getSong(savedSongId);
      print('after DbSongInfoModel songFromDb ${songFromDb.getStSongId} ${songFromDb.getStSongTitle} ${songFromDb.getStSongFilePath} ${songFromDb.getStSongDuration} ${songFromDb.getStSongTrack}');
      musicData.songListFromDb.add(songFromDb);
      print('after songListFromDb.add(songFromDb)');
      print('musicData.songListFromDb :: ${musicData.songListFromDb}');
      for(ModelDbSongInfo dbSong in musicData.songListFromDb)
        print('dbSong id ${dbSong.getStSongId}\n');
      //print('songFromDb : ${songFromDb.getStSongId} , ${songFromDb.getStSongTitle}');

    }

    print('\n\nLoop done.Songs added : ');
    db.getAllSongs();

    print('Returning musicData.songsList :: ${musicData.songsList.length} @@@@\n@@@@${musicData.songsList}');
    //return musicData.songsList;
    return musicData.songListFromDb;
  }

}