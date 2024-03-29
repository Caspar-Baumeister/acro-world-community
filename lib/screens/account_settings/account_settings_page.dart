import 'package:acroworld/components/buttons/back_button.dart';
import 'package:acroworld/screens/account_settings/delete_account.dart';
import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 50),
            child: const DeleteAccount(),
          ),
        ),
      ),
    );
  }
}
