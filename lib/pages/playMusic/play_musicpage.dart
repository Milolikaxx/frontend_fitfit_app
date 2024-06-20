import 'dart:developer';
import 'dart:ffi';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:frontend_fitfit_app/model/response/playlsit_music_get_res.dart';
// import 'package:frontend_fitfit_app/model/response/playlsit_with_wp_workoutprofile_get_res.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

// ignore: must_be_immutable
class PlayMusicPage extends StatefulWidget {
  int pid = 0;
  PlayMusicPage(this.pid, {super.key});

  @override
  State<PlayMusicPage> createState() => _PlayMusicPageState();
}

class Musicdata {
  final String mLink;
  final String name;
  final String musicImage;
  final String artist;
  final double duration;
  final int bpm;

  Musicdata(
    this.mLink,
    this.name,
    this.musicImage,
    this.artist,
    this.duration,
    this.bpm,
  );
}

class _PlayMusicPageState extends State<PlayMusicPage> {
  late var loadData;
  late PlaylistService playlistService;
  late PlaylsitMusicGetResponse music_pl;
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  List<Musicdata> musicList = [];
  ConcatenatingAudioSource? playlist;

  late String currentMusicName;
  late String currentMusicImage;
  late String currentMusicArtist;
  late double currentMusicDuration;
  late int currentMusicBpm;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    playlistService = context.read<AppData>().playlistService;

    loadData = loadDataAsync();
    _audioPlayer = AudioPlayer();
    init();
  }

  loadDataAsync() async {
    try {
      music_pl = await playlistService.getPlaylistMusicByPid(widget.pid);
      // log(widget.pid.toString());
    } catch (e) {
      log(e.toString());
    }
    for (var m in music_pl.playlistDetail) {
      musicList.add(Musicdata(m.music.mLink, m.music.name, m.music.musicImage,
          m.music.artist, m.music.duration, m.music.bpm));
    }
    playlist = ConcatenatingAudioSource(
      children: musicList
          .map((music) => AudioSource.uri(Uri.parse(music.mLink), tag: {
                'name': music.name,
                'musicImage': music.musicImage,
                'artist': music.artist,
                'duration': music.duration,
                'bpm': music.bpm,
              }))
          .toList(),
    );
    // for (var m in musicList) {
    //   log(m.name);
    // }
    init();
  }

  Future<void> init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(playlist!);
  }

  void updateCurrentMusic(int index) {
    setState(() {
      // Update current music data based on index
      Musicdata currentMusic = musicList[index];
      currentMusicName = currentMusic.name;
      currentMusicImage = currentMusic.musicImage;
      currentMusicArtist = currentMusic.artist;
      currentMusicDuration = currentMusic.duration;
      currentMusicBpm = currentMusic.bpm;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: LoadingAnimationWidget.beat(
                color: Colors.black,
                size: 50,
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              timerCounter(),
              circleImage(),
              detailMusic(),
              timeBar(),
              controller(),
            ],
          );
        },
      ),
    );
  }

  Widget timerCounter() {
    return TimerCountdown(
      format: CountDownTimerFormat.hoursMinutesSeconds,
      endTime: DateTime.now().add(
        const Duration(
          hours: 10,
          minutes: 10,
          seconds: 10,
        ),
      ),
      onEnd: () {
        log("Timer finished");
      },
      timeTextStyle: const TextStyle(
        color: Colors.white, // กำหนดสีตัวหนังสือเป็นสีขาว
        fontSize: 20, // กำหนดขนาดตัวหนังสือ
      ),
    );
  }

  Widget circleImage() {
    return Container(
      width: 300,
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
            // image: DecorationImage(
            //   image: NetworkImage(""),
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
      ),
    );
  }

  Widget detailMusic() {
    return Row(
      children: [Text("ชื่อเพลง : ")],
    );
  }

  Widget controller() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Align icons in the center horizontally
      children: [
        IconButton(
          onPressed: _audioPlayer.seekToPrevious,
          icon: const Icon(
            Icons.skip_previous,
            color: Colors.white,
            size: 40,
          ),
        ),
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            iconSize: 50,
            onPressed: () async {
              setState(() {
                isPlaying = !isPlaying;
              });
              if (isPlaying) {
                await _audioPlayer.play();
              } else {
                await _audioPlayer.pause();
              }
            },
          ),
        ),
        IconButton(
          onPressed: _audioPlayer.seekToNext,
          icon: const Icon(
            Icons.skip_next,
            color: Colors.white,
            size: 40,
          ),
        ),
      ],
    );
  }

  Widget timeBar() {
    return SizedBox(
      width: 250,
      child: StreamBuilder<PositionData>(
        stream: _positionDataStream,
        builder: (context, snapshot) {
          final positionData = snapshot.data;
          return ProgressBar(
            barHeight: 8,
            baseBarColor: Colors.white,
            bufferedBarColor: Colors.white70, // สีที่อ่อนลงสำหรับ buffered bar
            progressBarColor: Colors.white,
            thumbColor: Colors.white,
            timeLabelTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            progress: positionData?.position ?? Duration.zero,
            buffered: positionData?.bufferedPosition ?? Duration.zero,
            total: positionData?.duration ?? Duration.zero,
            onSeek: _audioPlayer.seek,
          );
        },
      ),
    );
  }
}

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}
