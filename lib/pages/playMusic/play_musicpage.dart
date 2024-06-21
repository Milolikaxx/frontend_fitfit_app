import 'dart:developer';
// import 'dart:ffi';
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
import 'dart:async';

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
  bool isCountdownFinished = false;
  int countdown = 3; // Countdown timer initial value
  List<Musicdata> musicList = [];
  ConcatenatingAudioSource? playlist;
  int currentIndex = 0;
  late Duration totalDuration; // Total duration of all songs

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

    _audioPlayer = AudioPlayer();
    _audioPlayer.currentIndexStream.listen((index) {
      setState(() {
        currentIndex = index ?? 0;
      });
    });

    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      music_pl = await playlistService.getPlaylistMusicByPid(widget.pid);
      // log(widget.pid.toString());
    } catch (e) {
      log(e.toString());
    }
    // totalDuration = Duration.zero; // Initialize total duration
    for (var m in music_pl.playlistDetail) {
      final music = Musicdata(m.music.mLink, m.music.name, m.music.musicImage,
          m.music.artist, m.music.duration, m.music.bpm);
      musicList.add(music);
      // totalDuration += Duration(
      //     seconds: (music.duration * 60).toInt()); // Add each song's duration
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
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(playlist!);
    fullTime();
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
      });
      if (countdown == 0) {
        timer.cancel();
        setState(() {
          isCountdownFinished = true;
          isPlaying = true; // Set isPlaying to true when countdown finishes
        });
        _audioPlayer.play(); // Start playing music
      }
    });
  }

  void fullTime() {
    totalDuration = Duration.zero; // Initialize total duration
    for (var m in music_pl.playlistDetail) {
      final music = Musicdata(m.music.mLink, m.music.name, m.music.musicImage,
          m.music.artist, m.music.duration, m.music.bpm);
      musicList.add(music);
      totalDuration += Duration(
          seconds: (music.duration * 60).toInt()); // Add each song's duration
    }
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
                color: Colors.white,
                size: 50,
              ),
            );
          }
          return isCountdownFinished ? buildMusicPlayer() : buildCountdown();
        },
      ),
    );
  }

  Widget buildCountdown() {
    return Center(
      child: Text(
        '$countdown',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 50,
        ),
      ),
    );
  }

  Widget buildMusicPlayer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: timerCounter(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: circleImage(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: detailMusic(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: timeBar(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: controller(),
        ),
      ],
    );
  }

  Widget timerCounter() {
    return TimerCountdown(
      format: CountDownTimerFormat.hoursMinutesSeconds,
      endTime: DateTime.now().add(totalDuration), // Use total duration
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
            image: DecorationImage(
              image: NetworkImage(musicList[currentIndex].musicImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget detailMusic() {
    return Column(
      children: [
        Text(
          "ชื่อเพลง : ${musicList[currentIndex].name}",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        Text(
          "ศิลปิน : ${musicList[currentIndex].artist}",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
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
            progressBarColor: const Color(0xFFF8721D),
            thumbColor: const Color(0xFFF8721D),
            timeLabelTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            progress: positionData?.position ?? Duration.zero,
            buffered: positionData?.bufferedPosition ?? Duration.zero,
            total: positionData?.duration ?? Duration.zero,
            onSeek: null,
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
