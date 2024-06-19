import 'dart:developer';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
// import 'package:frontend_fitfit_app/model/response/playlsit_with_wp_workoutprofile_get_res.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class PlayMusicPage extends StatefulWidget {
  int pid = 0;
  PlayMusicPage(this.pid, {super.key});

  @override
  State<PlayMusicPage> createState() => _PlayMusicPageState();
}

class _PlayMusicPageState extends State<PlayMusicPage> {
  late var loadData;
  late PlaylistService playlistService;

  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  final playlist = ConcatenatingAudioSource(children: [
    AudioSource.uri(Uri.parse(
        "http://202.28.34.197:8888/contents/e0891202-9565-4602-98d6-c2b3fee0a471.mp3")),
    // AudioSource.uri(Uri.parse(
    //     "https://firebasestorage.googleapis.com/v0/b/equalized-audio.appspot.com/o/NewJeans%2FAttention.m4a?alt=media&token=e9119000-9f63-4c39-8661-4b00c579d407")),
    // AudioSource.uri(Uri.parse(
    //     "https://firebasestorage.googleapis.com/v0/b/equalized-audio.appspot.com/o/NewJeans%2FDitto.m4a?alt=media&token=438ef6e6-6509-4505-a92d-a30f70969858")),
    // AudioSource.uri(Uri.parse(
    //     "https://firebasestorage.googleapis.com/v0/b/equalized-audio.appspot.com/o/NewJeans%2FHurt.m4a?alt=media&token=d48989b7-3d7a-4703-b4d7-c0976bd0d2a8")),
  ]);

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
      await playlistService.getPlaylistWithOutMusicByPid(widget.pid);
      log(widget.pid.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(playlist);
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              timerCounter(),
              circleImage(),
              timeBar(),
              controller(),
            ],
          ),
        ],
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
          decoration: const BoxDecoration(
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
      width: 200,
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

// AudioSource.uri(Uri.parse(
//     "http://202.28.34.197:8888/contents/e0891202-9565-4602-98d6-c2b3fee0a471.mp3")),
// AudioSource.uri(Uri.parse(
//     "http://202.28.34.197:8888/contents/53dc392b-53be-4192-aa37-60e28bd1f741.mp3")),
// AudioSource.uri(Uri.parse(
//     "http://202.28.34.197:8888/contents/8e07089f-2288-47f0-8419-df84f46c74ab.mp3")),
