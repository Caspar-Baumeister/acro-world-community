import 'package:acroworld/loggin_wrapper.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CredentialPreferences.init();
  return runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          // LoginWrapper checks for token?
          // Also possible: Routerdelegate with auth check and guards
          home: LogginWrapper(),
        ));
  }
}
