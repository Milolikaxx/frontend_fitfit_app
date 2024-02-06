import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/welcome.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
          elevation: 0,
          backgroundColor: const Color(0xFFF8721D),
          leading: const CircleAvatar(
            backgroundImage: NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/2171/2171947.png',
            ),
          ),
          title: const Text("Test Test"),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.exit_to_app_rounded,
                color: Color.fromARGB(255, 255, 255, 255)
              ),
              onPressed: () {
                
              },
            ),
          ],
        )
        );
  }

  //ปุ่ม Sign Out การออกจากระบบ
  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          child: const Text("Log Out"),
          onPressed: () async {
            await GoogleSignIn().disconnect();
            log("Sign Out Success!!");
            Get.to(() => const WelcomePage());
          },
        ),
      ),
    );
  }
}
