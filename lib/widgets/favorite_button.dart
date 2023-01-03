// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:music_app/database/favorite_functions.dart';
import 'package:music_app/functions/is_liked.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.song});
  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FavoriteDB.favoriteSongs,
      builder:
          (BuildContext context, List<SongModel> favorData, Widget? child) {
        return IconButton(
            onPressed: () {
              LikeSong.likeTheSong(song: song);
            },
            icon: FavoriteDB.isfavor(song)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                  ));
      },
    );
  }
}
