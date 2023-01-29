// ignore_for_file: must_be_immutable, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:music_app/database/playlist_functions.dart';
import 'package:music_app/database/song_db.dart';
import 'package:music_app/functions/playlist_check.dart';
import 'package:music_app/widgets/neu_box_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SongListPage extends StatelessWidget {
  SongListPage({super.key, required this.playlist});
  final Songs playlist;
  OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Songs',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();

                            Provider.of<PlaylistDB>(context, listen: false)
                                .notifyListeners();
                          },
                          child: const Text(
                            'Done',
                            style: TextStyle(color: Colors.red),
                          )),
                    ]),
                const SizedBox(
                  height: 15,
                ),
                FutureBuilder<List<SongModel>>(
                  future: audioQuery.querySongs(
                      sortType: null,
                      orderType: OrderType.ASC_OR_SMALLER,
                      uriType: UriType.EXTERNAL,
                      ignoreCase: true),
                  builder: (context, item) {
                    if (item.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (item.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Songs found',
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }

                    return ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return NeuBox(child: Consumer<CheckPlaylist>(
                              builder: (context, provider, child) {
                            return ListTile(
                                leading: QueryArtworkWidget(
                                  artworkBorder: BorderRadius.circular(4),
                                  id: item.data![index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: const Icon(
                                    Icons.music_note_rounded,
                                    color: Colors.black54,
                                    size: 52,
                                  ),
                                  artworkFit: BoxFit.fill,
                                ),
                                title: Text(
                                  item.data![index].displayNameWOExt,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  "${item.data![index].artist}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      // provider.playlistCheck(
                                      //     item.data![index], widget.playlist);
                                      provider.playlistCheck(
                                          item.data![index], playlist);
                                      Provider.of<CheckPlaylist>(context,
                                              listen: false)
                                          .notifyListeners();
                                      //     playlistnotifier.notifyListeners();
                                    },
                                    icon: !playlist
                                            .isValueIn(item.data![index].id)
                                        ? const Icon(Icons.add)
                                        : const Icon(Icons.remove_circle),
                                    color: !playlist
                                            .isValueIn(item.data![index].id)
                                        ? Colors.black
                                        : Colors.red));
                          }));
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: item.data!.length);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
