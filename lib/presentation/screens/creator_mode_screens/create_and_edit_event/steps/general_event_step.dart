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
  late TextEditingController _descriptionController;
  late TextEditingController _locationNameController;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();
  Timer? _titleDebounceTimer;

  void _handleTitleEditingComplete() {
    FocusScope.of(context).nextFocus();
  }

  void _onTitleChanged() {
    _titleDebounceTimer?.cancel();
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      _titleDebounceTimer = Timer(const Duration(milliseconds: 500), () {
        unawaited(ref
            .read(eventBasicInfoProvider.notifier)
            .generateSlugFromTitle(_titleController.text));
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final basicInfo = ref.read(eventBasicInfoProvider);
    final location = ref.read(eventLocationProvider);

    _locationNameController =
        TextEditingController(text: location.locationName);
    _titleController = TextEditingController(text: basicInfo.title);
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
      _onTitleChanged();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Update controllers when provider state changes (e.g., when template is loaded)
    final basicInfo = ref.watch(eventBasicInfoProvider);
    final location = ref.watch(eventLocationProvider);

    // Update controllers when provider data is available and different from current values
    if (basicInfo.title.isNotEmpty &&
        _titleController.text != basicInfo.title) {
      _titleController.text = basicInfo.title;
    }

    if (basicInfo.description.isNotEmpty &&
        _descriptionController.text != basicInfo.description) {
      _descriptionController.text = basicInfo.description;
    }

    if (location.locationName != null &&
        location.locationName!.isNotEmpty &&
        _locationNameController.text != location.locationName) {
      _locationNameController.text = location.locationName!;
    }
  }

  @override
  void dispose() {
    _titleDebounceTimer?.cancel();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final basicInfo = ref.watch(eventBasicInfoProvider);
    final location = ref.watch(eventLocationProvider);

    // Listen to provider changes and update controllers
    ref.listen<EventBasicInfoState>(eventBasicInfoProvider, (previous, next) {
      if (next.title.isNotEmpty && _titleController.text != next.title) {
        _titleController.text = next.title;
      }
      if (next.description.isNotEmpty &&
          _descriptionController.text != next.description) {
        _descriptionController.text = next.description;
      }
    });

    ref.listen<EventLocationState>(eventLocationProvider, (previous, next) {
      if (next.locationName != null &&
          next.locationName!.isNotEmpty &&
          _locationNameController.text != next.locationName) {
        _locationNameController.text = next.locationName!;
      }
    });
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
                        onEditingComplete: _handleTitleEditingComplete,
                        textInputAction: TextInputAction.next,
                      ),
                      if (basicInfo.slug.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppDimensions.spacingSmall,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.link,
                                size: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'www.acroworld.net/event/${basicInfo.slug}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                ),
                              ),
                            ],
                          ),
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
                                // Clear out any previously selected region when country changes
                                ref
                                    .read(eventLocationProvider.notifier)
                                    .setRegion(null);
                              }
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
