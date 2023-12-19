// import 'package:acroworld/components/buttons/standart_button.dart';
// import 'package:acroworld/graphql/queries.dart';
// import 'package:acroworld/models/gender_model.dart';
// import 'package:acroworld/screens/authentication_screens/choose_gender_screen/choose_gender_body.dart';
// import 'package:acroworld/utils/helper_functions/helper_functions.dart';
// import 'package:acroworld/utils/text_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// class YourGenderButtonWidget extends StatelessWidget {
//   const YourGenderButtonWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Query if user has a gender

//     // if he does -> show gender
//     // if not show button to where you can choose (maybe modal or page with back button)
//     return Query(
//       options: QueryOptions(
//         document: Queries.meGender,
//         fetchPolicy: FetchPolicy.networkOnly,
//       ),
//       builder: (QueryResult meGenderResult,
//           {VoidCallback? refetch, FetchMore? fetchMore}) {
//         if (meGenderResult.hasException) {
//           // ignore: avoid_print
//           print(meGenderResult.exception.toString());
//           return Container();
//         } else if (meGenderResult.isLoading || !meGenderResult.isConcrete) {
//           return const SizedBox(
//             height: 50,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         } else {
//           GenderModel gender = GenderModel.fromJson(
//               meGenderResult.data!["me"]?[0]?['acro_role']);

//           if (gender.id == null || gender.name == null) {
//             return StandartButton(
//               text: "Choose a role",
//               onPressed: () => buildMortal(
//                 context,
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.92,
//                   child: ChooseGenderBody(
//                     onContinue: () {
//                       refetch!();
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ),
//               ),
//             );
//           }
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   const Text(
//                     "Role:",
//                     style: H18W4,
//                   ),
//                   const SizedBox(width: 5),
//                   Text(gender.name!, style: H20W6)
//                 ],
//               ),
//               const SizedBox(height: 10),
//               StandartButton(
//                 text: "Change role",
//                 onPressed: () => buildMortal(
//                   context,
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.92,
//                     child: ChooseGenderBody(
//                         genderId: gender.id,
//                         onContinue: () {
//                           refetch!();
//                           Navigator.of(context).pop();
//                         }),
//                   ),
//                 ),
//               )
//             ],
//           );
//         }
//       },
//     );
//   }
// }
