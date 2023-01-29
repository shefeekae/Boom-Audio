import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:music_app/database/playlist_functions.dart';
import 'package:music_app/database/song_db.dart';
import 'package:music_app/functions/show_miniplayer.dart';
import 'package:music_app/screens/currently_playing.dart';
import 'package:music_app/widgets/like_text_button.dart';
import 'package:music_app/widgets/mini_player.dart';
import 'package:music_app/widgets/neu_box_widget.dart';
import 'package:music_app/screens/playlist_add_songs.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../functions/get_songs.dart';

class PlaylistFolder extends StatelessWidget {
  PlaylistFolder(
      {super.key, required this.playlist, required this.folderIndex});

  final Songs playlist;
  final int folderIndex;
  late List<SongModel> playlistSong;

  @override
  Widget build(BuildContext context) {
    // PlaylistDB.getPlaylist();
    Provider.of<PlaylistDB>(context).getPlaylist();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.grey[300],
        elevation: 0,
      ),
      bottomNavigationBar: Consumer<ShowMiniPlayer>(
        builder: (context, provider, child) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (Provider.of<GetSongs>(context, listen: false)
                    .player
                    .currentIndex !=
                null)
              Miniplayer(
                minHeight: 60,
                maxHeight: 60,
                builder: (height, percentage) {
                  return MiniPlayerWidget(
                    miniPlayerSong: provider.miniPlayerNotifier,
                  );
                },
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SafeArea(
              child: Column(
            children: [
              Text(
                playlist.name.toUpperCase(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SongListPage(playlist: playlist),
                    ));
                  },
                  child: const Text(
                    'Add Songs',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Consumer<PlaylistDB>(
                builder: (context, provider, child) {
                  playlistSong = provider.listPlaylist(
                      provider.boxNotifier.values.toList()[folderIndex].songIds,
                      context);

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return NeuBox(
                          child: ListTile(
                        onTap: () async {
                          List<SongModel> newList = [...playlistSong];

                          await Provider.of<GetSongs>(context, listen: false)
                              .player
                              .setAudioSource(
                                  Provider.of<GetSongs>(context, listen: false)
                                      .createSongList(newList),
                                  initialIndex: index);

                          await Provider.of<ShowMiniPlayer>(context,
                                  listen: false)
                              .updateMiniPlayer(songlist: newList);

                          await Provider.of<GetSongs>(context, listen: false)
                              .player
                              .play();
                        },
                        leading: QueryArtworkWidget(
                          artworkBorder: BorderRadius.circular(4),
                          id: playlistSong[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note_rounded,
                            color: Colors.black54,
                            size: 52,
                          ),
                        ),
                        title: Text(
                          playlistSong[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          playlistSong[index].artist!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        trailing: PopupMenuButton(
                          color: Colors.grey[300],
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                  value: 1,
                                  child: FavoriteTextButton(
                                      song: playlistSong[index])),
                              PopupMenuItem(
                                  value: 2,
                                  child: TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.grey[300],
                                              title: const Text('Remove Song'),
                                              content: const Text(
                                                  'Are you sure you want to remove this song ? '),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      playlist.deleteData(
                                                          playlistSong[index]
                                                              .id);
                                                      Navigator.pop(context);
                                                      provider
                                                          .notifyListeners();
                                                    },
                                                    child: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )),
                                              ],
                                            );
                                          },
                                        ).then((value) {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: const Text(
                                        'Delete from playlist',
                                        style: TextStyle(color: Colors.red),
                                      )))
                            ];
                          },
                          onSelected: (value) {},
                        ),
                      ));
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: playlistSong.length,
                  );
                },
              )
            ],
          )),
        ),
      ),
    );
  }
}
