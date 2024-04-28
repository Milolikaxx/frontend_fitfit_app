import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // GoogleSignInAccount? user;
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
        title: const Text(
          "Test Test",
          style: TextStyle(color: Colors.white),
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
