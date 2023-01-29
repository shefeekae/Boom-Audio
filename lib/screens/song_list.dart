import 'package:flutter/material.dart';
import 'package:music_app/database/favorite_functions.dart';
import 'package:music_app/functions/get_songs.dart';
import 'package:music_app/functions/show_miniplayer.dart';
import 'package:music_app/screens/settings_screen.dart';
import 'package:music_app/widgets/favorite_button.dart';
import 'package:music_app/widgets/neu_box_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SongLibrary extends StatefulWidget {
  const SongLibrary({Key? key}) : super(key: key);
  static List<SongModel> songs = [];
  @override
  State<SongLibrary> createState() => _SongLibraryState();
}

// ValueNotifier<List<SongModel>> songListNotifier = ValueNotifier([]);
//object of PlayerFunction
// PlayerFunctions playerFunctions = PlayerFunctions();

class _SongLibraryState extends State<SongLibrary> {
  //define on audio plugin
  final OnAudioQuery _audioQuery = OnAudioQuery();

  //request permission from initStateMethod
  @override
  void initState() {
    requestStoragePermission();

    super.initState();
  }

  //dispose the player
  @override
  void dispose() {
    //  Remember to close room to avoid memory leaks.
    //  Choose the better location(page) to add this method.
    // _audioRoom.closeRoom();

    Provider.of<GetSongs>(context, listen: false).player.dispose();
    super.dispose();
  }

  requestStoragePermission() async {
    // if (!kIsWeb) {
    //   bool permissionStatus = await _audioQuery.permissionsStatus();
    //   if (!permissionStatus) {
    //     await _audioQuery.permissionsRequest();
    //   }
    //   setState(() {});
    // }
    await Permission.storage.request();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //Song Library

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text(
          'Songs',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ));
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ))
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<SongModel>>(
                future: _audioQuery.querySongs(
                    sortType: null,
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    ignoreCase: true),
                builder: (context, item) {
                  //loading content indicator
                  if (item.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  //no songs found
                  if (item.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Songs found',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  //add songs to the song list
                  SongLibrary.songs.clear();
                  SongLibrary.songs = item.data!;

                  if (!Provider.of<FavoriteDB>(context, listen: false)
                      .isInitialized) {
                    Provider.of<FavoriteDB>(context, listen: false)
                        .initialise(item.data!);
                  }

                  Provider.of<GetSongs>(context, listen: false).songsCopy =
                      item.data!;

                  // updateSongList(songList: item.data!);

                  //showing the songs

                  return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: SizedBox(
                          height: 100,
                          child: NeuBox(child: Consumer<GetSongs>(
                              builder: (context, provider, child) {
                            return ListTile(
                              title: Text(
                                item.data![index].title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                item.data![index].artist!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              trailing: FavoriteButton(song: item.data![index]),
                              leading: QueryArtworkWidget(
                                artworkBorder: BorderRadius.circular(4),
                                id: item.data![index].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const Icon(
                                  Icons.music_note_rounded,
                                  color: Colors.black54,
                                  size: 52,
                                ),
                              ),
                              onTap: () async {
                                //show the player view

                                // playingSongNotifier.notifyListeners();

                                List<SongModel> newlist = [...item.data!];

                                await provider.player.setAudioSource(
                                    provider.createSongList(newlist),
                                    initialIndex: index);

                                await Provider.of<ShowMiniPlayer>(context,
                                        listen: false)
                                    .updateMiniPlayer(songlist: newlist);

                                await provider.player.play();

                                // GetSongs.player.currentIndexStream
                                //     .listen((index) {
                                //   if (index != null && mounted) {
                                //     // setState(() {
                                //     //   // currentIndex = index;
                                //     // });
                                //     GetSongs.currentIndex = index;
                                //   }
                                // });
                              },
                            );
                          })),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // updateSongList({required List<SongModel> songList}) {
  //   songListNotifier.value.clear();
  //   songListNotifier.value.addAll(songList);
  //   songListNotifier.notifyListeners();
  // }

}

//duration class

// class DurationState {
//   Duration position, total;
//   DurationState({this.position = Duration.zero, this.total = Duration.zero});
// }
