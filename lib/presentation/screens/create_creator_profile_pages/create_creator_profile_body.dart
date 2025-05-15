import 'dart:typed_data';

import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/environment.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/custom_divider.dart';
import 'package:acroworld/presentation/components/input/custom_option_input_component.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/create_creator_profile_pages/components/additional_images_picker_component.dart';
import 'package:acroworld/presentation/screens/create_creator_profile_pages/components/profile_image_picker_component.dart';
import 'package:acroworld/provider/auth/token_singleton_service.dart';
import 'package:acroworld/provider/creator_provider.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/services/gql_client_service.dart';
import 'package:acroworld/services/profile_creation_service.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/helper_functions.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
// provider as provider
import 'package:provider/provider.dart' as provider;

class CreateCreatorProfileBody extends ConsumerStatefulWidget {
  const CreateCreatorProfileBody({
    super.key,
    this.isEditing = false,
  });

  final bool isEditing;

  @override
  ConsumerState<CreateCreatorProfileBody> createState() =>
      _CreateCreatorProfileBodyState();
}

class _CreateCreatorProfileBodyState
    extends ConsumerState<CreateCreatorProfileBody> {
  Uint8List? _profileImage;
  final List<Uint8List> _additionalImages = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool? _isSlugAvailable;
  bool? _isSlugValid;
  String? _creatorType;
  String? _currentImage;
  List<String> _currentAdditionalImages = [];

  late TextEditingController _nameController;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlSlugController = TextEditingController();

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // We only create the controllers; their initial text comes
    // from Riverpod in build() on first data render.
    _nameController = TextEditingController();
    _urlSlugController.addListener(() {
      final slug = _urlSlugController.text;
      if (slug.isNotEmpty) checkSlugAvailability(slug);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlSlugController.dispose();
    super.dispose();
  }

  Future<void> _handleProfileImageSelected(Uint8List image) async {
    setState(() => _profileImage = image);
  }

  Future<void> _handleAdditionalImagesSelected(List<Uint8List> images) async {
    setState(() => _additionalImages.addAll(images));
  }

  Future<void> _handleUploadAndMutation(User user) async {
    final client = GraphQLClientSingleton().client;
    final profileService = ProfileCreationService(client, ImageUploadService());

    if (user.id == null) {
      setState(() => _errorMessage = 'User ID not found');
      return;
    }

    if (_profileImage == null && !widget.isEditing) {
      setState(() => _errorMessage = 'Please select a profile image.');
      return;
    }
    if (_nameController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a name.');
      return;
    }
    if (_descriptionController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a description.');
      return;
    }
    if (_creatorType == null) {
      setState(() => _errorMessage = 'Please select a creator type.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1️⃣ upload images
      final profileImageUrl = _profileImage != null
          ? await profileService.uploadProfileImage(_profileImage!)
          : _currentImage!;

      final additionalImageUrls = <String>[
        if (_additionalImages.isNotEmpty)
          ...await profileService.uploadAdditionalImages(_additionalImages),
        ..._currentAdditionalImages,
      ];

      if (!widget.isEditing) {
        // 2️⃣ create
        final msg = await profileService.createTeacherProfile(
          _nameController.text.trim(),
          _descriptionController.text.trim(),
          _urlSlugController.text.trim(),
          profileImageUrl,
          additionalImageUrls,
          _creatorType!,
          user.id!,
        );
        if (msg != 'success') {
          setState(() => _errorMessage = msg);
          return;
        }
        showSuccessToast("Teacher profile created successfully");

        // 3️⃣ refresh token & user in Riverpod, then navigate
        await TokenSingletonService().refreshToken();
        ref.invalidate(userRiverpodProvider);
        context.goNamed(creatorProfileRoute);
      } else {
        // 2️⃣ update
        final creatorProvider =
            provider.Provider.of<CreatorProvider>(context, listen: false);
        final teacherId = creatorProvider.activeTeacher?.id;
        if (teacherId == null) {
          setState(() => _errorMessage = 'Teacher ID not found');
          return;
        }
        final msg = await profileService.updateTeacherProfile(
          _nameController.text.trim(),
          _descriptionController.text.trim(),
          _urlSlugController.text.trim(),
          profileImageUrl,
          additionalImageUrls,
          _creatorType!,
          user.id!,
          teacherId,
        );
        if (msg != 'success') {
          setState(() => _errorMessage = msg);
          return;
        }
        showSuccessToast("Teacher profile updated successfully");
        Navigator.of(context).pop();
        creatorProvider.setCreatorFromToken();
      }
    } catch (e, st) {
      CustomErrorHandler.captureException(e.toString(), stackTrace: st);
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> checkSlugAvailability(String slug) async {
    setState(() => _isSlugValid = true);

    if (widget.isEditing) {
      // if you have a creatorRiverpodProvider you can watch it instead of Provider.of
      final existing =
          provider.Provider.of<CreatorProvider>(context, listen: false)
              .activeTeacher
              ?.slug;
      if (existing?.toLowerCase() == slug.toLowerCase()) {
        return;
      }
    }

    if (slug.isEmpty || slug.contains(RegExp(r'[^a-z0-9-]'))) {
      setState(() => _isSlugValid = false);
      return;
    }

    final client = GraphQLClientSingleton().client;
    const query = """
      query CheckSlugAvailability(\$url_slug: String!) {
        is_teacher_slug_available(url_slug: \$url_slug)
      }
    """;

    final res = await client.query(QueryOptions(
      document: gql(query),
      variables: {'url_slug': slug},
    ));
    if (res.hasException) {
      setState(() => _isSlugAvailable = false);
      return;
    }
    setState(() {
      _isSlugAvailable =
          res.data?['is_teacher_slug_available'] as bool? ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userRiverpodProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) {
            CustomErrorHandler.captureException(e.toString(), stackTrace: st);
            return const Center(child: Text("Error loading user"));
          },
          data: (user) {
            if (user == null) {
              // Not signed in, redirect
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => context.goNamed(authRoute));
              return const SizedBox.shrink();
            }

            // Initialize form on first data
            if (!_initialized) {
              _nameController.text = user.name ?? '';
              setUrlSlug(user.name ?? '');
              _currentImage = null;
              _creatorType = null;
              _currentAdditionalImages = [];
              _initialized = true;
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddings.medium,
                    vertical: AppPaddings.large,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile picker
                        ProfileImagePickerComponent(
                          currentImage: _currentImage,
                          profileImage: _profileImage,
                          onImageSelected: _handleProfileImageSelected,
                        ),
                        const SizedBox(height: AppPaddings.small),
                        Center(
                          child: Text(
                            _nameController.text,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: AppPaddings.small),
                        Center(
                          child: GestureDetector(
                            onTap: () => widget.isEditing &&
                                    _urlSlugController.text.isNotEmpty
                                ? customLaunch(
                                    "${AppEnvironment.websiteUrl}/partner/${_urlSlugController.text}",
                                  )
                                : null,
                            child: Text(
                              "${AppEnvironment.websiteUrl}/partner/${_urlSlugController.text}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: CustomColors.linkTextColor),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppPaddings.medium),
                        const CustomDivider(),
                        const SizedBox(height: AppPaddings.large),

                        // Name field
                        InputFieldComponent(
                          controller: _nameController,
                          labelText: 'Creator Name',
                          validator: (v) =>
                              v!.isEmpty ? 'Name cannot be empty' : null,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: AppPaddings.medium),

                        // Slug field
                        InputFieldComponent(
                          controller: _urlSlugController,
                          labelText: 'URL Slug',
                          footnoteText: _isSlugValid == false
                              ? "Use only lowercase letters, numbers & hyphens"
                              : (_isSlugAvailable == false
                                  ? "This slug is already taken"
                                  : 'Used in your profile URL'),
                          isFootnoteError: _isSlugValid == false ||
                              _isSlugAvailable == false,
                          suffixIcon: _isSlugAvailable == null
                              ? null
                              : (_isSlugAvailable == false ||
                                      _isSlugValid == false)
                                  ? const Icon(Icons.error,
                                      color: CustomColors.errorTextColor)
                                  : const Icon(Icons.check_circle,
                                      color: CustomColors.successTextColor),
                        ),
                        const SizedBox(height: AppPaddings.medium),

                        // Description
                        InputFieldComponent(
                          controller: _descriptionController,
                          labelText: 'Description',
                          maxLines: 5,
                          minLines: 2,
                        ),
                        const SizedBox(height: AppPaddings.medium),

                        // Creator type dropdown
                        CustomQueryOptionInputComponent(
                          hintText: 'What kind of creator are you?',
                          footnoteText: "Determines how you appear in the app",
                          currentOption: _creatorType,
                          identifier: 'teacher_type',
                          valueIdentifier: "value",
                          query: QueryOptions(
                            document: gql("""
                          query {
                            teacher_type { value }
                          }
                        """),
                          ),
                          setOption: (val) =>
                              setState(() => _creatorType = val),
                        ),
                        const SizedBox(height: AppPaddings.medium),

                        // Additional images
                        AdditionalImagePickerComponent(
                          additionalImages: _additionalImages,
                          onImagesSelected: _handleAdditionalImagesSelected,
                          currentImages: _currentAdditionalImages,
                          onImageRemoved: (i, isCurrent) {
                            setState(() {
                              if (isCurrent) {
                                _currentAdditionalImages.removeAt(i);
                              } else {
                                _additionalImages.removeAt(i);
                              }
                            });
                          },
                        ),
                        const SizedBox(height: AppPaddings.large),

                        // Save/Create button
                        StandartButton(
                          isFilled: true,
                          onPressed: () => _handleUploadAndMutation(user),
                          text: widget.isEditing
                              ? 'Save Changes'
                              : 'Create Teacher Profile',
                          loading: _isLoading,
                        ),

                        if (_errorMessage != null) ...[
                          const SizedBox(height: AppPaddings.small),
                          Text(
                            _errorMessage!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: CustomColors.errorTextColor),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
  }

  void setUrlSlug(String name) {
    final slug = name.toLowerCase().replaceAll(' ', '-');
    _urlSlugController.text = slug;
    checkSlugAvailability(slug);
  }
}
