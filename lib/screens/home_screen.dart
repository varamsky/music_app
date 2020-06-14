import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_app/screens/player_screen.dart';
import 'package:music_app/model/music_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int f = 0;

  MusicData musicData = MusicData();
  Future<List<SongInfo>> _mySongs;

  getSongs() async{
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
    _mySongs = audioQuery.getSongs();
  }

  @override
  void initState(){
    super.initState();
    //getSongs();
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
    _mySongs = audioQuery.getSongs();
    //_mySongs = musicData.findSongs();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Music Player")),
        body: FutureBuilder(
          future: _mySongs,
          builder: (BuildContext context, AsyncSnapshot snap) {
            return (snap.connectionState == ConnectionState.done)
                ? ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => PlayerScreen(
                                currSong: snap.data[index],
                              ),
                            ),
                          );
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            child: (snap.data[index].albumArtwork == null)?Image.asset('lib/assets/default_music_artwork.jpg',fit: BoxFit.fill,):Image.file(
                              File(snap.data[index].albumArtwork),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        title: Text(snap.data[index].title),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
