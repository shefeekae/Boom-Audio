import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/database/song_db.dart';
import 'package:music_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import '../database/favorite_functions.dart';

class ResetApp {
  static Future<void> appReset(context) async {
    final playListDb = Hive.box<Songs>('playlistDB');
    final musicDb = Hive.box<int>('favoriteDB');
    await musicDb.clear();
    await playListDb.clear();
    // FavoriteDB.favoriteSongs.value.clear();
    Provider.of<FavoriteDB>(context, listen: false).favoriteNotifier.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false);
  }
}
