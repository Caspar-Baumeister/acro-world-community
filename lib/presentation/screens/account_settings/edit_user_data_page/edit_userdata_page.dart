import 'dart:typed_data';

import 'package:acroworld/data/graphql/queries.dart'; // for the dropdown queries
import 'package:acroworld/data/models/class_event.dart'; // if still needed
import 'package:acroworld/data/models/gender_model.dart';
import 'package:acroworld/data/models/user_model.dart';
import 'package:acroworld/exceptions/error_handler.dart';
import 'package:acroworld/presentation/components/appbar/custom_appbar_simple.dart';
import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/guest_profile_content.dart';
import 'package:acroworld/presentation/components/input/user_image_picker.dart';
import 'package:acroworld/presentation/components/loading/modern_skeleton.dart';
import 'package:acroworld/presentation/screens/base_page.dart';
import 'package:acroworld/provider/riverpod_provider/user_providers.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EditUserdataPage extends ConsumerStatefulWidget {
  const EditUserdataPage({super.key});

  @override
  ConsumerState<EditUserdataPage> createState() => _EditUserdataPageState();
}

class _EditUserdataPageState extends ConsumerState<EditUserdataPage> {
  late final TextEditingController nameController;
  String? acroRole;
  String? acroRoleId;
  String? acroLevel;
  String? acroLevelId;
  bool _initialized = false;

  // Image upload state
  Uint8List? _selectedImageBytes;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? _computeChanges(User user) {
    final changes = <String, dynamic>{};
    if (acroRoleId != null && user.gender?.id != acroRoleId) {
      changes['acro_role_id'] = acroRoleId;
    }
    if (acroLevelId != null && user.level?.id != acroLevelId) {
      changes['level_id'] = acroLevelId;
    }
    if (nameController.text != user.name) {
      changes['name'] = nameController.text;
    }
    return changes.isEmpty ? null : changes;
  }

