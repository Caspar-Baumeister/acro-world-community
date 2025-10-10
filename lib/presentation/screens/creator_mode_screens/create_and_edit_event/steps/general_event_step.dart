import 'dart:async';
import 'dart:typed_data';

import 'package:acroworld/presentation/components/images/event_image_picker_component.dart';
import 'package:acroworld/presentation/components/input/custom_option_input_component.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/custom_location_input_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/display_error_message_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/country_dropdown.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/region_dropdown.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/riverpod_provider/event_basic_info_provider.dart';
import 'package:acroworld/provider/riverpod_provider/event_location_provider.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/split_camel_case_to_lower.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:latlong2/latlong.dart';

class GeneralEventStep extends ConsumerStatefulWidget {
  const GeneralEventStep({super.key, required this.onFinished});

  final Function onFinished;

  @override
  ConsumerState<GeneralEventStep> createState() => _GeneralEventStepState();
}

class _GeneralEventStepState extends ConsumerState<GeneralEventStep> {
  late TextEditingController _titleController;
  late TextEditingController _slugController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationNameController;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();
  Timer? _slugDebounceTimer;

  @override
  void initState() {
    super.initState();
    final basicInfo = ref.read(eventBasicInfoProvider);
    final location = ref.read(eventLocationProvider);
    _locationNameController =
        TextEditingController(text: location.locationName);
    _titleController = TextEditingController(text: basicInfo.title);
    _slugController = TextEditingController(text: basicInfo.slug);
    _descriptionController = TextEditingController(text: basicInfo.description);

    // add listener to update provider
    _descriptionController.addListener(() {
      ref
          .read(eventBasicInfoProvider.notifier)
          .setDescription(_descriptionController.text);
    });

    _locationNameController.addListener(() {
      ref
          .read(eventLocationProvider.notifier)
          .setLocationName(_locationNameController.text);
    });

    _titleController.addListener(() {
      ref.read(eventBasicInfoProvider.notifier).setTitle(_titleController.text);
      // Auto-generate slug from title if slug is empty
      if (_slugController.text.isEmpty) {
        String slug = _titleController.text
            .toLowerCase()
            .replaceAll(' ', '-')
            .replaceAll(RegExp(r'[^a-z0-9-]'), '');
        _slugController.text = slug;
        ref.read(eventBasicInfoProvider.notifier).setSlug(slug);
        ref.read(eventBasicInfoProvider.notifier).checkSlugAvailability();
      }
    });

    _slugController.addListener(() {
      ref.read(eventBasicInfoProvider.notifier).setSlug(_slugController.text);

      // Cancel previous timer
      _slugDebounceTimer?.cancel();

      // Check slug availability in real-time with debouncing
      if (_slugController.text.isNotEmpty) {
        _slugDebounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(eventBasicInfoProvider.notifier).checkSlugAvailability();
        });
      } else {
        // Clear validation state when field is empty
        ref.read(eventBasicInfoProvider.notifier).clearSlugValidation();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update controllers when provider state changes (e.g., when template is loaded)
    final basicInfo = ref.watch(eventBasicInfoProvider);
    final location = ref.watch(eventLocationProvider);

    // Debug: Print form state
    print('🔍 FORM DEBUG - didChangeDependencies called');
    print('🔍 FORM DEBUG - Provider title: "${basicInfo.title}"');
    print('🔍 FORM DEBUG - Provider slug: "${basicInfo.slug}"');
    print('🔍 FORM DEBUG - Provider description: "${basicInfo.description}"');
    print('🔍 FORM DEBUG - Provider locationName: "${location.locationName}"');
    print('🔍 FORM DEBUG - Controller title: "${_titleController.text}"');
    print('🔍 FORM DEBUG - Controller slug: "${_slugController.text}"');
    print(
        '🔍 FORM DEBUG - Controller description: "${_descriptionController.text}"');
    print(
        '🔍 FORM DEBUG - Controller locationName: "${_locationNameController.text}"');

    // Update controllers when provider data is available and different from current values
    if (basicInfo.title.isNotEmpty &&
        _titleController.text != basicInfo.title) {
      print(
          '🔍 FORM DEBUG - Updating title controller from "${_titleController.text}" to "${basicInfo.title}"');
      _titleController.text = basicInfo.title;
    }
    if (basicInfo.slug.isNotEmpty && _slugController.text != basicInfo.slug) {
      print(
          '🔍 FORM DEBUG - Updating slug controller from "${_slugController.text}" to "${basicInfo.slug}"');
      _slugController.text = basicInfo.slug;
    }
    if (basicInfo.description.isNotEmpty &&
        _descriptionController.text != basicInfo.description) {
      print(
          '🔍 FORM DEBUG - Updating description controller from "${_descriptionController.text}" to "${basicInfo.description}"');
      _descriptionController.text = basicInfo.description;
    }
    if (location.locationName != null &&
        location.locationName!.isNotEmpty &&
        _locationNameController.text != location.locationName) {
      print(
          '🔍 FORM DEBUG - Updating locationName controller from "${_locationNameController.text}" to "${location.locationName}"');
      _locationNameController.text = location.locationName!;
    }
  }

  @override
  void dispose() {
    _slugDebounceTimer?.cancel();
    _titleController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _locationNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final basicInfo = ref.watch(eventBasicInfoProvider);
    final location = ref.watch(eventLocationProvider);
    return Container(
      constraints: Responsive.isDesktop(context)
          ? const BoxConstraints(maxWidth: 800)
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMedium,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 250,
                        height: 250,
                        child: EventImahePickerComponent(
                          currentImage: basicInfo.eventImage,
                          existingImageUrl: basicInfo.existingImageUrl,
                          onImageSelected: (Uint8List image) {
                            ref
                                .read(eventBasicInfoProvider.notifier)
                                .setEventImage(image);
                          },
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingMedium),
                      InputFieldComponent(
                        controller: _titleController,
                        labelText: 'Event Title',
                        validator: (p0) =>
                            p0!.isEmpty ? 'Name cannot be empty' : null,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppDimensions.spacingMedium),
                      InputFieldComponent(
                        controller: _slugController,
                        labelText: 'Unique Identifier',
                        footnoteText: basicInfo.isSlugValid == false
                            ? "Please use only lowercase letters, numbers, and hyphens"
                            : (basicInfo.isSlugAvailable == false
                                ? "This identifier is already taken"
                                : 'A unique identifier for your event (e.g., "my-acro-workshop-2024"). This will be used in the event URL and must be unique.'),
                        isFootnoteError: basicInfo.isSlugAvailable == false ||
                            basicInfo.isSlugValid == false,
                        textInputAction: TextInputAction.next,
                        suffixIcon: basicInfo.isSlugAvailable == null &&
                                basicInfo.isSlugValid == null
                            ? null
                            : (basicInfo.isSlugAvailable == false ||
                                    basicInfo.isSlugValid == false)
                                ? Icon(Icons.error,
                                    color: Theme.of(context).colorScheme.error)
                                : Icon(Icons.check_circle,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: AppDimensions.spacingMedium),
                      InputFieldComponent(
                        controller: _locationNameController,
                        labelText: 'Location name',
                        isFootnoteError: false,
                        footnoteText:
                            "This can be the name of the studio or park and will be displayed in the app instead of the full adress",
                      ),
                      const SizedBox(height: AppDimensions.spacingMedium),
                      CustomLocationInputComponent(
                        currentLocation: location.location,
                        currentLoactionDescription:
                            location.locationDescription,
                        onLocationSelected:
                            (LatLng location, String? locationDescription) {
                          ref
                              .read(eventLocationProvider.notifier)
                              .setLocation(location);
                          ref
                              .read(eventLocationProvider.notifier)
                              .setLocationDescription(
                                  locationDescription ?? '');
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacingMedium),
                      // choose from country
                      // choose from country
                      Builder(
                        builder: (context) {
                          print(
                              '🔍 UI DEBUG - CountryPicker selectedCountryCode: "${location.countryCode}"');
                          return CountryPicker(
                            key: ValueKey(
                                'country_${location.countryCode}'), // Force rebuild when country changes
                            // now pass the ISO code, not the name:
                            selectedCountryCode: location.countryCode,
                            onCountrySelected: (String? code, String? name) {
                              // code: e.g. "US", name: e.g. "United States"
                              if (code != null) {
                                ref
                                    .read(eventLocationProvider.notifier)
                                    .setCountryCode(code);
                              }
                              ref
                                  .read(eventLocationProvider.notifier)
                                  .setCountry(name);
                              // clear out any previously selected region:
                              ref
                                  .read(eventLocationProvider.notifier)
                                  .setRegion('');
                            },
                          );
                        },
                      ),

                      // only show regions once we have a valid countryCode
                      if (location.countryCode != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: AppDimensions.spacingMedium),
                          child: Builder(
                            builder: (context) {
                              print(
                                  '🔍 UI DEBUG - RegionPicker countryCode: "${location.countryCode}", selectedRegion: "${location.region}"');
                              return RegionPicker(
                                key: ValueKey(
                                    'region_${location.countryCode}_${location.region}'), // Force rebuild when region changes
                                countryCode: location.countryCode!,
                                selectedRegion: location.region,
                                onRegionSelected: (String? region) {
                                  if (region != null) {
                                    ref
                                        .read(eventLocationProvider.notifier)
                                        .setRegion(region);
                                  }
                                },
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: AppDimensions.spacingMedium),
                      CustomQueryOptionInputComponent(
                        hintText: 'What kind of event is it?',
                        currentOption: basicInfo.eventType,
                        identifier: 'event_type',
                        valueIdentifier: "value",
                        query: QueryOptions(
                          document: gql("""
                          query {
                            event_type {
                              value
                            }
                          }
                          """),
                        ),
                        beatifyValueFunction: splitCamelCaseToLower,
                        setOption: (String? value) {
                          if (value != null) {
                            ref
                                .read(eventBasicInfoProvider.notifier)
                                .setEventType(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            DisplayErrorMessageComponent(errorMessage: _errorMessage),
          ],
        ),
      ),
    );
  }
}
