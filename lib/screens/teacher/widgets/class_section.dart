import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/screens/teacher/single_class_page.dart';
import 'package:flutter/material.dart';

class ClassSection extends StatelessWidget {
  const ClassSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: adrainClasses.length,
        itemBuilder: ((context, index) {
          ClassModel indexClass = adrainClasses[index];
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const SingleClassPage(
                        classId: "class",
                      )),
            ),
            child: ListTile(
              // leading: const CircleAvatar(
              //   radius: 3,
              //   backgroundImage: AssetImage("assets/logo/play_store_512.png"),
              // ),
              title: Text(indexClass.name),
              subtitle: Text(indexClass.locationName),
              //     style: const TextStyle(fontWeight: FontWeight.w300)),
            ),
          );
        }));
  }
}
