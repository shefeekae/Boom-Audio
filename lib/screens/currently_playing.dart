// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:music_app/functions/get_songs.dart';
import 'package:music_app/widgets/favorite_button.dart';
import 'package:music_app/widgets/animated_text.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../functions/duration_state.dart';
import '../widgets/neu_box_widget.dart';

// ignore: must_be_immutable
class CurrentlyPlaying extends StatefulWidget {
  const CurrentlyPlaying({Key? key, required this.playerSong})
      : super(key: key);
  final List<SongModel> playerSong;

  @override
  State<CurrentlyPlaying> createState() => _CurrentlyPlayingState();
}

// ValueNotifier<List<SongModel>> playingSongNotifier = ValueNotifier([]);

class _CurrentlyPlayingState extends State<CurrentlyPlaying> {
  int currentIndex = 0;

  //volume control
  double currentVol = 0.5;

  //duration state stream
  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          Provider.of<GetSongs>(context, listen: false).player.positionStream,
          Provider.of<GetSongs>(context, listen: false).player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  @override
  void initState() {
    Provider.of<GetSongs>(context, listen: false)
        .player
        .currentIndexStream
        .listen((index) {
      if (index != null && mounted) {
        // _updateCurrentPlayingSongDetails(index);
        setState(() {
          currentIndex = index;
        });
        Provider.of<GetSongs>(context, listen: false).currentIndex = index;
      }
    });
    super.initState();
  }

  @override

