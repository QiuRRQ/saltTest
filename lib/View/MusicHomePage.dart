import 'package:flutter/material.dart';
import 'package:salt/BloC/musicBloc.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:salt/View/songWidget.dart';
import 'package:salt/model/songResponse.dart';
import 'package:salt/repositories/musicRepositories.dart';

class MusicPage extends StatefulWidget {
  MusicPage({Key? key}) : super(key: key);

  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<MusicPage> {
  TextEditingController artistName = new TextEditingController();

  MusicBloc bloc = MusicBloc();

  ScrollController? controller;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build");

    _loading() {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    _noData() {
      return Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Text("data tidak ada.")],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 250,
              child: TextField(
                enabled: true,
                keyboardType: TextInputType.name,
                maxLines: 1,
                controller: artistName,
                style: TextStyle(
                    fontSize: 14.0, color: Colors.white, fontFamily: "Title"),
                decoration: InputDecoration(hintText: "Search for artist"),
              ),
            ),
            TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  print("search");
                  bloc.inputSink.add(artistName.text);
                },
                child: const Text(
                  "search",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RefreshIndicator(
            child: StreamBuilder(
                stream: bloc.output,
                initialData: bloc.SongList,
                builder: (context, snapshot) => Container(
                      margin: EdgeInsets.only(right: 8.0, left: 8.0, top: 10.0),
                      child: snapshot.hasData
                          ? Container(
                              height: 480,
                              child: SongWidget(
                                  songList: snapshot.data as List<Song>),
                            )
                          : _noData(),
                    )),
            onRefresh: () {
              bloc.inputSink.add("getMusic");
              print("iki melbu refresh");
              return Future<void>(() {});
            },
          ),
          bottomPanel(),
        ],
      ),

      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       StreamBuilder(
      //           stream: bloc.output,
      //           initialData: "initial list",
      //           builder: (context, snapshot) => Text(
      //                 '${snapshot.data}',
      //                 style: Theme.of(context).textTheme.headline4,
      //               )),
      //     ],
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     bloc.inputSink.add('add');
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }

  Widget songProgress(BuildContext context) {
    var style = TextStyle(color: Colors.black);
    return Row(
      children: <Widget>[
        Text(
          _formatDuration(audioManagerInstance.position),
          style: style,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbColor: Colors.blueAccent,
                  overlayColor: Colors.blue,
                  thumbShape: RoundSliderThumbShape(
                    disabledThumbRadius: 5,
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                  activeTrackColor: Colors.blueAccent,
                  inactiveTrackColor: Colors.grey,
                ),
                child: Slider(
                  value: _slider ?? 0,
                  onChanged: (value) {
                    setState(() {
                      _slider = value;
                    });
                  },
                  onChangeEnd: (value) {
                    if (audioManagerInstance.duration != null) {
                      Duration msec = Duration(
                          milliseconds:
                              (audioManagerInstance.duration.inMilliseconds *
                                      value)
                                  .round());
                      audioManagerInstance.seekTo(msec);
                    }
                  },
                )),
          ),
        ),
        Text(
          _formatDuration(audioManagerInstance.duration),
          style: style,
        ),
      ],
    );
  }

  Widget bottomPanel() {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: songProgress(context),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                    ),
                    onPressed: () => audioManagerInstance.previous()),
              ),
              backgroundColor: Colors.cyan.withOpacity(0.3),
            ),
            CircleAvatar(
              radius: 30,
              child: Center(
                child: IconButton(
                  onPressed: () async {
                    audioManagerInstance.playOrPause();
                  },
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(
                    audioManagerInstance.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.cyan.withOpacity(0.3),
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: Colors.white,
                    ),
                    onPressed: () => audioManagerInstance.next()),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

var audioManagerInstance = AudioManager.instance;
bool showVol = false;
PlayMode playMode = audioManagerInstance.playMode;
bool isPlaying = false;
double? _slider;
