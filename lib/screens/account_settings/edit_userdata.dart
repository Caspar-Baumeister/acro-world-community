import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditUserdata extends StatefulWidget {
  const EditUserdata({Key? key}) : super(key: key);

  @override
  State<EditUserdata> createState() => _EditUserdataState();
}

class _EditUserdataState extends State<EditUserdata> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  String? acroRole;

  @override
  void initState() {
    super.initState();
    User user = Provider.of<UserProvider>(context, listen: false).activeUser!;
    emailController = TextEditingController(text: user.email);
    nameController = TextEditingController(text: user.name);
    acroRole = user.gender?.name;
  }

  @override
  Widget build(BuildContext context) {
    // define a scaffold
    return Scaffold(
      // an appbar with a back button and a title
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Edit your data"),
      ),
      // make a bottom
      // a body with grey background and a Column
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Email:"),
            const SizedBox(height: 8.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
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
            InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(8.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: acroRole,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      acroRole = newValue!;
                    });
                  },
                  items: <String>["Flyer", "Base", "Flyer and Base"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
