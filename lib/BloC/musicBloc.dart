import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:salt/model/songResponse.dart';
import 'package:salt/repositories/musicRepositories.dart';

class MusicBloc {
  String ArtistName = "";
  List<Song> SongList = [];

  StreamController _inputController = StreamController();
  StreamSink get inputSink => _inputController.sink;

  StreamController _outputController = StreamController();
  StreamSink get outputSink => _outputController.sink;

  Stream get output => _outputController.stream;

  MusicBloc() {
    _inputController.stream.listen((event) async {
      if (event == 'getMusic') {
        SongList = await reqMusicList(artistName: ArtistName);
        print(SongList);
      } else {
        //tidak tahu cara get variable yang sudah di pass ke eventnya.
      }

      outputSink.add(SongList);
    });
  }

  void dispose() {
    _inputController.close();
    _outputController.close();
  }
}
