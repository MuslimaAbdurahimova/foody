import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_controller.dart';
import '../home/home_page.dart';

class SetAvatar extends StatefulWidget {
  const SetAvatar({Key? key}) : super(key: key);

  @override
  State<SetAvatar> createState() => _SetAvatarState();
}

class _SetAvatarState extends State<SetAvatar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            context.watch<AuthController>().imagePath.isEmpty
                ? Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            context.read<AuthController>().getImageCamera();
                          },
                          child: Text("Take phote")),
                      ElevatedButton(
                          onPressed: () {
                            context.read<AuthController>().getImageGallery();
                          },
                          child: Text("Take file")),
                    ],
                  )
                : const SizedBox.shrink(),

            context.watch<AuthController>().imagePath.isEmpty
                ? const SizedBox.shrink()
                : Stack(
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(
                                File(context.watch<AuthController>().imagePath),
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                      // Positioned(
                      //   bottom: 0,
                      //   right: 0,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       showDialog(
                      //           context: context,
                      //           builder: (context) {
                      //             return AlertDialog(
                      //               title: Text("Tanlang"),
                      //               actions: [
                      //                 ElevatedButton(
                      //                     onPressed: () async {
                      //                       _image
                      //                           .pickImage(
                      //                               source: ImageSource.camera)
                      //                           .then((value) async {
                      //                         if (value != null) {
                      //                           CroppedFile? _cropperImage =
                      //                               await ImageCropper()
                      //                                   .cropImage(
                      //                                       sourcePath:
                      //                                           value.path);
                      //                           if (_cropperImage != null) {
                      //                             imagePath =
                      //                                 _cropperImage.path;
                      //                             setState(() {});
                      //                             Navigator.pop(context);
                      //                           }
                      //                         }
                      //                       });
                      //                     },
                      //                     child: Text("Take phote")),
                      //                 ElevatedButton(
                      //                     onPressed: () async {
                      //                       _image
                      //                           .pickImage(
                      //                               source: ImageSource.gallery)
                      //                           .then((value) async {
                      //                         if (value != null) {
                      //                           CroppedFile? _cropperImage =
                      //                               await ImageCropper()
                      //                                   .cropImage(
                      //                                       sourcePath:
                      //                                           value.path);
                      //                           if (_cropperImage != null) {
                      //                             imagePath =
                      //                                 _cropperImage.path;
                      //                             setState(() {});
                      //                             Navigator.pop(context);
                      //                           }
                      //                         }
                      //                       });
                      //                     },
                      //                     child: Text("Take file")),
                      //                 ElevatedButton(
                      //                     onPressed: () async {
                      //                       imagePath = "";
                      //                       Navigator.pop(context);
                      //                       setState(() {});
                      //                     },
                      //                     child: Text("Delete")),
                      //                 ElevatedButton(
                      //                     onPressed: () async {
                      //                       Navigator.pop(context);
                      //                     },
                      //                     child: Text("Cancel")),
                      //               ],
                      //             );
                      //           });
                      //     },
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         color: Colors.pink,
                      //         shape: BoxShape.circle,
                      //       ),
                      //       padding: EdgeInsets.all(8.r),
                      //       child: Icon(
                      //         Icons.edit,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
            // 24.verticalSpace,
            // ElevatedButton(
            //     onPressed: () async {
            //       final CroppedFile? _croppedFile = await ImageCropper().cropImage(
            //           sourcePath: imagePath,
            //         uiSettings: [
            //           AndroidUiSettings(
            //             toolbarTitle: 'Image Cropper',
            //             toolbarColor: Colors.white,
            //             toolbarWidgetColor: Colors.black,
            //             initAspectRatio: CropAspectRatioPreset.original,
            //           ),
            //           IOSUiSettings(title: 'Image Cropper', minimumAspectRatio: 1),
            //         ]
            //       );
            //       imagePath = _croppedFile?.path ?? "";
            //       setState(() {});
            //     },
            //     child: Text("Take Cropper image")),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                context.read<AuthController>().createUser(() {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false);
                });
              },
              child: Text("Next"),
            ),
          ],
        ),
      ),
    ));
  }
}
