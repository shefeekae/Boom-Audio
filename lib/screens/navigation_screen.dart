// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:music_app/database/favorite_functions.dart';
import 'package:music_app/functions/get_songs.dart';

import 'package:music_app/screens/currently_playing.dart';

import 'package:music_app/screens/favorites_page.dart';
import 'package:music_app/screens/playlist_screen.dart';
import 'package:music_app/screens/search_screen.dart';

import 'package:music_app/screens/song_list.dart';
import 'package:music_app/widgets/mini_player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> screens = <Widget>[
    const SongLibrary(),
    const FavoritesPage(),
    const PlaylistScreen(),
    const SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: playingSongNotifier,
        builder: (context, List<SongModel> music, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (GetSongs.player.currentIndex != null)
              ValueListenableBuilder(
                  valueListenable: playingSongNotifier,
                  builder: (BuildContext context, playingSong, child) {
                    return Miniplayer(
                      minHeight: 60,
                      maxHeight: 60,
                      builder: (height, percentage) {
                        // return MiniplayerWillPopScope(
                        //     child: child, onWillPop: onWillPop);

                        return MiniPlayerWidget(
                          miniPlayerSong: GetSongs.playingSongs,
                        );
                      },
                    );
                  })
            else
              const SizedBox.shrink(),
            const Divider(
              height: 1,
              color: Colors.black87,
            ),
            BottomNavigationBar(
              backgroundColor: Colors.black87,
              elevation: 0,
              currentIndex: _currentIndex,
              fixedColor: Colors.red,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'Favourite'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.headphones), label: 'Playlist'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search')
              ],
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  FavoriteDB.favoriteSongs.notifyListeners();
                  playingSongNotifier.notifyListeners();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
