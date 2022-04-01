import 'package:acroworld/models/jam_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/services/database.dart';
import 'package:flutter/material.dart';

class AppBarJamOverview extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const AppBarJamOverview({required this.jam, Key? key}) : super(key: key);
  final Jam jam;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(color: Colors.black),
      backgroundColor: Colors.white,
      elevation: 0.0,
      title: Text(
        jam.name,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
