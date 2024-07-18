import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/service/model/response/social_all_post_res.dart';
import 'package:frontend_fitfit_app/service/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/pages/playlsitMusic/playlsit_music_page.dart';
import 'package:frontend_fitfit_app/pages/user/editprofile.dart';
import 'package:frontend_fitfit_app/service/api/post.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late UserLoginPostResponse user;
  List<SocialAllPostResonse> postAll = [];
  // List<List<WorkoutProfileMusicTypeGetResponse>> profileInfos = [];
  // ignore: prefer_typing_uninitialized_variables
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
      postAll = await postService.getPostByUid(user.uid!);
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
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app_rounded,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {},
              ),
            ]),
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
              return RefreshIndicator(
                  color:
                      const Color(0xFFF8721D), // เปลี่ยนสีของ RefreshIndicator
                  onRefresh: () async {
                    setState(() {
                      loadData = loadDataAsync();
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              NetworkImage('${user.imageProfile}')),
                      const SizedBox(height: 10),
                      Text(
                        '${user.name}',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            Get.to(() => const EditProfilePage());
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(100, 50)),
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                              color: Color.fromARGB(255, 75, 75, 75),
                              width: 2.0,
                            )),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: const Text('แก้ไขโปรไฟล์',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 255, 255, 255)))),
                      const SizedBox(
                        height: 20,
                      ),
                      postAll.isNotEmpty
                          ? postMe(MediaQuery.of(context).size.height,
                              MediaQuery.of(context).size.width)
                          : Expanded(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: Text(
                                    'ยังไม่มีเพลย์ลิสต์เพลงของคุณที่แชร์',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ));
            }));
  }

  Widget postMe(height, width) {
    return Expanded(
      child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'เพลย์ลิสต์เพลงของคุณที่แชร์',
                  style: TextStyle(
                      color: Color(0xFFF8721D),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const Divider(
                  thickness: 2.5,
                ),
                listPost(),
              ],
            ),
          )),
    );
  }

  Widget listPost() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: postAll.isEmpty ? 0 : postAll.length,
        itemBuilder: (context, index) => post(postAll[index]),
      ),
    );
  }

  Widget post(SocialAllPostResonse postMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Container(
        width: 350,
        decoration: ShapeDecoration(
          color: const Color(0x66CCCCCC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: descriptionPost(postMe),
          ),
        ),
      ),
    );
  }

  List<Widget> descriptionPost(SocialAllPostResonse postMe) {
    return [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: NetworkImage(user.imageProfile.toString()),
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
                            user.name.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            calDateTime(postMe.pDatetime.toString()),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        try {
                          // ignore: use_build_context_synchronously
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title:
                                        const Text("ต้องการลบโพสต์หรือไม่!"),
                                    titleTextStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20),
                                    actionsOverflowButtonSpacing: 20,
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<
                                                      Color>(
                                                  const Color(0xFFF8721D)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "ยกเลิก",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          log(postMe.postid.toString());
                                          int res = await postService
                                              .deletePost(postMe.postid);
                                          log(res.toString());
                                          if (res > 0) {
                                            Get.back();
                                            setState(() {
                                              loadData = loadDataAsync();
                                            });
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<
                                                      Color>(
                                                  const Color(0xFFF8721D)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "ยืนยัน",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                    content: const Text("กรุณายืนยันการลบ"),
                                  ));
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            despost(postMe),
            const SizedBox(
              height: 10,
            ),
            playlistPost(postMe),
          ];
  }

  Widget playlistPost(SocialAllPostResonse postMe) {
    return InkWell(
       onTap: () {
            Get.to(() => MusicPlaylistPage(postMe.pid));
      },
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
                                NetworkImage(postMe.playlist.imagePlaylist),
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
                              postMe.playlistName,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              // overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "playlist by ${user.name}",
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
    );
  }

  Container  despost(SocialAllPostResonse postMe) {
    return Container(
            width: 300,
            padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: ShapeDecoration(
              color: const Color(0x66CCCCCC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              postMe.description,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          );
  }

  String calDateTime(String dt) {
    String res = '';

    // Split ส่วนของวันที่และเวลา
    List<String> parts = dt.split('.');

    // สร้าง DateTime โดยแยกส่วนวันที่และเวลาออกจากกัน
    DateTime postTime =
        DateTime.parse(parts[0].trim()); // แปลงเฉพาะส่วนวันที่และเวลา

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
