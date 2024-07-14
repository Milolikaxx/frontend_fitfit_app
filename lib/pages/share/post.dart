import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/request/share_playlsit_post_req.dart';
import 'package:frontend_fitfit_app/model/response/playlsit_with_wp_workoutprofile_get_res.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/pages/barbottom.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/post.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PostPage extends StatefulWidget {
  int idx = 0;
  PostPage(this.idx, {super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late UserLoginPostResponse user;
  var nameController = TextEditingController();
  var desController = TextEditingController();
  late var loadData;
  late PlaylistService playlsitService;
  late PostService postService;
  late PlaylistWithWorkoutGetResponse dePlaylist;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    playlsitService = context.read<AppData>().playlistService;
    postService = context.read<AppData>().postService;
    user = context.read<AppData>().user;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      dePlaylist =
          await playlsitService.getPlaylistWithOutMusicByPid(widget.idx);
    } catch (e) {
      log(e.toString());
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            ),
            title: const Text(
              "แชร์รายการเพลง",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    post();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFF8721D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  child: const Text(
                    "แชร์",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
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
                color: const Color(0xFFF8721D), // เปลี่ยนสีของ RefreshIndicator
                onRefresh: () async {
                  setState(() {
                    loadData = loadDataAsync();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(
                              '${user.imageProfile}',
                            ),
                          ),
                          title: Text(
                            user.name.toString(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              //desController
                              TextFormField(
                                maxLength: 50,
                                controller: desController,
                                validator: (value) {
                                  // add email validation
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกข้อความ';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  // border: InputBorder.none,
                                  hintText: 'เขียนอะไรสักอย่างสิ',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white), // สีของข้อความ hint
                                  counterStyle: TextStyle(
                                    color: Colors.white, // สีของ maxLength counter
                                  ),
                                ),
                                style: const TextStyle(
                                    color: Colors.white), // สีของข้อความที่พิมพ์
                              ),
                               Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: 400,
                                  height: 250,
                                  decoration: BoxDecoration(
                                      // border: Border.all(width: 3, color: Colors.white),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0)),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          image: NetworkImage(
                                              dePlaylist.imagePlaylist))),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.playlist_play_rounded,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  "เพลย์ลิสต์เพลง",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              //nameController playlsit
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  maxLength: 50,
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: dePlaylist.playlistName,
                                    hintStyle: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white), // สีของข้อความ hint
                                    counterStyle: const TextStyle(
                                      color:
                                          Colors.white, // สีของ maxLength counter
                                    ),
                                  ),
                                  style: const TextStyle(
                                      color:
                                          Colors.white), // สีของข้อความที่พิมพ์
                                ),
                              ),
                            ],
                          ),
                        ),
                       
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

// final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void post() async {
    log("post");
    if (_formKey.currentState?.validate() ?? true) {
      log("post 1");
      SharePlaylsitPostRequest post = SharePlaylsitPostRequest(
          uid: user.uid!,
          pid: dePlaylist.pid,
          playlistName: nameController.text == ""
              ? dePlaylist.playlistName
              : nameController.text,
          description: desController.text);
      try {
        int res = await postService.addPost(post);
        if (res > 0) {
          log("add post");
          // ignore: use_build_context_synchronously
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text("สำเร็จ!"),
                    titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                    actionsOverflowButtonSpacing: 20,
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => const Barbottom(initialIndex: 1,));
                        },
                        style: ButtonStyle(
                          // minimumSize: MaterialStateProperty.all<Size>(
                          //     const Size(330, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFF8721D)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        child: const Text(
                          "ตกลง",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                    content: const Text("แชร์เพลย์ลิสต์สำเร็จ"),
                  ));
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      Get.snackbar(
        'กรุณารายละเอียดแชร์', // Title
        'อย่าลืมกรอกน้า', // Message
        backgroundColor: Colors.white, // Background color
        colorText: Colors
            .black, // Text color to ensure it's visible on white background
      );
    }
  }
}
