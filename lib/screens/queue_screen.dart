import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class QueueScreen extends StatelessWidget {
  final List<SongInfo> queue;
  final int currIndex;
  QueueScreen({this.queue,this.currIndex});

  double initialScroll;
  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    double initialScroll = (currIndex/(queue.length)).toDouble() * 100;
    print('Initial Scroll $initialScroll');
    ScrollController _scrollController = ScrollController(initialScrollOffset: initialScroll * (queue.length - 26.0));

    return Scaffold(
      appBar: AppBar(title: Text("Queue"),),
      body: Scrollbar(
        controller: _scrollController,
        child: ListView.separated(
          controller: _scrollController,
          itemCount: queue.length,
          separatorBuilder: (BuildContext context,int index) => Divider(),
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              //title: Text(queue[index].title),
              //subtitle: Text(queue[index].artist),
              enabled: (index == currIndex),// true or false
              title: RichText(text: TextSpan(text: queue[index].title,style: TextStyle(color: (index == currIndex)?Colors.blue:Colors.black, fontSize: 18)),maxLines: 2,overflow: TextOverflow.ellipsis,),
              subtitle: RichText(text: TextSpan(text: queue[index].artist,style: TextStyle(color: (index == currIndex)?Colors.blue:Colors.grey, fontSize: 15),),maxLines: 1,overflow: TextOverflow.ellipsis,),
              selected: (index == currIndex),// true or false
            );
          },
        ),
      ),
    );
  }
}
