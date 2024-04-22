// import 'package:acroworld/screens/authentication_screens/choose_gender_screen/choose_gender_body.dart';
// import 'package:acroworld/screens/authentication_screens/update_fcm_token/update_fcm_token.dart';
// import 'package:flutter/material.dart';

// class ChooseGender extends StatefulWidget {
//   const ChooseGender({Key? key}) : super(key: key);

//   @override
//   State<ChooseGender> createState() => _ChooseGenderState();
// }

// class _ChooseGenderState extends State<ChooseGender> {
//   String? gender; // 0, 1, 2...
//   bool loading = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: ChooseGenderBody(
//       onContinue: () => Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) => const UpdateFcmToken()),
//       ),
//     ));
//   }
// }
