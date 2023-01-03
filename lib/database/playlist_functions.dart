// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/database/song_db.dart';

class PlaylistDB {
  static ValueNotifier<List<Songs>> playlistnotifier = ValueNotifier([]);

  static Future<void> playlistAdd(Songs value) async {
    final playListDb = Hive.box<Songs>('playlistDB');
    await playListDb.add(value);

    playlistnotifier.value.add(value);
  }

  static Future<void> getPlaylist() async {
    final playListDb = Hive.box<Songs>('playlistDB');
    playlistnotifier.value.clear();
    playlistnotifier.value.addAll(playListDb.values);

    playlistnotifier.notifyListeners();
  }

  static Future<void> playlistDelete(int index) async {
    final playListDb = Hive.box<Songs>('playlistDB');

    await playListDb.deleteAt(index);
    getPlaylist();
  }
}
