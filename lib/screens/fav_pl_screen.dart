import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_app/models/db_song_model.dart';

class FavPlScreen extends StatelessWidget {
  final List<DbSongModel> songList;

  FavPlScreen({this.songList});

  @override
  Widget build(BuildContext context) {
    print('from FavPlScreen $songList');
    return Scaffold(
      appBar: AppBar(title: Text('Fav Playlist Screen')),
      body: ListView.builder(
        itemCount: songList.length,
        itemBuilder: (BuildContext context,int index){
          print('from FavPlScreen albumArtwork: ${songList[index].albumArtwork}]');
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: 40.0,
                height: 40.0,
                child: (songList[index].albumArtwork ==
                    null)
                    ? Image.asset(
                  'lib/assets/default_music_artwork.jpg',
                  fit: BoxFit.fill,
                )
                    : Image.file(
                  File(songList[index].albumArtwork),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text(songList[index].title),
          );
        },
      ),
    );
  }
}
