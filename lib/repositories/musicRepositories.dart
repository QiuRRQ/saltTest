import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salt/Utils/ConstantVariable.dart';
import 'package:salt/model/songResponse.dart';

Future<List<Song>> reqMusicList({String? artistName}) async {
  List<Song> jenisPinjaman = [];

  String url = BASE_URL + API_SEARCH + "entity=song&limit=15";
  if (artistName != "") {
    url += "&term=${artistName!}";
  } else {
    url += '&term=' + '""';
  }
  print(url);
  var response = await http
      .get(Uri.parse(url))
      .catchError((err) => print("error ${err.toString()}"));
  if (response.statusCode == 200) {
    try {
      Map<String, dynamic> map = jsonDecode(response.body);
      print("data music ${SongsResponse.fromJson(map).results}");
      return SongsResponse.fromJson(map).results!;
    } on TypeError {
      Iterable res = jsonDecode(response.body);
      print("data music ${SongsResponse.fromJson(res).results}");
      return SongsResponse.fromJson(res).results!;
    }
  }
  return jenisPinjaman;
}
