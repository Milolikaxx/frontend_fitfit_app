import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/welcome.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomePage extends StatefulWidget {
  final GoogleSignInAccount? user;
  const HomePage({super.key,required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // GoogleSignInAccount? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //การเรียกใช้ข้อมูลผู้ใช้จาก Google Firebase
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user!.photoUrl.toString()),
              radius: 50,
            ),
            const Padding(padding: EdgeInsets.all(20.0)),
            Text(widget.user!.email),
            Text(widget.user!.displayName.toString()),
            const Padding(padding: EdgeInsets.all(100.0)),
            _googleSignInButton(),
          ],
        ),
      )
    );
  }

  //ปุ่ม Sign Out การออกจากระบบ
  Widget _googleSignInButton() {
    return Center(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          child: const Text( "Log Out"),
          onPressed: () async{
           await GoogleSignIn().disconnect();
           log("Sign Out Success!!");
           Get.to(() => const WelcomePage());
          } ,
        ),
      ),
    );
  }
}