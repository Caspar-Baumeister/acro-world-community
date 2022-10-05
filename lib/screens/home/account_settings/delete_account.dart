import 'package:acroworld/graphql/mutations.dart';
import 'package:acroworld/preferences/login_credentials_preferences.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/authentication_screens/authenticate.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool loading = false;
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(document: Mutations.deleteAccount),
      builder: (MultiSourceResult<dynamic> Function(Map<String, dynamic>,
                  {Object? optimisticResult})
              runMutation,
          QueryResult<dynamic>? result) {
        if (result != null) {
          if (result.data?['delete_account'] != null) {
            if (result.data!['delete_account']["success"] == true) {
              Fluttertoast.showToast(
                  msg: "your account was deleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              print(result.data.toString());
              Fluttertoast.showToast(
                  msg: "something went wrong",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        }

        return SizedBox(
          height: 40,
          child: ElevatedButton(
            child: loading
                ? Center(
                    child: Container(
                        height: 20,
                        width: 20,
                        padding: const EdgeInsets.all(5),
                        child: const CircularProgressIndicator()))
                : const Text("delete account",
                    style: TextStyle(fontSize: 14, color: Colors.red)),

            // if disapled or loading, return null
            onPressed: loading
                ? null
                // if authentication is not neccesary, return onPressed
                : () => showDeleteDialog(context, () => runMutation({})),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        );
      },
    );
  }

  deleteAccount(Function runMutation) async {
    logOut(context);
    runMutation();
  }

  showDeleteDialog(BuildContext context, Function runMutation) {
    //Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              // height: 500,
              // width: 400,
              //width: MediaQuery.of(context).size.width * 0.7,
              // height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text("Are you sure, you want to delete your profile?"),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: () {
                              return deleteAccount(runMutation);
                            },
                            child: const Text(
                              "Confirm",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  logOut(BuildContext context) {
    // deletes the credentials
    CredentialPreferences.removeEmail();
    CredentialPreferences.removePassword();

    // deletes the token and user from user provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.token = null;

    // safe the user to provider
    userProvider.setUserFromToken();

    // delete all and push to authentication
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Authenticate()),
        (Route<dynamic> route) => false);
  }
}