  //dispose the player
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //height and width

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<GetSongs>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth / 20, vertical: screenHeight / 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // back button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: screenHeight / 16,
                        width: screenWidth / 8,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const NeuBox(child: Icon(Icons.arrow_back)),
                        ),
                      ),
                      const Text('N O W  P L A Y I N G'),
                      SizedBox(
                        height: screenHeight / 16,
                        width: screenWidth / 8,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight / 40,
                  ),

                  //album art

                  Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth / 20),
                        child: SizedBox(
                          height: screenHeight / 2.5,
                          width: screenWidth / 1,
                          child: NeuBox(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: QueryArtworkWidget(
                                    id: widget.playerSong[currentIndex].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: const Icon(
                                        Icons.music_note_rounded,
                                        color: Colors.black54,
                                        size: 150),
                                    artworkHeight: screenHeight / 2.5,
                                    artworkWidth: screenWidth / 1,
                                    artworkBorder: BorderRadius.circular(8),
                                  ))),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 20,
                      ),

                      //Song name, Artist Name and Favourites icon

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AnimatedText(
                                  defaultAlignment: TextAlign.start,
                                  text: widget.playerSong[currentIndex].title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                AnimatedText(
                                  defaultAlignment: TextAlign.start,
                                  text: widget.playerSong[currentIndex].artist
                                              .toString() ==
                                          "Unknown"
                                      ? "Unknown Artist"
                                      : widget.playerSong[currentIndex].artist
                                          .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // FavoriteButton(song: SongLibrary.songs[currentIndex]),
                          FavoriteButton(song: widget.playerSong[currentIndex])
                        ],
                      ),
                      SizedBox(
                        height: screenHeight / 40,
                      ),

                      // linear bar

                      StreamBuilder<DurationState>(
                          stream: _durationStateStream,
                          builder: ((context, snapshot) {
                            final durationState = snapshot.data;
                            final progress =
                                durationState?.position ?? Duration.zero;
                            final total = durationState?.total ?? Duration.zero;

                            return ProgressBar(
                              progress: progress,
                              total: total,
                              baseBarColor: Colors.grey.shade400,
                              progressBarColor: Colors.red,
                              thumbColor: Colors.white,
                              timeLabelTextStyle: const TextStyle(
                                fontSize: 0,
                              ),
                              onSeek: (duration) {
                                provider.player.seek(duration);
                              },
                            );
                          })),

                      //position / progress and total text

                      //start time & end time

                      StreamBuilder<DurationState>(
                        stream: _durationStateStream,
                        builder: (context, snapshot) {
                          final durationState = snapshot.data;
                          final progress =
                              durationState?.position ?? Duration.zero;
                          final total = durationState?.total ?? Duration.zero;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: Text(
                                progress
                                    .toString()
                                    .substring(2, 7)
                                    .split(".")[0],
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              )),
                              Flexible(
                                  child: Text(
                                total.toString().substring(2, 7).split(".")[0],
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ))
                            ],
                          );
                        },
                      ),

                      SizedBox(
                        height: screenHeight / 80,
                      ),

                      // shuffle button, repeat button

                      //shuffle button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                              onTap: () {
                                if (provider.player.shuffleModeEnabled) {
                                  provider.player.setShuffleModeEnabled(false);
                                } else {
                                  provider.player.setShuffleModeEnabled(true);
                                }
                              },
                              child: StreamBuilder(
                                stream:
                                    provider.player.shuffleModeEnabledStream,
                                builder: (context, snapshot) {
                                  if (provider.player.shuffleModeEnabled) {
                                    return const Icon(
                                      Icons.shuffle,
                                      color: Colors.red,
                                    );
                                  }
                                  return const Icon(Icons.shuffle);
                                },
                              )),

                          //Repeat Button
                          InkWell(
                              onTap: () {
                                provider.player.loopMode == LoopMode.one
                                    ? provider.player.setLoopMode(LoopMode.all)
                                    : provider.player.setLoopMode(LoopMode.one);
                              },
                              child: StreamBuilder<LoopMode>(
                                stream: provider.player.loopModeStream,
                                builder: (context, snapshot) {
                                  final loopMode = snapshot.data;
                                  if (LoopMode.one == loopMode) {
                                    return const Icon(
                                      Icons.repeat,
                                      color: Colors.red,
                                    );
                                  }
                                  return const Icon(Icons.repeat);
                                },
                              )),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight / 40,
                      ),

                      // previous, pause/play , next

                      SizedBox(
                        height: screenHeight / 12,
                        child: Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                provider.player.currentIndexStream
                                    .listen((index) {
                                  if (index != null && mounted) {
                                    // _updateCurrentPlayingSongDetails(index);
                                    setState(() {
                                      currentIndex = index;
                                    });
                                    provider.currentIndex = index;
                                  }
                                  // updateMiniPlayer();
                                  // playingSongNotifier.notifyListeners();
                                });

                                if (provider.player.hasPrevious) {
                                  provider.player.seekToPrevious();
                                }
                              },
                              child: const NeuBox(
                                child: Icon(
                                  Icons.skip_previous,
                                  size: 32,
                                ),
                              ),
                            )),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: InkWell(
                                    onTap: () {
                                      provider.player.currentIndexStream
                                          .listen((index) {
                                        if (index != null && mounted) {
                                          // _updateCurrentPlayingSongDetails(index);
                                          setState(() {
                                            currentIndex = index;
                                          });
                                          provider.currentIndex = index;
                                        }
                                        // updateMiniPlayer();
                                        // playingSongNotifier.notifyListeners();
                                      });

                                      if (provider.player.playing) {
                                        provider.player.pause();
                                      } else {
                                        if (provider.player.currentIndex !=
                                            null) {
                                          provider.player.play();
                                        }
                                      }
                                    },
                                    child: NeuBox(
                                        child: StreamBuilder<bool>(
                                            stream:
                                                provider.player.playingStream,
                                            builder: ((context, snapshot) {
                                              bool? playingState =
                                                  snapshot.data;
                                              if (playingState != null &&
                                                  playingState) {
                                                return const Icon(
                                                  Icons.pause,
                                                  size: 32,
                                                );
                                              }
                                              return const Icon(
                                                Icons.play_arrow,
                                                size: 42,
                                              );
                                            }))),
                                  ),
                                )),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                provider.player.currentIndexStream
                                    .listen((index) {
                                  if (index != null && mounted) {
                                    // _updateCurrentPlayingSongDetails(index);
                                    setState(() {
                                      currentIndex = index;
                                    });
                                    provider.currentIndex = index;
                                  }
                                  // updateMiniPlayer();
                                  // playingSongNotifier.notifyListeners();
                                });

                                if (provider.player.hasNext) {
                                  provider.player.seekToNext();
                                }
                              },
                              child: const NeuBox(
                                child: Icon(
                                  Icons.skip_next,
                                  size: 32,
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),

                      SizedBox(
                        height: screenHeight / 30,
                      ),

                      //volume down, volume control bar, volume up

                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.volume_down),
                            SizedBox(
                              width: screenWidth / 1.3,
                              child: Slider(
                                  activeColor: Colors.red,
                                  inactiveColor: Colors.grey.shade400,
                                  thumbColor: Colors.white,
                                  value: currentVol,
                                  onChanged: (volume) {
                                    currentVol = volume;
                                    PerfectVolumeControl.setVolume(volume);
                                    setState(() {});
                                  }),
                            ),
                            const Icon(Icons.volume_up)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 20,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
