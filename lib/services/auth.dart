import 'package:acroworld/services/database.dart';
import 'package:acroworld/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object base on Firebase user
  // UserModel? _userFromFirebaseUser(User? user) {
  //   return user != null ? UserModel(uid: user.uid) : null;
  // }

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
    //.map((User? user) => _userFromFirebaseUser(user));
  }

  // sign in anon
  // Future signInAnon() async {
  //   try {
  //     UserCredential result = await _auth.signInAnonymously();
  //     User? user = result.user;
  //     return _userFromFirebaseUser(user);
  //   } catch (e) {
  //     print("error in signinanon");
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;

      // create a new User-info object
      if (user != null) {
        await DataBaseService(uid: user.uid).createUserInfo(userName: name);
        user.sendEmailVerification();
      }
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    print("signout triggered");
    try {
      return await _auth.signOut();
    } catch (e) {
      print("error in signout");
      print(e.toString());
      return null;
    }
  }
}
