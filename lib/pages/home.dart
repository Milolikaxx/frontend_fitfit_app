import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/response/playlsitl_in_workoutprofile_get_res.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart';
import 'package:frontend_fitfit_app/pages/save_playlist.dart';
import 'package:frontend_fitfit_app/pages/showworkoutprofile.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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

  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    wpService = context.read<AppData>().workoutProfileService;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    profiles = await wpService.getListWorkoutProfileByUid(user.uid!);
    log(profiles.length.toString());
 
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
                              horizontal: 20, vertical: 8),
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
                ),
              );
            })
            .values
            .toList());
  }

  workoutProfileCard(WorkoutProfileGetResponse profile) {
    String levelDescription;
    switch (profile.levelExercise) {
      case 5:
        levelDescription = 'หนักมาก';
        break;
      case 4:
        levelDescription = 'หนัก';
        break;
      case 3:
        levelDescription = 'ปานกลาง';
        break;
      case 2:
        levelDescription = 'เบา';
        break;
      case 1:
        levelDescription = 'เบามาก';
        break;
      default:
        levelDescription = '';
    }
    // Color cardColor = Colors.white;
    return InkWell(
      onTap: () {
        Get.to(() => ShowWorkoutProfilePage(profile.wpid));
        // setState(() {
        //    cardColor = Colors.orange;
        // });
      },
      child: Card(
        //  color: cardColor,
        child: Container(
          alignment: Alignment.bottomLeft,
          width: 350,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/bgprofile.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.levelExercise > 0
                    ? '${profile.exerciseType} : ${profile.duration} นาที : Lv.${profile.levelExercise} $levelDescription'
                    : '',
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
              ),
              getTextName(profile.workoutMusictype)
            ],
          ),
        ),
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
