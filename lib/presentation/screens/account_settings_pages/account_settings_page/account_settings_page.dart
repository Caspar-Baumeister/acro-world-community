import 'package:acroworld/presentation/screens/account_settings_pages/account_settings_page/components/delete_account_component.dart';
import 'package:acroworld/presentation/screens/account_settings_pages/edit_user_data_page/edit_userdata_page.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/shared_components/buttons/back_button.dart';
import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      makeScrollable: false,
      appBar: AppBar(
        leading: const BackButtonWidget(),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
      ),
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
