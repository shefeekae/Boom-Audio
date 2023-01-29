import 'package:flutter/material.dart';
import 'package:music_app/database/song_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CheckPlaylist extends ChangeNotifier {
  void playlistCheck(SongModel data, Songs playlist) {
    if (!playlist.isValueIn(data.id)) {
      playlist.add(data.id);
      // const snackbar = SnackBar(
      //     backgroundColor: Colors.black,
      //     content: Text(
      //       'Added to Playlist',
      //       style: TextStyle(color: Colors.white),
      //     ));
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      playlist.deleteData(data.id);
      // const snackbar = SnackBar(
      //   backgroundColor: Colors.black,
      //   content: Text(
      //     'Song Deleted',
      //     style: TextStyle(color: Colors.red),
      //   ),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
