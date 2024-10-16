import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/presentation/screens/create_creator_profile_pages/create_creator_profile_body.dart';
import 'package:flutter/material.dart';

class CreateCreatorProfilePage extends StatelessWidget {
  const CreateCreatorProfilePage({super.key, this.isEditing = false});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BasePage(
        appBar: CustomAppbarSimple(
            title:
                isEditing ? "Edit Partner Account" : "Create Partner Account"),
        child: CreateCreatorProfileBody(
          isEditing: isEditing,
        ));
  }
}
