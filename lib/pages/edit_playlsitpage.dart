import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:frontend_fitfit_app/model/request/playlist_put_req.dart';
import 'package:frontend_fitfit_app/model/response/playlsit_music_get_res.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditPlaylistPage extends StatefulWidget {
  int pid = 0;
  EditPlaylistPage(this.pid, {super.key});

  @override
  State<EditPlaylistPage> createState() => _EditPlaylistPageState();
}

class _EditPlaylistPageState extends State<EditPlaylistPage> {
  var imgPick = "";
  final namePlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late PlaylistService playlsitService;
  late PlaylsitMusicGetResponse dePlaylist;
  late var loadData;
  @override
  void initState() {
    super.initState();
    playlsitService = context.read<AppData>().playlistService;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    dePlaylist = await playlsitService.getPlaylistMusicByPid(widget.pid);
  }

  @override
  Widget build(BuildContext context) {
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
                return const Center(child: CircularProgressIndicator());
              }
              return uiEditPlaylist(dePlaylist);
            }));
  }

  Widget uiEditPlaylist(PlaylsitMusicGetResponse dePlaylist) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                Text(
                  "โปรดใส่ชื่อรายการเพลงของคุณ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextFormField(
                controller: namePlController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    log('no');
                    return 'กรุณากรอกชื่อรายการเพลงของคุณ';
                  }

                  if (value.length > 50) {
                    return 'กรุณากรอกชื่อรายการเพลงของคุณที่มีความยาวไม่เกิน 50 ตัวอักษร';
                  }

                  return null;
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: dePlaylist.playlistName,
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Image(
                      image: AssetImage("assets/images/playlist.png")),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 50),
              child: (imgPick != "") ? playlistImg() : noImg(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: edit,
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(300, 50)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFF8721D)),
                      // textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18, color: Colors.white)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      'บันทึกรายการเพลง',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // Get.to(() => const LoginPage());
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(300, 50)),
                      side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      )),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      'บันทึกและเริ่มออกกำลังกาย',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void edit() async {
    if (_formKey.currentState?.validate() ?? true) {
      if (imgPick == "") {
        PlaylsitPutRequest editPl = PlaylsitPutRequest(
            playlistName: namePlController.text == ""
                ? dePlaylist.playlistName
                : namePlController.text,
            imagePlaylist: dePlaylist.imagePlaylist);
        try {
          int res = await playlsitService.editPlaylist(editPl,widget.pid);
          if (res > 0) {
            log('แก้ไขเพลย์ลิสต์สำเร็จ');
          
    
          } else {
            log('แก้ไขเพลย์ลิสต์ไม่สำเร็จ');
          }
        } catch (e) {
          log(e.toString());
        }
      } else {
        PlaylsitPutRequest editPl = PlaylsitPutRequest(
            playlistName: namePlController.text == ""
                ? dePlaylist.playlistName
                : namePlController.text,
            imagePlaylist: imgPick);
        try {
          int res = await playlsitService.editPlaylist(editPl,dePlaylist.pid );
          if (res > 0 ) {
            log('แก้ไขเพลย์ลิสต์สำเร็จ');
          } else {
            log('แก้ไขเพลย์ลิสต์ไม่สำเร็จ');
          }
        } catch (e) {
          log(e.toString());
        }
      }
    }
  }

  Widget noImg() {
    return Stack(
      children: [
        Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
              // border: Border.all(width: 3, color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  image: NetworkImage(dePlaylist.imagePlaylist))),
        ),
        Positioned(
            bottom: 80, // Adjust this value to move the button up/down
            right: 130,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 4, color: Colors.white),
                  color: const Color(0xFFF8721D)),
              child: IconButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                onPressed: () {
                  pickImage();
                },
                icon: const Icon(Icons.add),
              ),
            ))
      ],
    );
  }

  Widget playlistImg() {
    return Stack(
      children: [
        Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
              // border: Border.all(width: 3, color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(imgPick))),
        ),
        Positioned(
            bottom: 80, // Adjust this value to move the button up/down
            right: 130,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 4, color: Colors.white),
                  color: const Color(0xFFF8721D)),
              child: IconButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                onPressed: () {
                  pickImage();
                },
                icon: const Icon(Icons.edit),
              ),
            ))
      ],
    );
  }

  File? _image;
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('uploadsImg/${image.name}');
        UploadTask uploadTask = ref.putFile(_image!);
        await uploadTask.whenComplete(() async {
          String downloadURL = await ref.getDownloadURL();
          log('File uploaded at $downloadURL');
          setState(() {
            imgPick = downloadURL;
          });
        });
      } catch (e) {
        log(e.toString());
      }

      // var result = await Dio()
      //     .post('http://202.28.34.197:8888/cdn/fileupload', data: formData);
      // if (result.statusCode == 201) {
      //   log(result.data['fileUrl']);
      //   setState(() {
      //     imgPick = result.data['fileUrl'];
      //   });
      // }
    }
  }
}
