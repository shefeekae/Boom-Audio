import 'package:flutter/material.dart';

import 'package:music_app/database/favorite_functions.dart';
import 'package:music_app/functions/is_liked.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteTextButton extends StatelessWidget {
  const FavoriteTextButton({super.key, required this.song});
  final SongModel song;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDB.favoriteSongs,
      builder: (context, List<SongModel> favorData, child) {
        return TextButton(
            onPressed: () {
              LikeSong.likeTheSong(song: song);
            },
            child: FavoriteDB.isfavor(song)
                ? const Text(
                    'Remove from favorites',
                    style: TextStyle(color: Colors.red),
                  )
                : const Text(
                    'Add to favorites',
                    style: TextStyle(color: Colors.red),
                  ));
      },
    );
  }
}
