import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/screens/account_settings/delete_account.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      makeScrollable: false,
      appBar: const CustomAppbarSimple(title: "Account settings"),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingSmall).copyWith(bottom: 50),
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
              onTap: () => context.pushNamed(editUserDataRoute),
            ),
          ),

          const Spacer(),
          const Center(child: DeleteAccount()),
        ]),
      ),
    );
  }
}
