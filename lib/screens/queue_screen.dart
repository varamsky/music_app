import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_app/model/player_data.dart';

class QueueScreen extends StatelessWidget {
  final List<SongInfo> queue;
  final int currIndex;
  QueueScreen({this.queue,this.currIndex});

  double initialScroll;
  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    double initialScroll = (currIndex/(queue.length)).toDouble();
    ScrollController _scrollController = ScrollController(initialScrollOffset: initialScroll); //TODO: initialScroll does't work

    return Scaffold(
      appBar: AppBar(title: Text("Queue"),),
      body: Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          itemCount: queue.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              title: Text(queue[index].title),
              subtitle: Text(queue[index].artist),
              selected: (index == currIndex) ? true : false,
            );
          },
        ),
      ),
    );
  }
}
