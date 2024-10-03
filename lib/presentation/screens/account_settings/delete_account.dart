import 'package:acroworld/data/graphql/mutations.dart';
import 'package:acroworld/utils/helper_functions/logout.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

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
              showSuccessToast("your account was deleted");
            } else {
              showErrorToast("something went wrong, please write us an email");
            }
          }
        }

        return SizedBox(
          height: 40,
          child: ElevatedButton(
            onPressed: loading
                ? null
                // if authentication is not neccesary, return onPressed
                : () => showDeleteDialog(context, () => runMutation({})),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: loading
                ? Center(
                    child: Container(
                        height: 20,
                        width: 20,
                        padding: const EdgeInsets.all(5),
                        child: const CircularProgressIndicator()))
                : const Text("delete account",
                    style: TextStyle(fontSize: 14, color: Colors.red)),
          ),
        );
      },
    );
  }

  deleteAccount(Function runMutation) {
    logOut(context);
    runMutation();
  }

  showDeleteDialog(BuildContext context, Function runMutation) {
    //Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
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
                          onPressed: () => deleteAccount(runMutation),
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
          );
        });
  }
}
