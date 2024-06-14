import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart';
import 'package:frontend_fitfit_app/pages/showworkoutprofile.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Menu { remove }

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

  Widget getTextMusicName(List<WorkoutMusictype> musicTypes) {
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
                  fontSize: 16,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 5.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            );
          })
          .values
          .toList(),
    );
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
          width: 350,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/bgprofile.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: [
            // PopupMenuButton positioned at the top right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<Menu>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Color.fromARGB(255, 255, 255, 255),
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 5.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  onSelected: (Menu item) async {
                    switch (item) {
                      case Menu.remove:
                        try {
                          log(profile.wpid.toString());
                          var responseCode = await wpService
                              .deleteWorkoutProfileByWpid(profile.wpid);
                          log(responseCode.toString());
                          if (responseCode == 1) {
                            log("Profile deleted successfully. Response code: $responseCode");
                            setState(() {
                              loadData = loadDataAsync();
                            });
                          } else {
                            log("Failed to delete profile. Response code: $responseCode");
                          }
                        } catch (e) {
                          log("Error: $e");
                        }
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    const PopupMenuItem<Menu>(
                      value: Menu.remove,
                      child: ListTile(
                        leading: Icon(Icons.delete_outline),
                        title: Text('ลบ'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.personRunning,
                        color: Colors.white,
                        size: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${profile.exerciseType} ${profile.duration} นาที',
                          style: const TextStyle(
                            fontSize: 16,
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
                      ),
                    ],
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.chartColumn,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        profile.levelExercise > 0
                            ? 'Lv.${profile.levelExercise} $levelDescription'
                            : '',
                        style: const TextStyle(
                          fontSize: 16,
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
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.music,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: getTextMusicName(profile.workoutMusictype),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]),
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
