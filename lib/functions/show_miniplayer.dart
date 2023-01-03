import 'package:music_app/screens/currently_playing.dart';

import 'package:on_audio_query/on_audio_query.dart';

class ShowMiniPlayer {
  // static showMiniPlayer(
  //     {required BuildContext context, required List<SongModel> songlist}) {
  //   return showBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     builder: (context) {
  //       return Miniplayer(
  //         minHeight: 65,
  //         maxHeight: 65,
  //         builder: (height, percentage) {
  //           return MiniPlayerWidget(miniPlayerSong: songlist);
  //         },
  //       );
  //     },
  //   );
  // }

  static updateMiniPlayer({required List<SongModel> songlist}) {
    playingSongNotifier.value.clear();
    playingSongNotifier.value.addAll(songlist);
    playingSongNotifier.notifyListeners();
  }
}
