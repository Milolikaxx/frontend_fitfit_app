import 'package:flutter/material.dart';

class SocailPage extends StatefulWidget {
  const SocailPage({super.key});

  @override
  State<SocailPage> createState() => _SocailPageState();
}

class _SocailPageState extends State<SocailPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
           backgroundColor: const Color(0xFFF8721D),
          title: const Text("Feeds"),
          
        ));
  }
}