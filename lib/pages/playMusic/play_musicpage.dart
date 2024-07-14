import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:frontend_fitfit_app/model/response/playlsit_music_get_res.dart';
import 'package:frontend_fitfit_app/pages/afterExercise/after_exercise.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart' as rx;

// ignore: must_be_immutable
class PlayMusicPage extends StatefulWidget {
  int pid = 0;
  int wpid = 0;
  PlayMusicPage(this.pid, this.wpid, {super.key});

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
  Timer? countdownTimer;
  late DateTime endTime; // Persistent reference for the end time

  double setVolumeValue = 0;
  Stream<PositionData> get _positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
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
      adjustVolumeBasedOnBPM(currentIndex);
    });
    FlutterVolumeController.getVolume()
        .then((volume) => setVolumeValue = volume ?? 0.0);
    // Listen to system volume change
    FlutterVolumeController.addListener((volume) {
      setState(() =>
          // set is value in listener value
          setVolumeValue = volume);
    });
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      music_pl = await playlistService.getPlaylistMusicByPid(widget.pid);
      log("play pid : ${widget.pid}");
      for (var m in music_pl.playlistDetail) {
        final music = Musicdata(m.music.mLink, m.music.name, m.music.musicImage,
            m.music.artist, m.music.duration, m.music.bpm);
        musicList.add(music);
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
      await _audioPlayer.setLoopMode(LoopMode.off);
      await _audioPlayer.setAudioSource(playlist!);
      fullTime();
      startCountdown();
    } catch (e) {
      log(e.toString());
    }
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
      });
      if (countdown == 0) {
        timer.cancel();
        setState(() {
          isCountdownFinished = true;
          isPlaying = true; // Set isPlaying to true when countdown finishes
        });
        _audioPlayer.play();
        endTime = DateTime.now().add(totalDuration); // Set end time once
      }
    });
  }

  void fullTime() {
    totalDuration = Duration(
      minutes: (music_pl.totalDuration).toInt(),
      seconds: ((music_pl.totalDuration % 1) * 60).toInt(),
    );
  }

  Future<void> adjustVolumeBasedOnBPM(int index) async {
    log("เพิ่มลด เสียง");
    if (musicList.isNotEmpty && index < musicList.length) {
      final bpm = musicList[index].bpm;
      double volume;
      if (bpm <= 100) {
        volume = 0.40;
      } else if (bpm <= 114) {
        volume = 0.60;
      } else if (bpm <= 133) {
        volume = 0.70;
      } else if (bpm <= 152) {
        volume = 0.80;
      } else if (bpm <= 171) {
        volume = 1.0;
      } else {
        volume = 1.0;
      }
      log("Adjusted volume for BPM  เพลง ${musicList[index].name} $bpm: $volume");
      await _audioPlayer.setVolume(volume);
      setVolumeValue = volume;
      FlutterVolumeController.setVolume(setVolumeValue);
    } else {
      log("No music or invalid currentIndex: ${musicList.length}, $currentIndex");
    }
  }

  double calculateVolume(int bpm) {
    if (bpm <= 100) {
      return 0.4;
    } else if (bpm <= 114) {
      return 0.4 +
          (bpm - 100) * 0.02; // Linear interpolation for smoother transition
    } else if (bpm <= 133) {
      return 0.6 + (bpm - 114) * 0.02;
    } else if (bpm <= 152) {
      return 0.7 + (bpm - 133) * 0.02;
    } else if (bpm <= 171) {
      return 0.8 + (bpm - 152) * 0.02;
    } else {
      return 1.0;
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    countdownTimer?.cancel();
    FlutterVolumeController.removeListener();
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: detailMusic(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: timeBar(),
        ),
        volume(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: controller(),
        ),
        showVolumeSystem(),
        Padding(
          padding: const EdgeInsets.all(1),
          child: stopButton(),
        ),
      ],
    );
  }

  Widget volume() {
    return SizedBox(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('volume: ${setVolumeValue.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white)),
          Row(
            children: [
              const Icon(
                Icons.volume_up_rounded,
                color: Colors.white,
              ),
              SizedBox(
                width: 100,
                child: Flexible(
                  child: Slider(
                    min: 0,
                    max: 1,
                    activeColor: const Color(0xFFF8721D),
                    onChanged: (double value) async {
                      setState(() {});
                    },
                    value: setVolumeValue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox showVolumeSystem() {
    return SizedBox(
      width: 500,
      child: SwitchListTile.adaptive(
        title: const Text(
          'Show volume system UI',
          style: TextStyle(
              color: Colors.white), // Set the color for the title text
        ),
        value: FlutterVolumeController.showSystemUI,
        onChanged: (val) async {
          // Change the state of volume controller
          await FlutterVolumeController.updateShowSystemUI(val);
          setState(() {});
        },
        activeColor:
            const Color(0xFFF8721D), // Set the active color for the switch
        inactiveThumbColor:
            Colors.grey, // Set the inactive thumb color for the switch
      ),
    );
  }

  Widget timerCounter() {
    return TimerCountdown(
      format: CountDownTimerFormat.hoursMinutesSeconds,
      endTime: endTime, // Use the persistent end time
      onEnd: () {
        log("Timer finished");
        _audioPlayer.stop();
        Get.to(() => AfterExercisePage(widget.pid, widget.wpid));
      },
      timeTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }

  Widget circleImage() {
    return Container(
      width: 300,
      height: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 280,
          height: 240,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ชื่อเพลง : ${musicList[currentIndex].name}",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        Text(
          "ศิลปิน : ${musicList[currentIndex].artist}",
          style: const TextStyle(color: Colors.grey, fontSize: 14),
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
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.black),
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

  Widget stopButton() {
    return ElevatedButton(
      onPressed: () {
        log('Stop button pressed');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertConfirmDialog(context);
          },
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 255, 0, 0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cancel,
            color: Colors.black,
            size: 50.0,
          ),
          SizedBox(width: 8),
          Text(
            'หยุด',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  AlertDialog alertConfirmDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmation'),
      content: const Text('Are you sure you want to stop?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            log('Cancel button pressed');
            _audioPlayer.stop();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Confirm'),
          onPressed: () {
            log('Confirm button pressed');
            _audioPlayer.stop();
            Get.to(() => AfterExercisePage(widget.pid, widget.wpid));
          },
        ),
      ],
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
