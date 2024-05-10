import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/service/api/user.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // GoogleSignInAccount? user;
  late UserLoginPostResponse user;
  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        
        backgroundColor: const Color(0xFFF8721D),
        automaticallyImplyLeading: false,
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(
            'https://cdn-icons-png.flaticon.com/512/2171/2171947.png',
          ),
        ),
        title:  Text(
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
      body: const Center(
        child: Text(
          'ยังไม่มีโปรโฟล์ออกกำลังกาย',
          style: TextStyle(fontSize: 20, color: Colors.white),
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
