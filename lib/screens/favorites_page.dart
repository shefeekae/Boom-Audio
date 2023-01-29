// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:music_app/database/favorite_functions.dart';
import 'package:music_app/functions/get_songs.dart';
import 'package:music_app/functions/show_miniplayer.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../widgets/neu_box_widget.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text('Favorites',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Consumer<FavoriteDB>(
          builder: (BuildContext context, provider, Widget? child) => (provider
                  .favoriteNotifier.isEmpty
              ? const Center(
                  child: Text(
                    'No favorites found',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              : Consumer<FavoriteDB>(
                  builder: (BuildContext context, provider, Widget? child) {
                  return ListView.builder(
                    itemCount: provider.favoriteNotifier.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: SizedBox(
                          height: 100,
                          child: NeuBox(
                            child: ListTile(
                              onTap: () async {
                                provider.notifyListeners();
                                List<SongModel> newlist = [
                                  ...provider.favoriteNotifier
                                ];

                                await Provider.of<GetSongs>(context,
                                        listen: false)
                                    .player
                                    .setAudioSource(
                                        Provider.of<GetSongs>(context,
                                                listen: false)
                                            .createSongList(newlist),
                                        initialIndex: index);

                                await Provider.of<ShowMiniPlayer>(context,
                                        listen: false)
                                    .updateMiniPlayer(songlist: newlist);

                                await Provider.of<GetSongs>(context,
                                        listen: false)
                                    .player
                                    .play();
                              },
                              leading: QueryArtworkWidget(
                                artworkBorder: BorderRadius.circular(4),
                                id: provider.favoriteNotifier[index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note_rounded,
                                  color: Colors.black54,
                                  size: 52,
                                ),
                              ),
                              title: Text(
                                provider.favoriteNotifier[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                provider.favoriteNotifier[index].artist!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    provider.notifyListeners();
                                    provider.delete(
                                        provider.favoriteNotifier[index].id);
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                })),
        ),
      ),
    );
  }
}
