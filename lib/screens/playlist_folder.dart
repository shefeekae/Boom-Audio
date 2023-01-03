import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
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

import '../functions/get_songs.dart';

class PlaylistFolder extends StatefulWidget {
  const PlaylistFolder(
      {super.key, required this.playlist, required this.folderIndex});

  final Songs playlist;
  final int folderIndex;
  @override
  State<PlaylistFolder> createState() => _PlaylistFolderState();
}

class _PlaylistFolderState extends State<PlaylistFolder> {
  late List<SongModel> playlistSong;

  @override
  Widget build(BuildContext context) {
    PlaylistDB.getPlaylist();
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
                        return MiniPlayerWidget(
                          miniPlayerSong: playingSong,
                        );
                      },
                    );
                  })
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
                widget.playlist.name.toUpperCase(),
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
                      builder: (context) =>
                          SongListPage(playlist: widget.playlist),
                    ));
                  },
                  child: const Text(
                    'Add Songs',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: Hive.box<Songs>('playlistDB').listenable(),
                builder: (context, Box<Songs> value, child) {
                  playlistSong = listPlaylist(
                      value.values.toList()[widget.folderIndex].songIds);

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return NeuBox(
                          child: ListTile(
                        onTap: () async {
                          List<SongModel> newList = [...playlistSong];

                          await GetSongs.player.setAudioSource(
                              GetSongs.createSongList(newList),
                              initialIndex: index);

                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) =>
                          //       CurrentlyPlaying(playerSong: playlistSong),
                          // ));

                          await ShowMiniPlayer.updateMiniPlayer(
                              songlist: newList);

                          await GetSongs.player.play();
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
                        title: Text(playlistSong[index].title),
                        subtitle: Text(playlistSong[index].artist!),
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
                                                      widget.playlist
                                                          .deleteData(
                                                              playlistSong[
                                                                      index]
                                                                  .id);
                                                      Navigator.pop(context);
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

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plSongs = [];
    for (int i = 0; i < GetSongs.songsCopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (GetSongs.songsCopy[i].id == data[j]) {
          plSongs.add(GetSongs.songsCopy[i]);
        }
      }
    }
    return plSongs;
  }
}
