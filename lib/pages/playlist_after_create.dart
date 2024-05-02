import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/save_playlist.dart';
import 'package:get/get.dart';

class PlaylistAfterCreatePage extends StatefulWidget {
  const PlaylistAfterCreatePage({super.key});

  @override
  State<PlaylistAfterCreatePage> createState() =>
      _PlaylistAfterCreatePageState();
}

class _PlaylistAfterCreatePageState extends State<PlaylistAfterCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(
          child: Text(
            "เวลา 40 นาที",
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded, color: Colors.black),
            onPressed: savePlaylist,
          ),
        ],
      ),
      body: const Column(
        children: [
          
        ],
      ),
    );
  }

  void savePlaylist() {
     Get.to(() => const SavePlaylistPage());
  }
}
