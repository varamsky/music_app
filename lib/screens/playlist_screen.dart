import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_app/models/db_song_model.dart';

class PlaylistScreen extends StatelessWidget {
  final List<DbSongModel> songList;

  PlaylistScreen({@required this.songList});

  @override
  Widget build(BuildContext context) {
    print('from FavPlScreen $songList');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Fav Playlist Screen')),

        // TODO: arrange the songs in the order that they were added i.e., last added song should appear last

        body: (songList.length == 0)?Center(child: Text('No songs in this playlist.'),):ListView.builder(
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
      ),
    );
  }
}
