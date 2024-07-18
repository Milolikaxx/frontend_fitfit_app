import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/service/model/response/playlsit_with_wp_workoutprofile_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/social_all_post_res.dart';
import 'package:frontend_fitfit_app/service/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/pages/playlsitMusic/playlist_other_page.dart';
import 'package:frontend_fitfit_app/pages/playlsitMusic/playlsit_music_page.dart';
import 'package:frontend_fitfit_app/pages/preExercise/showworkoutprofile.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/post.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class SocailPage extends StatefulWidget {
  const SocailPage({super.key});

  @override
  State<SocailPage> createState() => _SocailPageState();
}

class _SocailPageState extends State<SocailPage> {
  List<SocialAllPostResonse> postAll = [];
   late UserLoginPostResponse user;
  // List<List<WorkoutProfileMusicTypeGetResponse>> profileInfos = [];
  late var loadData;
  late PostService postService;
  @override
  void initState() {
    super.initState();
    postService = context.read<AppData>().postService;
    user = context.read<AppData>().user;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      postAll = await postService.getPostAll();
      log(postAll.length.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          title: const Text(
            "Feeds",
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: false,
        ),
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
              return Column(children: [listPost()]);
            }));
  }

  Widget listPost() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: postAll.isEmpty ? 0 : postAll.length,
        itemBuilder: (context, index) => post(postAll[index]),
      ),
    );
  }

  Widget post(SocialAllPostResonse post) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          width: 350,
          padding: const EdgeInsets.only(top: 5),
          decoration: ShapeDecoration(
            color: const Color(0x66CCCCCC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                userDetail(post),
                const SizedBox(
                  height: 10,
                ),
                descriptionPost(post),
                const SizedBox(
                  height: 10,
                ),
                playlist(post),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userDetail(SocialAllPostResonse post) {
    return Row(
                children: [
                  Container(
                    width: 47,
                    height: 47,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(post.user.imageProfile),
                        fit: BoxFit.cover,
                      ),
                      shape: const OvalBorder(),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        calDateTime(post.pDatetime.toString()),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              );
  }

  Widget descriptionPost(SocialAllPostResonse post) {
    return Container(
                width: 300,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF8721D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  post.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              );
  }

  Widget playlist(SocialAllPostResonse post) {
    return InkWell(
       onTap: () {
        if (user.uid == post.uid) {
            Get.to(() => MusicPlaylistPage(post.pid));
        }else {
           Get.to(() => PlaylistUserOtherPage(post.pid,post.user.name,post.playlistName,post.user.imageProfile));
        }
     
        // setState(() {
        //    cardColor = Colors.orange;
        // });
      },
      child: Card(
        child: Container(
                    width: 300,
                    decoration: ShapeDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      NetworkImage(post.playlist.imagePlaylist),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: constraints.maxWidth -
                                  130, // 120 (image width) + 10 (SizedBox width)
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.playlistName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "playlist by ${post.user.name}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
      ),
    );
  }

  String calDateTime(String dt) {
    String res = '';
    List<String> parts = dt.split('.');
    // สร้าง DateTime โดยแยกส่วนวันที่และเวลาออกจากกัน
    DateTime postTime =
        DateTime.parse(parts[0].trim()); 

    log("เวลาของ post: $postTime");
    DateTime now = DateTime.now();
    log("เวลาปัจจุบัน: $now");

    Duration difference = now.difference(postTime);

    if (difference.inSeconds.abs() < 60) {
      res = '${difference.inSeconds.abs()} วินาที';
    } else if (difference.inMinutes.abs() < 60) {
      res = '${difference.inMinutes.abs()} นาที';
    } else if (difference.inHours.abs() < 24) {
      res = '${difference.inHours.abs()} ชม.';
    } else {
      res = '${difference.inDays.abs()} วัน';
    }

    log(res);
    return res;
  }
}
