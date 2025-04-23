import 'package:acroworld/presentation/components/send_feedback_button.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/helper_functions/logout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => context.goNamed(
                  accountSettingsRoute,
                ),
                child: ListTile(
                    leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.settings_outlined),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Settings",
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  ],
                )),
              ),
              const Divider(color: Colors.grey, height: 1),
              GestureDetector(
                onTap: () => context.goNamed(
                  essentialsRoute,
                ),
                child: ListTile(
                    leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.backpack_outlined),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Essentials",
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  ],
                )),
              ),
              const Divider(color: Colors.grey, height: 1),
              GestureDetector(
                onTap: () => showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => const FeedbackPopUp(
                        subject: 'Feedback from AcroWorld App',
                        title: "Feedback & Bugs")),
                child: ListTile(
                    leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.feedback_outlined),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Feedback & Bugs",
                      style: Theme.of(context).textTheme.headlineSmall,
                    )
                  ],
                )),
              ),
              const Divider(color: Colors.grey, height: 1),
              buildMenuItem(
                  text: "Log out",
                  icon: Icons.logout,
                  onPressed: () async {
                    await logOut(context);
                  }),
              Spacer(),
              VersionDisplay()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required String text,
      required IconData icon,
      required VoidCallback onPressed}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        text,
      ),
      onTap: onPressed,
    );
  }
}

class VersionDisplay extends StatelessWidget {
  const VersionDisplay({super.key});

  Future<String> _getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getAppVersion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading version...');
        } else if (snapshot.hasError) {
          return const Text('Version unavailable');
        } else {
          return Text(
            'Version: ${snapshot.data}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          );
        }
      },
    );
  }
}
