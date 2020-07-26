import 'package:flutter/cupertino.dart';

class DbSongModel{

  final int id;
  final String title;
  final String filePath;
  final String albumArtwork;
  final String playlist;

  DbSongModel({this.id,@required this.title, this.filePath, this.albumArtwork,@required this.playlist});

  DbSongModel.fromMap(Map song):this.id=song['id'],this.title=song['title'],this.filePath=song['filePath'],this.albumArtwork=song['albumArt'],this.playlist=song['playlist'];

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'filePath': filePath,
      'albumArt': albumArtwork,
      'playlist':playlist
    };
  }

}
