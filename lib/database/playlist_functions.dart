// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/database/song_db.dart';
import 'package:music_app/functions/get_songs.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlaylistDB extends ChangeNotifier {
  List<Songs> playlistNotifier = [];

  Box<Songs> boxNotifier = Hive.box<Songs>('playlistDB');

  // static ValueNotifier<List<Songs>> playlistnotifier = ValueNotifier([]);

  Future<void> playlistAdd(Songs value) async {
    // final playListDb = Hive.box<Songs>('playlistDB');
    await boxNotifier.add(value);

    playlistNotifier.add(value);
    notifyListeners();
  }

  Future<void> getPlaylist() async {
    // final playListDb = Hive.box<Songs>('playlistDB');
    playlistNotifier.clear();
    playlistNotifier.addAll(boxNotifier.values);
    // notifyListeners();
  }

  Future<void> playlistDelete(int index) async {
    // final playListDb = Hive.box<Songs>('playlistDB');

    await boxNotifier.deleteAt(index);
    getPlaylist();
    notifyListeners();
  }

  List<SongModel> listPlaylist(List<int> data, BuildContext context) {
    List<SongModel> plSongs = [];
    for (int i = 0;
        i < Provider.of<GetSongs>(context, listen: false).songsCopy.length;
        i++) {
      for (int j = 0; j < data.length; j++) {
        if (Provider.of<GetSongs>(context, listen: false).songsCopy[i].id ==
            data[j]) {
          plSongs
              .add(Provider.of<GetSongs>(context, listen: false).songsCopy[i]);
        }
      }
    }
    return plSongs;
  }
}
