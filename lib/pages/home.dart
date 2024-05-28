import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfileMusicType_get_res.dart';
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
  List<List<WorkoutProfileMusicTypeGetResponse>> profileInfos = [];
  late UserLoginPostResponse user;
  late var loadData;
  late WorkoutProfileService wpService;
  String lvText = "";
  List<String> musicType = [];
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
    profiles = await wpService.getWorkoutProfile(user.uid!);
    for (var profile in profiles) {
      var profileInfo = await wpService.getListWorkoutProfile(profile.wpid);
      profileInfos.add(profileInfo);
      log(profileInfo.length.toString());
      // for (var profile in profiles) {
      //   log(profile.workoutMusictype.musicType.name);
      // }
    }

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
                return const CircularProgressIndicator();
              }
              return profiles.isNotEmpty
                  ? ListView.builder(
                      itemCount: profiles.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: workoutProfileCard(profiles[index], profileInfos[index]),
                      ),
                    )
                  : const Center(
                      child: Text(
                        'ยังไม่มีโปรโฟล์ออกกำลังกาย',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    );
            }));
  }

  Widget getTextName(List<WorkoutProfileMusicTypeGetResponse> profileInfos) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: profileInfos
            .map((p) => Text(
                  p.workoutMusictype.musicType.name,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ))
            .toList());
  }

  workoutProfileCard(WorkoutProfileGetResponse data,List<WorkoutProfileMusicTypeGetResponse> profileInfo) {
    return Container(
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
        children: [
          (data.levelExercise == 5)
              ? Text(
                  '${data.exerciseType} : ${data.duration}นาที : Lv.${data.levelExercise} หนักมาก',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                )
              : (data.levelExercise == 4)
                  ? Text(
                      '${data.exerciseType} : ${data.duration} นาที : Lv.${data.levelExercise} หนัก',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    )
                  : (data.levelExercise == 3)
                      ? Text(
                          '${data.exerciseType} : ${data.duration}นาที : Lv.${data.levelExercise} ปานกลาง ',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        )
                      : (data.levelExercise == 2)
                          ? Text(
                              '${data.exerciseType} : ${data.duration}นาที : Lv.${data.levelExercise} เบา ',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            )
                          : (data.levelExercise == 1)
                              ? Text(
                                  '${data.exerciseType} : ${data.duration}นาที : Lv.${data.levelExercise} เบามาก',
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                )
                              : const Text(""),
          getTextName(profileInfo)
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
