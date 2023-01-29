import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/database/favorite_functions.dart';
import 'package:music_app/database/playlist_functions.dart';
import 'package:music_app/database/song_db.dart';
import 'package:music_app/functions/get_songs.dart';
import 'package:music_app/functions/playlist_check.dart';
import 'package:music_app/functions/show_miniplayer.dart';
import 'package:music_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(SongsAdapter().typeId)) {
    Hive.registerAdapter(SongsAdapter());
  }
  await Hive.openBox<int>('favoriteDB');
  await Hive.openBox<Songs>('playlistDB');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FavoriteDB(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaylistDB(),
        ),
        ChangeNotifierProvider(
          create: (context) => CheckPlaylist(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetSongs(),
        ),
        ChangeNotifierProvider(
          create: (context) => ShowMiniPlayer(),
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
