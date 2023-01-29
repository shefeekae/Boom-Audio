import 'package:flutter/material.dart';
import 'package:music_app/screens/currently_playing.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../functions/get_songs.dart';
import 'animated_text.dart';

class MiniPlayerWidget extends StatefulWidget {
  const MiniPlayerWidget({super.key, required this.miniPlayerSong});
  final List<SongModel> miniPlayerSong;

  @override
  State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
}

class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {
  int currentIndex = 0;

  @override
  void initState() {
    Provider.of<GetSongs>(context, listen: false)
        .player
        .currentIndexStream
        .listen((index) {
      if (index != null && mounted) {
        setState(() {
          currentIndex = index;
        });
        Provider.of<GetSongs>(context, listen: false).currentIndex = index;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEAEAEA),
      child: Consumer<GetSongs>(builder: (context, provider, child) {
        return ListTile(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: QueryArtworkWidget(
              artworkFit: BoxFit.fill,
              artworkBorder: BorderRadius.circular(4),
              id: widget.miniPlayerSong[currentIndex].id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: const Icon(
                Icons.music_note_rounded,
                color: Colors.black54,
                size: 52,
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(createRoute());
          },
          title: AnimatedText(
            text: provider.playingSongs[currentIndex].title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),

            // widget.miniPlayerSong[GetSongs.currentIndex].title,
          ),
          trailing: FittedBox(
            fit: BoxFit.fill,
            child: Row(
              children: [
                IconButton(
                    onPressed: () async {
                      provider.player.currentIndexStream.listen((index) {
                        if (index != null && mounted) {
                          setState(() {});
                          provider.currentIndex = index;
                        }
                      });

                      if (provider.player.playing) {
                        await provider.player.pause();
                        setState(() {});
                      } else {
                        await provider.player.play();
                        setState(() {});
                      }
                    },
                    icon: StreamBuilder<bool>(
                      stream: provider.player.playingStream,
                      builder: (context, snapshot) {
                        bool? playingStage = snapshot.data;
                        if (playingStage != null && playingStage) {
                          return const Icon(
                            Icons.pause,
                            size: 33,
                            color: Colors.black,
                          );
                        } else {
                          return const Icon(
                            Icons.play_arrow,
                            size: 35,
                            color: Colors.black,
                          );
                        }
                      },
                    )),
                IconButton(
                    onPressed: () async {
                      provider.player.currentIndexStream.listen((index) {
                        if (index != null && mounted) {
                          setState(() {});
                          provider.currentIndex = index;
                        }
                      });

                      if (provider.player.hasNext) {
                        await provider.player.seekToNext();
                        await provider.player.play();
                      } else {
                        await provider.player.play();
                      }
                    },
                    icon: const Icon(
                      Icons.skip_next,
                      size: 35,
                      color: Colors.black,
                    ))
              ],
            ),
          ),
        );
      }),
    );
  }

  Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CurrentlyPlaying(
        playerSong: Provider.of<GetSongs>(context, listen: false).playingSongs,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
