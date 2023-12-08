import 'package:acroworld/components/buttons/back_button.dart';
import 'package:acroworld/screens/account_settings/delete_account.dart';
import 'package:acroworld/screens/account_settings/edit_userdata.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 50),
          child: Column(children: [
            // a menu item called "user settings" that leads to the edit user data page
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: const Text(
                  "User settings",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                onTap: () => // route to EditUserdata
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditUserdata(),
                    // EditUserdata(),
                  ),
                ),
              ),
            ),

            const Spacer(),
            const Center(child: DeleteAccount()),
          ]),
        ),
      ),
    );
  }
}
