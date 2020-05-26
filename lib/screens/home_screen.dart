import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_app/screens/player_screen.dart';
import 'package:music_app/model/music_data.dart';

class HomeScreen extends StatelessWidget {
  MusicData musicData = MusicData();

  Future<List> songs() async {
    musicData.songsList = await musicData.audioQuery.getSongs();

    for (int i = 0; i < musicData.songsList.length; i++) {
      print('Song name :: ${musicData.songsList[i].title}');
      print('AlbumArt :: ${musicData.songsList[i].albumArtwork}');
      print('Track :: ${musicData.songsList[i].track}');
    }

    return musicData.songsList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Music Player")),
        body: FutureBuilder(
            future: songs(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
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
                              child: Image.file(
                                  File(snap.data[index].albumArtwork.toString()),fit: BoxFit.fill,),
                            ),
                          ),
                          title: Text(snap.data[index].title),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert,color: Colors.black,),
                            onPressed: (){
                              
                            },
                          ),
                        );
                      },
                    )
                  : Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
