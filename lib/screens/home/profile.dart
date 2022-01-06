import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    QuerySnapshot<Object?>? info = Provider.of<QuerySnapshot?>(context);
    if (info != null) {
      for (var doc in info.docs) {
        print(doc.data());
      }
    }
    ;
    return Container();
  }
}
