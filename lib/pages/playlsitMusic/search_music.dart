import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/service/api/music.dart';
import 'package:frontend_fitfit_app/service/model/request/search_music_get_req.dart';
import 'package:frontend_fitfit_app/service/model/response/muisc_get_res.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SearchMusicPage extends StatefulWidget {
  int wpid = 0;
  SearchMusicPage(this.wpid, {super.key});

  @override
  State<SearchMusicPage> createState() => _SearchMusicPageState();
}

class _SearchMusicPageState extends State<SearchMusicPage> {
  late Future<void> loadData;
  List<MusicGetResponse> music = [];
  List<MusicGetResponse> musicList = [];
  late MusicService musicService;
  // double totalDuration = 0;
  String textCheck = "";

  @override
  void initState() {
    super.initState();
    musicService = context.read<AppData>().musicService;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      music = await musicService.getMusicByWorkoutProfile(widget.wpid);
      log(music.length.toString());
      musicList = music;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<MusicSearchProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Music Search'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
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
              return RefreshIndicator(
                  color: const Color(0xFFF8721D),
                  onRefresh: () async {
                    setState(() {
                      loadData = loadDataAsync();
                    });
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            searchMusic(value);
                          },
                          style: const TextStyle(
                            color: Colors.black,
                          ), // Text color
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            labelText: 'ค้นหา',
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 16),
                            hintText: 'ค้นหา',
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      music.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: music.length,
                                itemBuilder: (context, index) =>
                                    musicInfo(music[index]),
                              ),
                            )
                          : Text(textCheck)
                    ],
                  ));
            }));
  }

  Widget musicInfo(MusicGetResponse musicInfo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: NetworkImage(musicInfo.musicImage),
                width: 65,
                height: 65,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musicInfo.name.length > 20
                          ? '${musicInfo.name.substring(0, 20)}..'
                          : musicInfo.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      musicInfo.artist,
                      style:
                          const TextStyle(color: Color.fromARGB(161, 0, 0, 0)),
                    ),
                  
                    Text(
                      "${musicInfo.bpm} bpm",
                      style: const TextStyle(
                          color: Color.fromARGB(161, 0, 0, 0), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
  
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${musicInfo.duration} นาที",
                style: const TextStyle(
                    color: Color.fromARGB(161, 0, 0, 0), fontSize: 12),
              ),
              IconButton(
                  onPressed: () {
                    // Get.to(() => PreExercisePage(pl.wpid, pl.pid));
                  },
                  icon: const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.black,
                  )),
            ],
          ),
        ],
      ),
    );
  }

 void searchMusic(String query) async {
    log(query);

    // if (musicList == null || musicService == null) {
    //   log('musicList or musicService is null');
    //   return;
    // }

    try {
      SearchMusicGetRequest key = SearchMusicGetRequest(
          music: musicList,
          key:
              query); // Assuming musicList can be null, use null-aware operator
      List<MusicGetResponse> results = await musicService.getSearchMusic(key);

      log(results.length.toString());
      log(query);

      setState(() {
        if (results.isNotEmpty) {
          music = results;
        } else {
          music = [];
          textCheck = "ไม่พบเพลง";
        }
      });
    } catch (error) {
      log(error.toString());
    }
  }
}
