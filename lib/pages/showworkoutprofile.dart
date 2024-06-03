import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:provider/provider.dart';

class ShowWorkoutProfilePage extends StatefulWidget {
  int idx = 0;
  ShowWorkoutProfilePage(this.idx, {super.key});

  @override
  State<ShowWorkoutProfilePage> createState() => _ShowWorkoutProfilePageState();
}

enum Menu { preview, share, remove, edit }

class _ShowWorkoutProfilePageState extends State<ShowWorkoutProfilePage> {
  // GoogleSignInAccount? user;
  late WorkoutProfileGetResponse profile ;
  late var loadData;
  late WorkoutProfileService wpService;
  @override
  void initState() {
    super.initState();
    wpService = context.read<AppData>().workoutProfile;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    profile = await wpService.getProfileByWpid(widget.idx);
    // log(profile..toString());

    // setState(() {
    //   trip = tripGetResponseFromJson(value.body);
    // });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }

              return Column(
                children: [
                  cardDetailsWp(profile),
                  playlist(height, width)
                ],
              );
            }));
  }

  Widget cardDetailsWp(WorkoutProfileGetResponse profile) {
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
    // Color cardColor = Colors.w
    return Center(
      child: Container(
        width: 350,
        padding: const EdgeInsets.only(top: 5),
        decoration: ShapeDecoration(
          // color: const Color(0x66CCCCCC),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const Text(
              'ข้อมูลโปรไฟล์ออกกำลังกาย',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.clock,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(
                  width: 9,
                ),
                Text(
                  "${profile.duration} นาที ",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.personRunning,
                  color: Colors.black,
                  size: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    profile.exerciseType,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.chartColumn,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  profile.levelExercise > 0
                      ? 'Lv.${profile.levelExercise} $levelDescription'
                      : '',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.music,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                getTextMusicName(profile.workoutMusictype)
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget getTextMusicName(List<WorkoutMusictype> musicTypes) {
    return Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: musicTypes
            .asMap()
            .map((index, musicType) {
              String text = musicType.musicType.name;
              if (index != musicTypes.length - 1) {
                text;
              }
              return MapEntry(
                index,
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              );
            })
            .values
            .toList());
  }

  Widget playlist(height, width) {
    return Expanded(
      child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'เพลย์ลิสต์เพลงของฉัน',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  playlistAll(),
                  playlistAll(),
                  playlistAll(),
                  playlistAll(),
                  playlistAll(),
                  playlistAll(),
                  playlistAll(),
                  playlistAll(),
                ],
              ),
            ),
          )),
    );
  }

  Widget playlistAll() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        width: 350,
        decoration: const BoxDecoration(
          color: Color(0xff2E2F33),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://i.pinimg.com/736x/55/36/4d/55364dbe7efe7052c33df1e3a7a9614f.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("playlist name",
                      style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          overflow: TextOverflow.clip)),
                  PopupMenuButton<Menu>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onSelected: (Menu item) {},
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<Menu>>[
                      const PopupMenuItem<Menu>(
                        value: Menu.preview,
                        child: ListTile(
                          leading: Icon(Icons.visibility_outlined),
                          title: Text('ดูเพลงในเพลย์ลิสต์'),
                        ),
                      ),
                      const PopupMenuItem<Menu>(
                        value: Menu.share,
                        child: ListTile(
                          leading: Icon(Icons.share_outlined),
                          title: Text('แชร์'),
                        ),
                      ),

                      // const PopupMenuDivider(),
                      const PopupMenuItem<Menu>(
                        value: Menu.remove,
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('ลบ'),
                        ),
                      ),
                      const PopupMenuItem<Menu>(
                        value: Menu.edit,
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('แก้ไข'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
