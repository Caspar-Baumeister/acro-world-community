import 'package:acroworld/models/class_model.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';

class ClassTileLocationWidget extends StatelessWidget {
  const ClassTileLocationWidget({
    super.key,
    required this.classObject,
  });

  final ClassModel classObject;

  @override
  Widget build(BuildContext context) {
    print("classObject.locationName: ${classObject.locationName}");
    return classObject.locationName == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: AppPaddings.tiny),
            child: Text(
              classObject.locationName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
            ),
          );
  }
}
