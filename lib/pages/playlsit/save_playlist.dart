import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:frontend_fitfit_app/service/model/request/playlsit_detail_post_req.dart';
import 'package:frontend_fitfit_app/service/model/request/playlsit_post_req.dart';
import 'package:frontend_fitfit_app/service/model/response/muisc_get_res.dart';
import 'package:frontend_fitfit_app/pages/barbottom.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/playlist_detail.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

// ignore: must_be_immutable
class SavePlaylistPage extends StatefulWidget {
  List<MusicGetResponse> music = [];
  int idx = 0;
  int time = 0;
  SavePlaylistPage(this.music, this.idx, this.time, {super.key});

  @override
  State<SavePlaylistPage> createState() => _SavePlaylistPageState();
}

class _SavePlaylistPageState extends State<SavePlaylistPage> {
  var imgPick = "";
  final namePlController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late PlaylistService playlsitService;
  late PlaylistDetailService playlsitDeService;
  File? imageFile;
  @override
  void initState() {
    super.initState();
    playlsitDeService = context.read<AppData>().playlistDetailService;
    playlsitService = context.read<AppData>().playlistService;
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
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment:CrossAxisAlignment.center,
                  children: [
                    Text(
                      "โปรดใส่ชื่อเพลย์ลิสต์ของคุณ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: namePlController,
                    style: const TextStyle(color: Colors.white),
                    maxLength: 50,
                    validator: (value) {
                      // add email validation
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกชื่อเพลย์ลิสต์';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'ชื่อรายการเพลง',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Image(
                            image: AssetImage("assets/images/playlist.png")),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        counterStyle:
                            TextStyle(color: Colors.white, height: 1)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 50),
                  child: (imageFile != null) ? playlistImg() : noImg(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: save,
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(300, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFF8721D)),
                          // textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18, color: Colors.white)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(300, 50)),
                          side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          )),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
        ),
      ),
    );
  }

  void _showLoading() {
    SmartDialog.showLoading(msg: "กำลังประมวลผล...");
  }

  void _hideLoading() {
    SmartDialog.dismiss();
  }

  Future<void> save() async {
    await uploadImg();
    if (_formKey.currentState?.validate() ?? true) {
      if (imgPick == "") {
        PlaylsitPostRequest plObj = PlaylsitPostRequest(
            wpid: widget.idx,
            playlistName: namePlController.text,
            durationPlaylist: widget.time,
            imagePlaylist:
                "http://202.28.34.197:8888/contents/fc032ca0-1f03-4b21-baf3-b97bd04e88b7.jpg");
        _showLoading();
        try {
          int res = await playlsitService.addPlaylsit(plObj);
          if (res > 0) {
            log('เพิ่มเพลย์ลิสต์สำเร็จ');
            for (var m in widget.music) {
              log(m.name);
              log(m.mid.toString());
              PlaylsitDetailPostRequest addMusicToPL =
                  PlaylsitDetailPostRequest(pid: res, mid: m.mid);
              try {
                int resAddmusic =
                    await playlsitDeService.addMusicToPlaylist(addMusicToPL);
                if (resAddmusic != 0) {
                  log('เพิ่มเพลงในเพลย์ลิสต์สำเร็จ');
                } else {
                  log('เพิ่มเพลงในเพลย์ลิสต์ไม่สำเร็จ');
                }
              } catch (e) {
                log(e.toString());
              }
            }
          } else {
            log('เพิ่มเพลย์ลิสต์ไม่สำเร็จ');
          }
        } catch (e) {
          log(e.toString());
        } finally {
          _hideLoading();
          // ignore: use_build_context_synchronously
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text("สำเร็จ!"),
                    titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                    actionsOverflowButtonSpacing: 20,
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => const Barbottom());
                        },
                        style: ButtonStyle(
                          // minimumSize: MaterialStateProperty.all<Size>(
                          //     const Size(330, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFF8721D)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        child: const Text(
                          "ตกลง",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                    content: const Text("เพิ่มเพลย์ลิสต์สำเร็จ"),
                  ));
        }
      } else {
        PlaylsitPostRequest plObj = PlaylsitPostRequest(
            wpid: widget.idx,
            playlistName: namePlController.text,
            durationPlaylist: widget.time,
            imagePlaylist: imgPick);
        _showLoading();
        try {
          int res = await playlsitService.addPlaylsit(plObj);
          if (res > 0) {
            log('เพิ่มเพลย์ลิสต์สำเร็จ');
            for (var m in widget.music) {
              log(m.name);
              log(m.mid.toString());
              PlaylsitDetailPostRequest addMusicToPL =
                  PlaylsitDetailPostRequest(pid: res, mid: m.mid);
              try {
                int resAddmusic =
                    await playlsitDeService.addMusicToPlaylist(addMusicToPL);
                if (resAddmusic != 0) {
                  log('เพิ่มเพลงในเพลย์ลิสต์สำเร็จ');
                } else {
                  log('เพิ่มเพลงในเพลย์ลิสต์ไม่สำเร็จ');
                }
              } catch (e) {
                log(e.toString());
              }
            }
          } else {
            log('เพิ่มเพลย์ลิสต์ไม่สำเร็จ');
          }
        } catch (e) {
          log(e.toString());
        } finally {
          _hideLoading();
          // ignore: use_build_context_synchronously
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text("สำเร็จ!"),
                    titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                    actionsOverflowButtonSpacing: 20,
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => const Barbottom());
                        },
                        style: ButtonStyle(
                          // minimumSize: MaterialStateProperty.all<Size>(
                          //     const Size(330, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFF8721D)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        child: const Text(
                          "ตกลง",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                    content: const Text("เพิ่มเพลย์ลิสต์สำเร็จ"),
                  ));
        }
      }
    }
  }

  Widget noImg() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: const BoxDecoration(
              // border: Border.all(width: 3, color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/images/1.jpg'))),
        ),
        Positioned(
      
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
      alignment: Alignment.center,
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
              // border: Border.all(width: 3, color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.cover, image: FileImage(imageFile!))),
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

  // firebase
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

//upload
  Future<void> uploadImg() async {
    if (imageFile != null) {
      // Read the file as bytes
      Uint8List imageBytes = await imageFile!.readAsBytes();

      // Decode
      img.Image? decodedImage = img.decodeImage(imageBytes);

      if (decodedImage != null) {
        // Encode
        Uint8List base64ImgDecode =
            Uint8List.fromList(img.encodeJpg(decodedImage));
        // String base64Image = base64Encode(base64ImgDecode);
        // log("$base64Image base64");

        try {
          FirebaseStorage storage = FirebaseStorage.instance;

          String fileName = path.basename(imageFile!.path);
          Reference ref = storage.ref().child('uploadsImg/$fileName');

          // Upload the image bytes to Firebase
          UploadTask uploadTask = ref.putData(base64ImgDecode);
          await uploadTask.whenComplete(() async {
            String downloadURL = await ref.getDownloadURL();
            log('File uploaded at $downloadURL');
            if (mounted) {
              setState(() {
                imgPick = downloadURL;
              });
              log("url $imgPick");
            }
          });
        } catch (e) {
          log(e.toString());
        }
      } else {
        log('Failed to decode image');
      }
    } else {
      log('No image selected');
    }
  }
}
