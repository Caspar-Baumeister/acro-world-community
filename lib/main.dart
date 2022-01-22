import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/wrapper.dart';
import 'package:acroworld/services/auth.dart';
import 'package:acroworld/services/preferences/user_id.dart';
import 'package:acroworld/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserIdPreferences.init();
  return runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.connectionState);
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => UserProvider()),

                // Streamprovider listenes if a user is authenticated and returns that user (with id)
                StreamProvider<User?>.value(
                  value: AuthService().user,
                  initialData: null,
                )
              ],
              child: const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Wrapper(),
              ));
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Loading();
      },
    );
  }
}
