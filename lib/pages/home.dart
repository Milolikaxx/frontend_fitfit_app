import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart';
import 'package:frontend_fitfit_app/service/api/user.dart';
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
  List<WorkoutProfileGetResponse> liseWorkoutPdrofile = [];
  late UserLoginPostResponse user;
  late var loadData;
  late WorkoutProfileService wpService;
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
    liseWorkoutPdrofile = await wpService.getMorkoutProfile(user.uid!);
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
          leading:  CircleAvatar(
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
              return liseWorkoutPdrofile.isNotEmpty
                  ? ListView.builder(
                      itemCount: liseWorkoutPdrofile.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        child: workoutProfileCard(liseWorkoutPdrofile[index]),
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

  workoutProfileCard(WorkoutProfileGetResponse liseWorkoutPdrofile) {
    return Container(
        width: 350,
        height: 250,
        decoration: ShapeDecoration(
          color: const Color(0x66CCCCCC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          image: const DecorationImage(image: AssetImage('assets/images/preImgPlaylist.png'),
          fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Text(liseWorkoutPdrofile.exerciseType,style: const TextStyle(fontSize: 20, color: Colors.white),)
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
