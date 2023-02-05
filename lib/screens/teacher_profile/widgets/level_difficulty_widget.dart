import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

// class DifficultyWidget extends StatelessWidget {
//   const DifficultyWidget(this.classLevel, {Key? key}) : super(key: key);

//   final List<String> classLevel;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 22,
//           height: 22,
//           decoration: BoxDecoration(
//             color: Colors.green[100],
//             border: classLevel.contains("Beginner") ? Border.all() : null,
//           ),
//         ),
//         Container(
//           width: 22,
//           height: 22,
//           decoration: BoxDecoration(
//             color: Colors.yellow[100],
//             border: classLevel.contains("Intermediate") ? Border.all() : null,
//           ),
//         ),
//         Container(
//           width: 22,
//           height: 22,
//           decoration: BoxDecoration(
//             color: Colors.red[100],
//             border: classLevel.contains("Advanced") ? Border.all() : null,
//           ),
//         )
//       ],
//     );
//   }
// }

class DifficultyWidget extends StatelessWidget {
  const DifficultyWidget(this.classLevel,
      {Key? key,
      this.height = DIFFICULTY_LEVEL_HEIGHT,
      this.totalWidth = DIFFICULTY_LEVEL_WIDTH})
      : super(key: key);

  final List<String> classLevel;
  final double height;
  final double totalWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: totalWidth,
      decoration: classLevel.contains("Open")
          ? const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromARGB(255, 194, 246, 195),
                  Color.fromARGB(255, 251, 243, 172),
                  Color.fromARGB(255, 252, 181, 188),
                ],
                stops: [
                  0.33,
                  0.66,
                  0.99,
                ],
              ),
            )
          : null,
      child: !classLevel.contains("Open")
          ? Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    classLevel.contains("Beginner")
                        ? Flexible(
                            child: Container(
                              constraints: const BoxConstraints.expand(),
                              height: height,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 194, 246, 195),
                              ),
                            ),
                          )
                        : Container(),
                    classLevel.contains("Intermediate")
                        ? Flexible(
                            child: Container(
                              constraints: const BoxConstraints.expand(),
                              height: height,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 251, 243, 172)),
                            ),
                          )
                        : Container(),
                    classLevel.contains("Advanced")
                        ? Flexible(
                            child: Container(
                              constraints: const BoxConstraints.expand(),
                              height: height,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 252, 181, 188),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                classLevel.length == 1
                    ? Text(
                        classLevel[0],
                        style: const TextStyle(fontSize: 10),
                      )
                    : Container()
              ],
            )
          : const Center(
              child: Text(
              "Open",
              style: TextStyle(fontSize: 10),
            )),
    );
  }
}
