import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetSongs extends ChangeNotifier {
  AudioPlayer player = AudioPlayer();
  int currentIndex = 0;
  List<SongModel> songsCopy = [];
  List<SongModel> playingSongs = [];

  //duration state stream
  // Stream<DurationState> get _durationStateStream =>
  //     Rx.combineLatest2<Duration, Duration?, DurationState>(
  //         player.positionStream,
  //         player.durationStream,
  //         (position, duration) => DurationState(
  //             position: position, total: duration ?? Duration.zero));

  ConcatenatingAudioSource createSongList(List<SongModel> songs) {
    List<AudioSource> sources = [];
    playingSongs = songs;
    for (var song in songs) {
      sources.add(AudioSource.uri(
        Uri.parse(song.uri!),
        tag: MediaItem(
            id: song.id.toString(),
            title: song.title,
            album: song.album,
            artist: song.artist),
      ));
    }
    return ConcatenatingAudioSource(children: sources);
  }
}
