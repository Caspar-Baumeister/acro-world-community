// import 'package:acroworld/provider/user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ProfilePicture extends StatefulWidget {
//   const ProfilePicture({Key? key}) : super(key: key);

//   @override
//   State<ProfilePicture> createState() => _ProfilePictureState();
// }

// class _ProfilePictureState extends State<ProfilePicture> {
//   @override
//   Widget build(BuildContext context) {
//     UserProvider userProvider = Provider.of<UserProvider>(context);
//     return Stack(children: [
//       CircleAvatar(
//           radius: 100.0,
//           backgroundImage: NetworkImage(userProvider.activeUser!.imgUrl)),
//       Positioned(
//         bottom: 10.0,
//         right: 10.0,
//         child: CircleAvatar(
//           radius: 30,
//           backgroundColor: Colors.white,
//           child: IconButton(
//               icon: const Icon(
//                 Icons.camera_alt_outlined,
//                 color: Colors.black,
//               ),
//               onPressed: () {} //pickFile(userProvider.activeUser!.uid),
//               ),
//         ),
//       )
//     ]);
//   }
// }
