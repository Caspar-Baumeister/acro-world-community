import 'dart:typed_data';

import 'package:acroworld/components/buttons/standart_button.dart';
import 'package:acroworld/components/custom_divider.dart';
import 'package:acroworld/components/input/custom_option_input_component.dart';
import 'package:acroworld/components/input/input_field_component.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/models/user_model.dart';
import 'package:acroworld/provider/user_provider.dart';
import 'package:acroworld/screens/create_creator_profile_pages/components/additional_images_picker_component.dart';
import 'package:acroworld/screens/create_creator_profile_pages/components/profile_image_picker_component.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/profile_creation_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class CreateCreatorProfileBody extends StatefulWidget {
  const CreateCreatorProfileBody({
    super.key,
  });

  @override
  State<CreateCreatorProfileBody> createState() =>
      _CreateCreatorProfileBodyState();
}

class _CreateCreatorProfileBodyState extends State<CreateCreatorProfileBody> {
  Uint8List? _profileImage;
  final List<Uint8List> _additionalImages = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool? _isSlugAvailable;
  bool? _isSlugValid;
  String? _creatorType;

  late TextEditingController _nameController;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlSlugController = TextEditingController();

  @override
  void initState() {
    super.initState();
    User? user = Provider.of<UserProvider>(context, listen: false).activeUser;

    _nameController = TextEditingController(text: user?.name);
    setUrlSlug(user != null ? user.name! : '');

    // Add listener to the _nameController to update UI whenever the name changes
    _nameController.addListener(() {
      setState(() {});
    });

    // Add listener to the _urlSlugController to check slug availability
    _urlSlugController.addListener(() {
      if (_urlSlugController.text.isNotEmpty) {
        checkSlugAvailability(_urlSlugController.text);
      }
    });
  }

  void setUrlSlug(String name) {
    _urlSlugController.text = name.toLowerCase().replaceAll(' ', '-');
    checkSlugAvailability(_urlSlugController.text);
  }

  Future<void> _handleProfileImageSelected(Uint8List image) async {
    setState(() {
      _profileImage = image;
    });
  }

  Future<void> _handleAdditionalImagesSelected(List<Uint8List> images) async {
    setState(() {
      _additionalImages.addAll(images);
    });
  }

  Future<void> _handleUploadAndMutation() async {
    final client = GraphQLClientSingleton().client;
    final profileService = ProfileCreationService(client);
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    if (userProvider.activeUser?.id == null) {
      setState(() {
        _errorMessage = 'User ID not found';
      });
      return;
    }

    if (_profileImage == null) {
      setState(() {
        _errorMessage = 'Please select a profile image.';
      });
      return;
    }

    if (_nameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a name.';
      });
      return;
    }

    if (_descriptionController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a description.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final String profileImageUrl =
          await profileService.uploadProfileImage(_profileImage!);

      print("Profile Image URL: $profileImageUrl");
      final List<String> additionalImageUrls =
          await profileService.uploadAdditionalImages(_additionalImages);

      print("Additional Image URLs: $additionalImageUrls");

      await profileService.createTeacherProfile(
        _nameController.text,
        _descriptionController.text,
        _urlSlugController.text,
        profileImageUrl,
        additionalImageUrls,
      );

      setState(() {
        _profileImage = null;
        _additionalImages.clear();
      });

      showSuccessToast("Teacher profile created successfully");
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> checkSlugAvailability(String slug) async {
    setState(() {
      _isSlugValid = true;
    });
    if (slug.isEmpty || slug.contains(RegExp(r'[^a-z0-9-]'))) {
      setState(() {
        _isSlugValid = false;
      });
      return;
    }

    final client = GraphQLClientSingleton().client;

    const String query = """
    query CheckSlugAvailability(\$url_slug: String!) {
      is_teacher_slug_available(url_slug: \$url_slug)
    }
    """;

    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {'url_slug': slug},
      ),
    );

    if (result.hasException) {
      setState(() {
        _isSlugAvailable = false;
      });
      return;
    }

    final bool isAvailable = result.data?['is_teacher_slug_available'] ?? false;

    setState(() {
      _isSlugAvailable = isAvailable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPaddings.medium,
            vertical: AppPaddings.large,
          ),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileImagePickerComponent(
                    profileImage: _profileImage,
                    onImageSelected: _handleProfileImageSelected,
                  ),
                  const SizedBox(height: AppPaddings.small),
                  Center(
                    child: Text(
                      _nameController.text,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppPaddings.small),
                  Center(
                    child: Text(
                      "${AppEnvironment.websiteUrl}/partner/${_urlSlugController.text}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: CustomColors.linkTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppPaddings.medium),
                  const CustomDivider(),
                  const SizedBox(height: AppPaddings.large),
                  InputFieldComponent(
                    controller: _nameController,
                    labelText: 'Creator Name',
                    validator: (p0) =>
                        p0!.isEmpty ? 'Name cannot be empty' : null,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppPaddings.medium),
                  InputFieldComponent(
                    controller: _urlSlugController,
                    labelText: 'URL Slug',
                    footnoteText: _isSlugValid == false
                        ? "Please use only lowercase letters, numbers, and hyphens"
                        : (_isSlugAvailable == false
                            ? "This slug is already taken"
                            : 'This will be used in the URL of your profile page'),
                    isFootnoteError:
                        _isSlugAvailable == false || _isSlugValid == false
                            ? true
                            : false,
                    textInputAction: TextInputAction.next,
                    suffixIcon: _isSlugAvailable == null && _isSlugValid == null
                        ? null
                        : (_isSlugAvailable == false || _isSlugValid == false)
                            ? const Icon(Icons.error,
                                color: CustomColors.errorTextColor)
                            : const Icon(Icons.check_circle,
                                color: CustomColors.successTextColor),
                  ),
                  const SizedBox(height: AppPaddings.medium),
                  InputFieldComponent(
                    controller: _descriptionController,
                    labelText: 'Description',
                    maxLines: 5,
                    minLines: 2,
                  ),
                  const SizedBox(height: AppPaddings.medium),
                  CustomQueryOptionInputComponent(
                    hintText: 'What kind of creator are you?',
                    footnoteText:
                        "This will determine how you will be shown in the app",
                    currentOption: _creatorType,
                    identifier: 'teacher_type',
                    valueIdentifier: "value",
                    query: QueryOptions(
                      document: gql("""
                      query {
                        teacher_type {
                          value
                        }
                      }
                      """),
                    ),
                    setOption: (String? value) {
                      setState(() {
                        _creatorType = value;
                      });
                    },
                  ),
                  const SizedBox(height: AppPaddings.medium),
                  AdditionalImagePickerComponent(
                    additionalImages: _additionalImages,
                    onImagesSelected: _handleAdditionalImagesSelected,
                  ),
                  const SizedBox(height: AppPaddings.large),
                  StandardButton(
                      onPressed: _handleUploadAndMutation,
                      text: 'Create Teacher Profile',
                      loading: _isLoading),
                  const SizedBox(height: AppPaddings.small),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPaddings.medium,
                      ),
                      child: Text(
                        _errorMessage!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: CustomColors.errorTextColor),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}