// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteDB extends ChangeNotifier {
  List<SongModel> favoriteNotifier = [];

  bool isInitialized = false;
  static final musicDb = Hive.box<int>('favoriteDB');
  // static ValueNotifier<List<SongModel>> favoriteSongs = ValueNotifier([]);

  initialise(List<SongModel> songs) {
    for (SongModel song in songs) {
      if (isfavor(song)) {
        // favoriteSongs.value.add(song);
        favoriteNotifier.add(song);
        // notifyListeners();
      }
    }
    isInitialized = true;
  }

  bool isfavor(SongModel song) {
    if (musicDb.values.contains(song.id)) {
      return true;
    }

    return false;
  }

  add(SongModel song) async {
    musicDb.add(song.id);
    // favoriteSongs.value.add(song);
    favoriteNotifier.add(song);
    notifyListeners();
  }

  delete(int id) async {
    int deleteKey = 0;
    if (!musicDb.values.contains(id)) {
      return;
    }
    final Map<dynamic, int> favorMap = musicDb.toMap();
    favorMap.forEach((key, value) {
      if (value == id) {
        deleteKey = key;
      }
    });
    musicDb.delete(deleteKey);
    favoriteNotifier.removeWhere((song) => song.id == id);
    notifyListeners();
  }
}
