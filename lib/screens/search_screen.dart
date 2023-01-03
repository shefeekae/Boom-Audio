import 'package:flutter/material.dart';

import 'package:music_app/functions/get_songs.dart';

import 'package:music_app/widgets/favorite_button.dart';
import 'package:music_app/widgets/neu_box_widget.dart';
import 'package:music_app/screens/song_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../functions/show_miniplayer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.grey[300],
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            style: const TextStyle(height: 1),
            decoration: InputDecoration(
                labelText: 'Your Songs',
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
            onChanged: (value) => _runFilter(value),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 100,
                        child: NeuBox(
                          child: ListTile(
                            key: ValueKey(_foundSongs[index]),
                            leading: QueryArtworkWidget(
                              artworkBorder: BorderRadius.circular(4),
                              nullArtworkWidget: const Icon(
                                Icons.music_note,
                                size: 52,
                              ),
                              artworkFit: BoxFit.cover,
                              id: _foundSongs[index].id,
                              type: ArtworkType.AUDIO,
                            ),
                            title: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                _foundSongs[index].title,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            subtitle: Text(_foundSongs[index].artist!),
                            trailing: FavoriteButton(song: _foundSongs[index]),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              GetSongs.player.setAudioSource(
                                  GetSongs.createSongList(_foundSongs),
                                  initialIndex: index);
                              GetSongs.player.play();

                              ShowMiniPlayer.updateMiniPlayer(
                                  songlist: GetSongs.playingSongs);
                            },
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return const Divider();
                    },
                    itemCount: _foundSongs.length)
              ],
            ),
          ),
        ),
      ]),
    ));
  }

  // This list holds the data for the list view
  List<SongModel> _foundSongs = [];

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = SongLibrary.songs;
    } else {
      results = SongLibrary.songs
          .where((SongModel item) =>
              item.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    //refresh the UI
    setState(() {
      _foundSongs = results;
    });
  }
}
