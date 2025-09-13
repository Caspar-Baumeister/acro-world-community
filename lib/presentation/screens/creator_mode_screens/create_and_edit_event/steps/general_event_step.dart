import 'dart:typed_data';

import 'package:acroworld/presentation/components/buttons/modern_button.dart';
import 'package:acroworld/presentation/components/images/event_image_picker_component.dart';
import 'package:acroworld/presentation/components/input/custom_option_input_component.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/custom_location_input_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/display_error_message_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/country_dropdown.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/custom_setting_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/main_pages/creator_profile_page/components/region_dropdown.dart';
import 'package:acroworld/presentation/shells/responsive.dart';
import 'package:acroworld/provider/riverpod_provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/routing/routes/page_routes/main_page_routes/all_page_routes.dart';
import 'package:acroworld/theme/app_dimensions.dart';
import 'package:acroworld/utils/helper_functions/split_camel_case_to_lower.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    _descriptionController = TextEditingController(text: eventState.description);

    // add listener to update provider
    _descriptionController.addListener(() {
      ref.read(eventCreationAndEditingProvider.notifier).setDescription(_descriptionController.text);
    });

    _locationNameController.addListener(() {
      ref.read(eventCreationAndEditingProvider.notifier).setLocationName(_locationNameController.text);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update controllers when provider state changes (e.g., when template is loaded)
    final eventState = ref.watch(eventCreationAndEditingProvider);
    
    // Only update if the values have actually changed to avoid cursor jumping
    if (_titleController.text != eventState.title) {
      _titleController.text = eventState.title;
    }
    if (_slugController.text != eventState.slug) {
      _slugController.text = eventState.slug;
    }
    if (_descriptionController.text != eventState.description) {
      _descriptionController.text = eventState.description;
    }
    if (_locationNameController.text != (eventState.locationName ?? '')) {
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
                        width: 300,
                        height: 300,
                        child: EventImahePickerComponent(
                          currentImage: eventState.eventImage,
                          existingImageUrl: eventState.existingImageUrl,
                          onImageSelected: (Uint8List image) {
                            ref.read(eventCreationAndEditingProvider.notifier).setEventImage(image);
                          },
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingMedium),
                      InputFieldComponent(
                        controller: _titleController,
                        onEditingComplete: () {
                          ref.read(eventCreationAndEditingProvider.notifier).setTitle(_titleController.text);
                          if (_slugController.text.isEmpty) {
                            String slug = _titleController.text
                                .toLowerCase()
                                .replaceAll(' ', '-')
                                .replaceAll(RegExp(r'[^a-z0-9-]'), '');
                            _slugController.text = slug;
                            ref.read(eventCreationAndEditingProvider.notifier).setSlug(slug);
                            ref.read(eventCreationAndEditingProvider.notifier).checkSlugAvailability();
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
                        labelText: 'URL Slug',
                        onEditingComplete: () {
                          ref.read(eventCreationAndEditingProvider.notifier).setSlug(_slugController.text);
                          ref.read(eventCreationAndEditingProvider.notifier).checkSlugAvailability();
                        },
                        footnoteText: eventState.isSlugValid == false
                            ? "Please use only lowercase letters, numbers, and hyphens"
                            : (eventState.isSlugAvailable == false
                                ? "This slug is already taken"
                                : 'This will be used in the URL of your event page'),
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
                      ModernButton(
                        text: "Edit event description",
                        onPressed: () {
                          Navigator.push(
                            context,
                            EditDescriptionPageRoute(
                              initialText: eventState.description,
                              onTextUpdated: (String text) {
                                _descriptionController.text = text;
                              },
                            ),
                          );
                        },
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
                          ref.read(eventCreationAndEditingProvider.notifier).setLocation(location);
                          ref.read(eventCreationAndEditingProvider.notifier).setLocationDescription(
                              locationDescription ?? '');
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacingMedium),
                      // choose from country
                      // choose from country
                      CountryPicker(
                        // now pass the ISO code, not the name:
                        selectedCountryCode: eventState.countryCode,
                        onCountrySelected: (String? code, String? name) {
                          // code: e.g. "US", name: e.g. "United States"
                          ref.read(eventCreationAndEditingProvider.notifier).setCountryCode(code);
                          ref.read(eventCreationAndEditingProvider.notifier).setCountry(name);
                          // clear out any previously selected region:
                          ref.read(eventCreationAndEditingProvider.notifier).setRegion(null);
                        },
                      ),

                      // only show regions once we have a valid countryCode
                      if (eventState.countryCode != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: AppDimensions.spacingMedium),
                          child: RegionPicker(
                            countryCode: eventState.countryCode!,
                            selectedRegion: eventState.region,
                            onRegionSelected: (String? region) {
                              ref.read(eventCreationAndEditingProvider.notifier).setRegion(region);
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
                            ref.read(eventCreationAndEditingProvider.notifier).setEventType(value);
                          }
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacingMedium),
                      CustomSettingComponent(
                        title: 'Questions',
                        content: "${eventState.questions.length} questions",
                        onPressed: () {
                          Navigator.of(context).push(QuestionPageRoute());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    constraints: Responsive.isDesktop(context)
                        ? const BoxConstraints(maxWidth: 200)
                        : null,
                    child: ModernButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: "Cancel",
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                  ),
                const SizedBox(width: AppDimensions.spacingMedium),
                Container(
                  constraints: Responsive.isDesktop(context)
                      ? const BoxConstraints(maxWidth: 400)
                      : null,
                  child: ModernButton(
                    onPressed: _onNext,
                    text: "Next",
                    isFilled: true,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingSmall),
            DisplayErrorMessageComponent(errorMessage: _errorMessage),
          ],
        ),
      ),
    );
  }

  void _onNext() {
    setState(() {
      _errorMessage = null;
    });
    final eventState = ref.read(eventCreationAndEditingProvider);
    if (eventState.eventImage == null && eventState.existingImageUrl == null) {
      setState(() {
        _errorMessage = 'Please select an image for your event';
      });
    } else if (_titleController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a title for your event';
      });
    } else if (_slugController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a slug for your event';
      });
    } else if (_descriptionController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a description for your event';
      });
    } else if (eventState.location == null) {
      setState(() {
        _errorMessage = 'Please select a location for your event';
      });
    } else if (eventState.locationName == null) {
      setState(() {
        _errorMessage = 'Please enter a location name for your event';
      });
    } else if (eventState.isSlugValid == false) {
      setState(() {
        _errorMessage =
            'Please use only lowercase letters, numbers, and hyphens';
      });
    } else if (eventState.isSlugAvailable == false) {
      setState(() {
        _errorMessage = 'This slug is already taken';
      });
    } else if (eventState.eventType == null) {
      setState(() {
        _errorMessage = 'Please select an event type';
      });
    }

    if (_errorMessage != null) {
      _scrollController.animateTo(
        // max scroll extent
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    ref.read(eventCreationAndEditingProvider.notifier).setTitle(_titleController.text);
    ref.read(eventCreationAndEditingProvider.notifier).setSlug(_slugController.text);
    ref.read(eventCreationAndEditingProvider.notifier).setDescription(_descriptionController.text);
    ref.read(eventCreationAndEditingProvider.notifier).setLocationName(_locationNameController.text);
    widget.onFinished();
  }
}
