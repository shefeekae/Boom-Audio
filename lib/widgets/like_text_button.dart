// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:music_app/database/favorite_functions.dart';
import 'package:music_app/functions/is_liked.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoriteTextButton extends StatelessWidget {
  FavoriteTextButton({super.key, required this.song});
  final SongModel song;

  LikeSong likeSong = LikeSong();
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteDB>(
      builder: (context, provider, child) {
        return TextButton(
            onPressed: () {
              likeSong.likeTheSong(song: song, context: context);
            },
            child: provider.isfavor(song)
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
