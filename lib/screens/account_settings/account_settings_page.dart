import 'package:acroworld/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/screens/account_settings/delete_account.dart';
import 'package:acroworld/screens/account_settings/edit_user_data_page/edit_userdata_page.dart';
import 'package:acroworld/screens/base_page.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      makeScrollable: false,
      appBar: const CustomAppbarSimple(title: "Account settings"),
      child: Padding(
        padding: const EdgeInsets.all(AppPaddings.small).copyWith(bottom: 50),
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
                  builder: (context) => const EditUserdataPage(),
                  // EditUserdata(),
                ),
              ),
            ),
          ),

          const Spacer(),
          const Center(child: DeleteAccount()),
        ]),
      ),
    );
  }
}
