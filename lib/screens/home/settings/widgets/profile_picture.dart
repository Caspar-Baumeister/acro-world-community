// ignore_for_file: avoid_print

import 'dart:io';

import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_storage/firebase_storage.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Stack(children: [
      CircleAvatar(
          radius: 100.0,
          backgroundImage:
              NetworkImage(userProvider.activeUser!.imgUrl ?? MORTY_IMG_URL)),
      Positioned(
        bottom: 10.0,
        right: 10.0,
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.black,
            ),
            onPressed: () => pickFile(userProvider.activeUser!.uid),
          ),
        ),
      )
    ]);
  }

  Future pickFile(String id) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    final String path = result.files.single.path!;

    File file = File(path);

    try {
      // Uploading the selected image with some custom meta data
      TaskSnapshot task = await storage.ref(id).putFile(
          file,
          SettableMetadata(customMetadata: {
            'uploaded_by': 'A bad guy',
            'description': 'Some description...'
          }));

      String imgUrl = await task.ref.getDownloadURL();
      DataBaseService(uid: id)
          .updateUserDataField(field: "imgUrl", value: imgUrl);

      Provider.of<UserProvider>(context, listen: false).activeUserImgUrl =
          imgUrl;

      //if (task == null) return;
      // Refresh the UI
      setState(() {});
    } on FirebaseException catch (error) {
      print(error);
    }

    (err) {
      print(err);
    };
  }
}
