// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:music_app/database/favorite_functions.dart';
import 'package:music_app/functions/is_liked.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  FavoriteButton({super.key, required this.song});
  final SongModel song;

  LikeSong likeSong = LikeSong();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          likeSong.likeTheSong(
            song: song,
            context: context,
          );
        },
        icon: Provider.of<FavoriteDB>(context).isfavor(song)
            ? const Icon(
                Icons.favorite,
                color: Colors.red,
              )
            : const Icon(
                Icons.favorite_border,
                color: Colors.black,
              ));
  }
}
