import 'package:acroworld/components/buttons/custom_button.dart';
import 'package:acroworld/graphql/queries.dart';
import 'package:acroworld/models/class_event.dart';
import 'package:acroworld/models/gender_model.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class EditUserdata extends StatefulWidget {
  const EditUserdata({Key? key}) : super(key: key);

  @override
  State<EditUserdata> createState() => _EditUserdataState();
}

class _EditUserdataState extends State<EditUserdata> {
  late TextEditingController nameController;
  String? acroRole;
  String? acroRoleId;
  String? acroLevel;
  String? acroLevelId;

  @override
  void initState() {
    super.initState();
    User user = Provider.of<UserProvider>(context, listen: false).activeUser!;
    nameController = TextEditingController(text: user.name);

    acroRole = user.gender?.name;
    acroRoleId = user.gender?.id;
    acroLevel = user.level?.name;
    acroLevelId = user.level?.id;
  }

  // function that sets Acrogender and AcrogenderId
  void setAcroRole(String value, String id) {
    setState(() {
      acroRole = value;
      acroRoleId = id;
    });
  }

  // function that sets Acrolevel and AcrolevelId
  void setAcroLevel(String value, String id) {
    setState(() {
      acroLevel = value;
      acroLevelId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    // define a scaffold
    return WillPopScope(
      onWillPop: () async {
        print("back button pressed");
        // if the user presses the back button, check if the user has changed anything
        final changes = Provider.of<UserProvider>(context, listen: false)
            .getChanges(nameController.text, acroRoleId, acroLevelId);
        print("changes $changes");
        // if so, show a dialog
        if (changes != null && changes.isNotEmpty) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text(
                      "You have unsaved changes. Are you sure you want to leave?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                );
              });
          return Future.value(false);
        } else {
          // if not, just pop the page
          return Future.value(true);
        }
      },
      child: Scaffold(
        // an appbar with a back button and a title
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.maybePop(context);
            },
          ),
          title: const Text("Edit your data"),
        ),
        // make a bottom
        // a body with grey background and a Column
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Name:"),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    const Text("Acro Role:"),
                    const SizedBox(height: 8.0),
                    ChooseGenderInput(
                      currentGender: acroRole,
                      setCurrentGender: setAcroRole,
                    ),
                    const SizedBox(height: 8.0),
                    // same for the level
                    const SizedBox(height: 16.0),
                    const Text("Acro Level:"),
                    const SizedBox(height: 8.0),
                    ChooseLevelInput(
                      currentLevel: acroLevel,
                      setCurrentLevel: setAcroLevel,
                    )
                  ],
                ),
                const Spacer(),
                CustomButton("Save", () {
                  final changes = Provider.of<UserProvider>(context,
                          listen: false)
                      .getChanges(nameController.text, acroRoleId, acroLevelId);
                  // check if the user has changed anything
                  if (changes != null && changes.isNotEmpty) {
                    // if so, update the user
                    Provider.of<UserProvider>(context, listen: false)
                        .updateUserFromChanges(changes)
                        .then((value) {
                      // notify the user
                      Fluttertoast.showToast(
                          msg: "Your data has been updated",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      // and pop the page
                      Navigator.pop(context);
                    });
                  } else {
                    // if not, just pop the page
                    Navigator.pop(context);
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChooseGenderInput extends StatelessWidget {
  const ChooseGenderInput(
      {Key? key, required this.currentGender, required this.setCurrentGender})
      : super(key: key);

  final String? currentGender;
  final Function(String, String) setCurrentGender;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: Queries.allGender,
          fetchPolicy: FetchPolicy.networkOnly,
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            // ignore: avoid_print
            print(result.exception.toString());
            return SizedBox(
                height: 50,
                child: Center(child: Text(result.exception.toString())));
          } else if (result.isLoading) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            try {
              List<GenderModel> genderModels =
                  (result.data!["acro_roles"] as List<dynamic>)
                      .map((e) => GenderModel.fromJson(e))
                      .toList();

              return InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currentGender,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      String? acroRoleId = genderModels
                          .firstWhere((element) => element.name == newValue)
                          .id;
                      setCurrentGender(newValue!, acroRoleId!);
                    },
                    items: genderModels
                        .map((e) => e.name ?? "unknown")
                        .toList()
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              );
            } catch (e) {
              return SizedBox(
                height: 50,
                child: Center(child: Text(e.toString())),
              );
            }
          }
        });
  }
}

class ChooseLevelInput extends StatelessWidget {
  const ChooseLevelInput(
      {Key? key, required this.currentLevel, required this.setCurrentLevel})
      : super(key: key);

  final String? currentLevel;
  final Function(String, String) setCurrentLevel;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: Queries.allLevels,
          fetchPolicy: FetchPolicy.networkOnly,
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            // ignore: avoid_print
            print(result.exception.toString());
            return SizedBox(
                height: 50,
                child: Center(child: Text(result.exception.toString())));
          } else if (result.isLoading) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            try {
              List<Level> levelModels =
                  (result.data!["levels"] as List<dynamic>)
                      .map((e) => Level.fromJson(e))
                      .toList();

              return InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currentLevel,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      String? acroLevelId = levelModels
                          .firstWhere((element) => element.name == newValue)
                          .id;
                      setCurrentLevel(newValue!, acroLevelId!);
                    },
                    items: levelModels
                        .map((e) => e.name ?? "unknown")
                        .toList()
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              );
            } catch (e) {
              return SizedBox(
                height: 50,
                child: Center(child: Text(e.toString())),
              );
            }
          }
        });
  }
}