  Future<bool> _onSave(User user) async {
    // Handle image upload first if there's a selected image
    if (_selectedImageBytes != null) {
      setState(() {
        _isUploadingImage = true;
      });

      try {
        final success = await ref
            .read(userNotifierProvider.notifier)
            .uploadAndUpdateImage(_selectedImageBytes!);

        if (!success) {
          showErrorToast("Failed to upload profile image");
          setState(() {
            _isUploadingImage = false;
          });
          return false;
        }

        // Clear the selected image after successful upload
        setState(() {
          _selectedImageBytes = null;
        });
      } catch (e) {
        showErrorToast("Error uploading image: $e");
        setState(() {
          _isUploadingImage = false;
        });
        return false;
      } finally {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }

    // Handle other field changes
    final changes = _computeChanges(user);
    if (changes == null) return true; // nothing to do
    final success =
        await ref.read(userNotifierProvider.notifier).updateFields(changes);
    if (success) {
      showSuccessToast("Your data has been updated");
    } else {
      showErrorToast("Something went wrong, profile not updated");
    }
    return success;
  }

  Future<void> _handleImageSelected(Uint8List imageBytes) async {
    setState(() {
      _selectedImageBytes = imageBytes;
    });
  }

  Future<void> _handleImageRemoved() async {
    setState(() {
      _selectedImageBytes = null;
    });
  }

  Future<bool> _onWillPop(User user) async {
    final changes = _computeChanges(user);
    if (changes != null) {
      return (await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Are you sure?"),
              content: const Text(
                  "You have unsaved changes. Are you sure you want to leave?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(_, false),
                    child: const Text("No")),
                TextButton(
                    onPressed: () => Navigator.pop(_, true),
                    child: const Text("Yes")),
              ],
            ),
          )) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userNotifierProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ModernSkeleton(width: 200, height: 20),
              SizedBox(height: 16),
              ModernSkeleton(width: 300, height: 100),
              SizedBox(height: 16),
              ModernSkeleton(width: 250, height: 80),
            ],
          ),
        ),
      ),
      error: (err, st) {
        CustomErrorHandler.captureException(err.toString(), stackTrace: st);
        return Scaffold(
          body: Center(child: Text("Error loading profile: $err")),
        );
      },
      data: (user) {
        if (user == null) {
          // Not signed in or no user → redirect to auth

          return Scaffold(
            appBar: const CustomAppbarSimple(title: "Edit User Data"),
            body: GuestProfileContent(
                subtitle: "Please sign in to edit your profile."),
          );
        }

        // Initialize controllers & dropdowns on first build
        if (!_initialized) {
          nameController.text = user.name ?? "";
          acroRole = user.gender?.name;
          acroRoleId = user.gender?.id;
          acroLevel = user.level?.name;
          acroLevelId = user.level?.id;
          _initialized = true;
        }

        final isSaving = ref.watch(userNotifierProvider).isLoading;

        return WillPopScope(
          onWillPop: () => _onWillPop(user),
          child: BasePage(
            makeScrollable: false,
            appBar: const CustomAppbarSimple(title: "Edit User Data"),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // — Name —
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Name:")),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // — Profile Image Section —
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Profile Picture:")),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [
                        UserImagePickerComponent(
                          currentImageUrl: user.imageUrl,
                          onImageSelected: _handleImageSelected,
                          onImageRemoved: _handleImageRemoved,
                          size: 100,
                          showEditIcon: true,
                          showRemoveButton: false,
                          isLoading: _isUploadingImage,
                        ),
                        if (_selectedImageBytes != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'New image selected - will be uploaded when you save',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // — Gender dropdown —
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Acro Role:")),
                  const SizedBox(height: 8),
                  Query(
                    options: QueryOptions(
                      document: Queries.allGender,
                      fetchPolicy: FetchPolicy.networkOnly,
                    ),
                    builder: (result, {refetch, fetchMore}) {
                      if (result.hasException) {
                        CustomErrorHandler.captureException(
                            result.exception.toString());
                        return SizedBox(
                          height: 50,
                          child:
                              Center(child: Text(result.exception.toString())),
                        );
                      }
                      if (result.isLoading) {
                        return const SizedBox(
                          height: 50,
                          child: Center(
                            child: ModernSkeleton(width: 100, height: 20),
                          ),
                        );
                      }
                      final roles = (result.data!['acro_roles'] as List)
                          .map((e) => GenderModel.fromJson(e))
                          .toList();
                      return InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: acroRole,
                            isExpanded: true,
                            onChanged: (newVal) {
                              final id =
                                  roles.firstWhere((r) => r.name == newVal).id!;
                              setState(() {
                                acroRole = newVal;
                                acroRoleId = id;
                              });
                            },
                            items: roles
                                .map((r) => r.name!)
                                .map((name) => DropdownMenuItem(
                                      value: name,
                                      child: Text(name),
                                    ))
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // — Level dropdown —
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Acro Level:")),
                  const SizedBox(height: 8),
                  Query(
                    options: QueryOptions(
                      document: Queries.allLevels,
                      fetchPolicy: FetchPolicy.networkOnly,
                    ),
                    builder: (result, {refetch, fetchMore}) {
                      if (result.hasException) {
                        CustomErrorHandler.captureException(
                            result.exception.toString());
                        return SizedBox(
                          height: 50,
                          child:
                              Center(child: Text(result.exception.toString())),
                        );
                      }
                      if (result.isLoading) {
                        return const SizedBox(
                          height: 50,
                          child: Center(
                            child: ModernSkeleton(width: 100, height: 20),
                          ),
                        );
                      }
                      final levels = (result.data!['levels'] as List)
                          .map((e) => Level.fromJson(e))
                          .toList();
                      return InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: acroLevel,
                            isExpanded: true,
                            onChanged: (newVal) {
                              final id = levels
                                  .firstWhere((l) => l.name == newVal)
                                  .id!;
                              setState(() {
                                acroLevel = newVal;
                                acroLevelId = id;
                              });
                            },
                            items: levels
                                .map((l) => l.name!)
                                .map((name) => DropdownMenuItem(
                                      value: name,
                                      child: Text(name),
                                    ))
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  // — Save button —
                  ModernButton(
                    text: _isUploadingImage ? "Uploading Image..." : "Save",
                    onPressed: (isSaving || _isUploadingImage)
                        ? () {}
                        : () async {
                            final ok = await _onSave(user);
                            if (ok) context.pop();
                          },
                    isLoading: isSaving || _isUploadingImage,
                    isFilled: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChooseGenderInput extends StatelessWidget {
  const ChooseGenderInput(
      {super.key, required this.currentGender, required this.setCurrentGender});

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
            CustomErrorHandler.captureException(result.exception.toString());
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
      {super.key, required this.currentLevel, required this.setCurrentLevel});

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
            CustomErrorHandler.captureException(result.exception.toString());
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
