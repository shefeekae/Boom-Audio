import 'package:flutter/material.dart';
import 'package:music_app/database/favorite_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class LikeSong {
  // FavoriteDB favoriteDB = FavoriteDB();

  likeTheSong({required SongModel song, required BuildContext context}) {
    if (Provider.of<FavoriteDB>(context, listen: false).isfavor(song)) {
      // FavoriteDB.delete(song.id);
      Provider.of<FavoriteDB>(context, listen: false).delete(song.id);
      // FavoriteDB.favoriteSongs.notifyListeners();
      Provider.of<FavoriteDB>(context, listen: false).notifyListeners();
    } else {
      // FavoriteDB.add(song);
      Provider.of<FavoriteDB>(context, listen: false).add(song);
      // FavoriteDB.favoriteSongs.notifyListeners();
      Provider.of<FavoriteDB>(context, listen: false).notifyListeners();
    }
    // FavoriteDB.favoriteSongs.notifyListeners();
    Provider.of<FavoriteDB>(context, listen: false).notifyListeners();
  }
}
