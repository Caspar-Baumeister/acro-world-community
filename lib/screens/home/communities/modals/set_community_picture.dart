import 'package:acroworld/shared/constants.dart';
import 'package:flutter/material.dart';

class SetCommunityPicture extends StatefulWidget {
  const SetCommunityPicture({Key? key}) : super(key: key);

  @override
  State<SetCommunityPicture> createState() => _SetCommunityPictureState();
}

class _SetCommunityPictureState extends State<SetCommunityPicture> {
  String imgUrl = COMMUNITY_IMG_URL;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CircleAvatar(radius: 50.0, backgroundImage: NetworkImage(imgUrl)),
      // Positioned(
      //   bottom: 10.0,
      //   right: 10.0,
      //   child: CircleAvatar(
      //     radius: 30,
      //     backgroundColor: Colors.white,
      //     child: IconButton(
      //       icon: const Icon(
      //         Icons.camera_alt_outlined,
      //         color: Colors.black,
      //       ),
      //       onPressed: () => pickFile(),
      //     ),
      //   ),
      // )
    ]);
  }

  Future pickFile() async {
    // FirebaseStorage storage = FirebaseStorage.instance;
    // final FilePickerResult? result =
    //     await FilePicker.platform.pickFiles(allowMultiple: false);
    // if (result == null) return;

    // final String path = result.files.single.path!;

    // File file = File(path);

    //   try {
    //     // Uploading the selected image with some custom meta data
    //     TaskSnapshot task = await storage.ref(id).putFile(
    //         file,
    //         SettableMetadata(customMetadata: {
    //           'uploaded_by': 'A bad guy',
    //           'description': 'Some description...'
    //         }));

    //     String imgUrl = await task.ref.getDownloadURL();
    //     DataBaseService(uid: id)
    //         .updateUserDataField(field: "imgUrl", value: imgUrl);

    //     Provider.of<UserProvider>(context, listen: false).activeUserImgUrl =
    //         imgUrl;

    //     if (task == null) return;
    //     // Refresh the UI
    //     setState(() {});
    //   } on FirebaseException catch (error) {
    //   }

    //   (err) {
    //   };
    // }
  }
}
