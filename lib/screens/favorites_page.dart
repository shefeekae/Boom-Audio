// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';

import 'package:music_app/database/favorite_functions.dart';
import 'package:music_app/functions/get_songs.dart';
import 'package:music_app/functions/show_miniplayer.dart';

import 'package:on_audio_query/on_audio_query.dart';
import '../widgets/neu_box_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
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
        child: ValueListenableBuilder(
          valueListenable: FavoriteDB.favoriteSongs,
          builder: (BuildContext context, List<SongModel> favorData,
                  Widget? child) =>
              (FavoriteDB.favoriteSongs.value.isEmpty
                  ? const Center(
                      child: Text(
                        'No favorites found',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ValueListenableBuilder(
                      valueListenable: FavoriteDB.favoriteSongs,
                      builder: (BuildContext context, List<SongModel> favorData,
                          Widget? child) {
                        return ListView.builder(
                          itemCount: favorData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: SizedBox(
                                height: 100,
                                child: NeuBox(
                                  child: ListTile(
                                    onTap: () async {
                                      FavoriteDB.favoriteSongs
                                          .notifyListeners();
                                      List<SongModel> newlist = [...favorData];

                                      await GetSongs.player.setAudioSource(
                                          GetSongs.createSongList(newlist),
                                          initialIndex: index);

                                      await ShowMiniPlayer.updateMiniPlayer(
                                          songlist: newlist);

                                      await GetSongs.player.play();

                                      // GetSongs.player.currentIndexStream
                                      //     .listen((index) {
                                      //   if (index != null && mounted) {
                                      //     // setState(() {
                                      //     //   currentIndex = index;
                                      //     // });
                                      //     GetSongs.currentIndex = index;
                                      //   }
                                      // });
                                    },
                                    leading: QueryArtworkWidget(
                                      artworkBorder: BorderRadius.circular(4),
                                      id: favorData[index].id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: const Icon(
                                        Icons.music_note_rounded,
                                        color: Colors.black54,
                                        size: 52,
                                      ),
                                    ),
                                    title: Text(favorData[index].title),
                                    subtitle: Text(favorData[index].artist!),
                                    trailing: IconButton(
                                        onPressed: () {
                                          FavoriteDB.favoriteSongs
                                              .notifyListeners();
                                          FavoriteDB.delete(
                                              favorData[index].id);
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
