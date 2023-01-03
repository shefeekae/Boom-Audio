import 'package:music_app/database/favorite_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LikeSong {
  static likeTheSong({required SongModel song}) {
    if (FavoriteDB.isfavor(song)) {
      FavoriteDB.delete(song.id);
      FavoriteDB.favoriteSongs.notifyListeners();
    } else {
      FavoriteDB.add(song);
      FavoriteDB.favoriteSongs.notifyListeners();
    }
    FavoriteDB.favoriteSongs.notifyListeners();
  }
}
