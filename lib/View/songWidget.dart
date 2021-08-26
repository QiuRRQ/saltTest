import 'dart:io';
import 'package:flutter/material.dart';
import 'package:salt/Utils/widget.dart';
import 'package:salt/View/MusicHomePage.dart';
import 'package:salt/model/songResponse.dart';

class SongWidget extends StatelessWidget {
  final List<Song>? songList;

  SongWidget({required this.songList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: songList!.length,
        shrinkWrap: true,
        itemBuilder: (context, songIndex) {
          Song song = songList![songIndex];
          return Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    child: Image(
                      height: 90,
                      width: 150,
                      fit: BoxFit.cover,
                      image: FileImage(File(song.artworkUrl30!)),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(song.trackCensoredName!,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(song.artistName!,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(song.collectionName!,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            audioManagerInstance
                                .start(
                                    song.previewUrl!, song.trackCensoredName!,
                                    desc: song.collectionName!,
                                    auto: true,
                                    cover: song.artworkUrl30!)
                                .then((err) {
                              print(err);
                            });
                          },
                          child: IconText(
                            iconData: Icons.play_circle_outline,
                            iconColor: Colors.red,
                            string: "Play",
                            textColor: Colors.black,
                            iconSize: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

          return SizedBox(
            height: 0,
          );
        });
  }

  static String parseToMinutesSeconds(int ms) {
    String data;
    Duration duration = Duration(milliseconds: ms);

    int minutes = duration.inMinutes;
    int seconds = (duration.inSeconds) - (minutes * 60);

    data = minutes.toString() + ":";
    if (seconds <= 9) data += "0";

    data += seconds.toString();
    return data;
  }
}
