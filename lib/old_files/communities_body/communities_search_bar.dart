// import 'package:acroworld/provider/user_communities.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class UserCommunitiesSearchBar extends StatefulWidget {
//   const UserCommunitiesSearchBar({Key? key, required this.onChanged})
//       : super(key: key);

//   final ValueChanged<String> onChanged;

//   @override
//   _UserCommunitiesSearchBarState createState() =>
//       _UserCommunitiesSearchBarState();
// }

// class _UserCommunitiesSearchBarState extends State<UserCommunitiesSearchBar> {
//   late TextEditingController controller;

//   @override
//   void initState() {
//     controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const styleActive = TextStyle(color: Colors.black);
//     const styleHint = TextStyle(color: Colors.black54);
//     final style = controller.text != "" ? styleHint : styleActive;
//     return Container(
//       height: 42,
//       margin: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24.0),
//         color: Colors.white,
//         border: Border.all(color: Colors.black26),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: TextField(
//         textInputAction: TextInputAction.search,
//         controller: controller,
//         decoration: InputDecoration(
//           icon: Icon(
//             Icons.search,
//             color: style.color,
//           ),
//           suffixIcon: controller.text != ""
//               ? GestureDetector(
//                   child: Icon(
//                     Icons.close,
//                     color: style.color,
//                   ),
//                   onTap: () {
//                     controller.clear();
//                     Provider.of<UserCommunitiesProvider>(context, listen: false)
//                         .search();
//                     //FocusScope.of(context).requestFocus(FocusNode());
//                   },
//                 )
//               : null,
//           hintText: "search",
//           hintStyle: style,
//           border: InputBorder.none,
//         ),
//         style: style,
//         onChanged: (value) =>
//             Provider.of<UserCommunitiesProvider>(context, listen: false)
//                 .search(query: value),
//       ),
//     );
//   }
// }
