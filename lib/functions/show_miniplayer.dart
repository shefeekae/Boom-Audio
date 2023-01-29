import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ShowMiniPlayer extends ChangeNotifier {
  List<SongModel> miniPlayerNotifier = [];

  updateMiniPlayer({required List<SongModel> songlist}) {
    miniPlayerNotifier.clear();
    miniPlayerNotifier.addAll(songlist);
    notifyListeners();
  }
}
