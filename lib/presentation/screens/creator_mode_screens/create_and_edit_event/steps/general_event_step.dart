import 'dart:typed_data';

import 'package:acroworld/presentation/components/images/event_image_picker_component.dart';
import 'package:acroworld/presentation/components/input/custom_option_input_component.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/custom_location_input_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/display_error_message_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/country_dropdown.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/region_dropdown.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
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

  @override
  void initState() {
    super.initState();
    final eventState = ref.read(eventCreationAndEditingProvider);
    _locationNameController =
        TextEditingController(text: eventState.locationName);
    _titleController = TextEditingController(text: eventState.title);
    _slugController = TextEditingController(text: eventState.slug);
    _descriptionController =
        TextEditingController(text: eventState.description);

    // add listener to update provider
    _descriptionController.addListener(() {
      ref
          .read(eventCreationAndEditingProvider.notifier)
          .setDescription(_descriptionController.text);
    });

    _locationNameController.addListener(() {
      ref
          .read(eventCreationAndEditingProvider.notifier)
          .setLocationName(_locationNameController.text);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update controllers when provider state changes (e.g., when template is loaded)
    final eventState = ref.watch(eventCreationAndEditingProvider);

    // Debug: Print form state
    print('🔍 FORM DEBUG - didChangeDependencies called');
    print('🔍 FORM DEBUG - Provider title: "${eventState.title}"');
    print('🔍 FORM DEBUG - Provider description: "${eventState.description}"');
    print(
        '🔍 FORM DEBUG - Provider locationName: "${eventState.locationName}"');
    print(
        '🔍 FORM DEBUG - Provider existingImageUrl: "${eventState.existingImageUrl}"');
    print('🔍 FORM DEBUG - Provider countryCode: "${eventState.countryCode}"');
    print('🔍 FORM DEBUG - Provider region: "${eventState.region}"');
    print('🔍 FORM DEBUG - Provider location: "${eventState.location}"');
    print('🔍 FORM DEBUG - Controller title: "${_titleController.text}"');
    print(
        '🔍 FORM DEBUG - Controller description: "${_descriptionController.text}"');
    print(
        '🔍 FORM DEBUG - Controller locationName: "${_locationNameController.text}"');

    // Only update if the values have actually changed to avoid cursor jumping
    if (_titleController.text != eventState.title) {
      print(
          '🔍 FORM DEBUG - Updating title controller from "${_titleController.text}" to "${eventState.title}"');
      _titleController.text = eventState.title;
    }
    if (_slugController.text != eventState.slug) {
      print(
          '🔍 FORM DEBUG - Updating slug controller from "${_slugController.text}" to "${eventState.slug}"');
      _slugController.text = eventState.slug;
    }
    if (_descriptionController.text != eventState.description) {
      print(
          '🔍 FORM DEBUG - Updating description controller from "${_descriptionController.text}" to "${eventState.description}"');
      _descriptionController.text = eventState.description;
    }
    if (_locationNameController.text != (eventState.locationName ?? '')) {
      print(
          '🔍 FORM DEBUG - Updating locationName controller from "${_locationNameController.text}" to "${eventState.locationName ?? ''}"');
      _locationNameController.text = eventState.locationName ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _locationNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventCreationAndEditingProvider);
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
                          currentImage: eventState.eventImage,
                          existingImageUrl: eventState.existingImageUrl,
                          onImageSelected: (Uint8List image) {
                            ref
                                .read(eventCreationAndEditingProvider.notifier)
                                .setEventImage(image);
                          },
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingMedium),
                      InputFieldComponent(
                        controller: _titleController,
                        onEditingComplete: () {
                          ref
                              .read(eventCreationAndEditingProvider.notifier)
                              .setTitle(_titleController.text);
                          if (_slugController.text.isEmpty) {
                            String slug = _titleController.text
                                .toLowerCase()
                                .replaceAll(' ', '-')
                                .replaceAll(RegExp(r'[^a-z0-9-]'), '');
                            _slugController.text = slug;
                            ref
                                .read(eventCreationAndEditingProvider.notifier)
                                .setSlug(slug);
                            ref
                                .read(eventCreationAndEditingProvider.notifier)
                                .checkSlugAvailability();
                          }
                        },
                        labelText: 'Event Title',
                        validator: (p0) =>
                            p0!.isEmpty ? 'Name cannot be empty' : null,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: AppDimensions.spacingMedium),
                      InputFieldComponent(
                        controller: _slugController,
                        labelText: 'Unique Identifier',
                        onEditingComplete: () {
                          ref
                              .read(eventCreationAndEditingProvider.notifier)
                              .setSlug(_slugController.text);
                          ref
                              .read(eventCreationAndEditingProvider.notifier)
                              .checkSlugAvailability();
                        },
                        footnoteText: eventState.isSlugValid == false
                            ? "Please use only lowercase letters, numbers, and hyphens"
                            : (eventState.isSlugAvailable == false
                                ? "This identifier is already taken"
                                : 'A unique identifier for your event (e.g., "my-acro-workshop-2024"). This will be used in the event URL and must be unique.'),
                        isFootnoteError: eventState.isSlugAvailable == false ||
                            eventState.isSlugValid == false,
                        textInputAction: TextInputAction.next,
                        suffixIcon: eventState.isSlugAvailable == null &&
                                eventState.isSlugValid == null
                            ? null
                            : (eventState.isSlugAvailable == false ||
                                    eventState.isSlugValid == false)
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
                        currentLocation: eventState.location,
                        currentLoactionDescription:
                            eventState.locationDescription,
                        onLocationSelected:
                            (LatLng location, String? locationDescription) {
                          ref
                              .read(eventCreationAndEditingProvider.notifier)
                              .setLocation(location);
                          ref
                              .read(eventCreationAndEditingProvider.notifier)
                              .setLocationDescription(
                                  locationDescription ?? '');
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacingMedium),
                      // choose from country
                      // choose from country
                      CountryPicker(
                        key: ValueKey('country_${eventState.countryCode}'), // Force rebuild when country changes
                        // now pass the ISO code, not the name:
                        selectedCountryCode: eventState.countryCode,
                        onCountrySelected: (String? code, String? name) {
                          // code: e.g. "US", name: e.g. "United States"
                          ref
                              .read(eventCreationAndEditingProvider.notifier)
                              .setCountryCode(code);
                          ref
                              .read(eventCreationAndEditingProvider.notifier)
                              .setCountry(name);
                          // clear out any previously selected region:
                          ref
                              .read(eventCreationAndEditingProvider.notifier)
                              .setRegion(null);
                        },
                      ),

                      // only show regions once we have a valid countryCode
                      if (eventState.countryCode != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: AppDimensions.spacingMedium),
                          child: RegionPicker(
                            key: ValueKey('region_${eventState.countryCode}_${eventState.region}'), // Force rebuild when region changes
                            countryCode: eventState.countryCode!,
                            selectedRegion: eventState.region,
                            onRegionSelected: (String? region) {
                              ref
                                  .read(
                                      eventCreationAndEditingProvider.notifier)
                                  .setRegion(region);
                            },
                          ),
                        ),

                      const SizedBox(height: AppDimensions.spacingMedium),
                      CustomQueryOptionInputComponent(
                        hintText: 'What kind of event is it?',
                        currentOption: eventState.eventType,
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
                                .read(eventCreationAndEditingProvider.notifier)
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
