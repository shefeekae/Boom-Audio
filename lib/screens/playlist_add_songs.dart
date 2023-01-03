import 'package:flutter/material.dart';
import 'package:music_app/database/song_db.dart';
import 'package:music_app/widgets/neu_box_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key, required this.playlist});
  final Songs playlist;
  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
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
                          return NeuBox(
                              child: ListTile(
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
                                  title: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                          item.data![index].displayNameWOExt)),
                                  subtitle: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child:
                                          Text("${item.data![index].artist}")),
                                  trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          playlistCheck(item.data![index]);
                                          //     playlistnotifier.notifyListeners();
                                        });
                                      },
                                      icon: !widget.playlist
                                              .isValueIn(item.data![index].id)
                                          ? const Icon(Icons.add)
                                          : const Icon(Icons.remove_circle),
                                      color: !widget.playlist
                                              .isValueIn(item.data![index].id)
                                          ? Colors.black
                                          : Colors.red)));
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

  void playlistCheck(SongModel data) {
    if (!widget.playlist.isValueIn(data.id)) {
      widget.playlist.add(data.id);
      // const snackbar = SnackBar(
      //     backgroundColor: Colors.black,
      //     content: Text(
      //       'Added to Playlist',
      //       style: TextStyle(color: Colors.white),
      //     ));
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      widget.playlist.deleteData(data.id);
      // const snackbar = SnackBar(
      //   backgroundColor: Colors.black,
      //   content: Text(
      //     'Song Deleted',
      //     style: TextStyle(color: Colors.red),
      //   ),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
