import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_app/models/db_playlist_model.dart';
import 'package:music_app/models/db_song_model.dart';
import 'package:music_app/providers/db_providers/pl_list_db_provider.dart';
import 'package:music_app/providers/db_providers/playlist_db_provider.dart';
import 'package:provider/provider.dart';

class AddToPlScreen extends StatelessWidget {
  final SongInfo currSong;

  TextEditingController newPlaylist = TextEditingController();

  AddToPlScreen({@required this.currSong});

  @override
  Widget build(BuildContext context) {
    final plListDbProvider =
        Provider.of<PlListDbProvider>(context, listen: false);
    final playlistDbProvider = Provider.of<PlaylistDbProvider>(context,listen: false);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Add to Playlist'),
      ),
      body: FutureBuilder(
        future: plListDbProvider.plListDb.readPlaylists(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          return (snap.connectionState == ConnectionState.done)
              ? ListView.builder(
                  itemCount: snap.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snap.data[index]['dbName']),
                      onTap: (){
                        DbSongModel dbSongModel  = DbSongModel(albumArtwork: currSong.albumArtwork,filePath: currSong.filePath,title: currSong.title, playlist: snap.data[index]['dbName']);
                        playlistDbProvider.playlistDb.insertSong(dbSongModel.toMap());
                        Navigator.of(context).pop();
                      },
                    );
                  },
                )
              : Container();
          //return ListTile(title: Text(snap.data['dbName'].toString()),);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showNewPlaylistDialog(context, plListDbProvider,playlistDbProvider);
        },
      ),
    ));
  }

  void showNewPlaylistDialog(
      BuildContext context, PlListDbProvider plListDbProvider,PlaylistDbProvider playlistDbProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Playlist'),
          content: TextField(
            // TODO: use SingleChildScrollView to let the keyboard come up without any error.
            controller: newPlaylist,
            decoration: InputDecoration(
              hintText: 'New playlist name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                DbPlaylistModel dbPlaylistModel =
                    DbPlaylistModel(dbName: newPlaylist.text);
                plListDbProvider.plListDb
                    .insertPlaylist(dbPlaylistModel.toMap());
                DbSongModel dbSongModel  = DbSongModel(albumArtwork: currSong.albumArtwork,filePath: currSong.filePath,title: currSong.title, playlist: newPlaylist.text);
                playlistDbProvider.playlistDb.insertSong(dbSongModel.toMap());
                Navigator.of(context).pop(); // TODO: implement this
              }, // TODO: implement this
              child: Text('CREATE'),
            ),
            RaisedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCEL'),
            ),
          ],
        );
      },
    );
  }
}
