import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // GoogleSignInAccount? user;
  List<WorkoutProfileGetResponse> profiles = [];
  // List<List<WorkoutProfileMusicTypeGetResponse>> profileInfos = [];
  late UserLoginPostResponse user;
  late var loadData;
  late WorkoutProfileService wpService;
  String lvText = "";
  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    wpService = context.read<AppData>().workoutProfile;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    // String url = 'http://202.28.34.197/tripbooking/trip/${widget.idx}';
    // var value = await http.get(Uri.parse(url));
    // trip = tripGetResponseFromJson(value.body);
    // log(value.body);
    profiles = await wpService.getListWorkoutProfileByUid(user.uid!);
    log(profiles.length.toString());

    // setState(() {
    //   trip = tripGetResponseFromJson(value.body);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8721D),
          automaticallyImplyLeading: false,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              '${user.imageProfile}',
            ),
          ),
          title: Text(
            "${user.name}",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app_rounded,
                  color: Color.fromARGB(255, 255, 255, 255)),
              onPressed: () {},
            ),
          ],
        ),
        body: FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    loadData = loadDataAsync();
                  });
                },
                child: profiles.isNotEmpty
                    ? ListView.builder(
                        itemCount: profiles.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: workoutProfileCard(profiles[index]),
                        ),
                      )
                    : const Center(
                        child: Text(
                          'ยังไม่มีโปรโฟล์ออกกำลังกาย',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
              );
            }));
  }

  Widget getTextName(List<WorkoutMusictype> musicTypes) {
    return Row(

        children: musicTypes
            .asMap()
            .map((index, musicType) {
              String text = musicType.musicType.name;
              if (index != musicTypes.length - 1) {
                text += " : ";
              }
              return MapEntry(
                index,
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20, color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 8.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              );
            })
            .values
            .toList()
        );
  }

  workoutProfileCard(WorkoutProfileGetResponse profile) {
    return Container(
      alignment: Alignment.bottomLeft,
      width: 350,
      height: 180,
      decoration: ShapeDecoration(
        color: const Color(0x66CCCCCC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/dream_TradingCard.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (profile.levelExercise == 5)
              ? Text(
                  '${profile.exerciseType} : ${profile.duration}นาที : Lv.${profile.levelExercise} หนักมาก',
                  style: const TextStyle(
                    fontSize: 20, color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 8.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                )
              : (profile.levelExercise == 4)
                  ? Text(
                      '${profile.exerciseType} : ${profile.duration} นาที : Lv.${profile.levelExercise} หนัก',
                      style: const TextStyle(
                    fontSize: 20, color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 8.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                    )
                  : (profile.levelExercise == 3)
                      ? Text(
                          '${profile.exerciseType} : ${profile.duration}นาที : Lv.${profile.levelExercise} ปานกลาง ',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 8.0,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        )
                      : (profile.levelExercise == 2)
                          ? Text(
                              '${profile.exerciseType} : ${profile.duration}นาที : Lv.${profile.levelExercise} เบา ',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 8.0,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            )
                          : (profile.levelExercise == 1)
                              ? Text(
                                  '${profile.exerciseType} : ${profile.duration}นาที : Lv.${profile.levelExercise} เบามาก',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 8.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),                                )
                              : const Text(""),
          getTextName(profile.workoutMusictype)
        ],
      ),
    );
  }

  // //ปุ่ม Sign Out การออกจากระบบ
  // Widget _googleSignInButton() {
  //   return Center(
  //     child: SizedBox(
  //       height: 50,
  //       child: ElevatedButton(
  //         child: const Text("Log Out"),
  //         onPressed: () async {
  //           await GoogleSignIn().disconnect();
  //           log("Sign Out Success!!");
  //           Get.to(() => const WelcomePage());
  //         },
  //       ),
  //     ),
  //   );
  // }
}
