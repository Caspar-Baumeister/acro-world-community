import 'dart:typed_data';

import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/presentation/components/images/event_image_picker_component.dart';
import 'package:acroworld/presentation/components/input/custom_option_input_component.dart';
import 'package:acroworld/presentation/components/input/input_field_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/custom_location_input_component.dart';
import 'package:acroworld/presentation/screens/creator_mode_screens/create_and_edit_event/components/display_error_message_component.dart';
import 'package:acroworld/provider/event_creation_and_editing_provider.dart';
import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/split_camel_case_to_lower.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class GeneralEventStep extends StatefulWidget {
  const GeneralEventStep({super.key, required this.onFinished});

  final Function onFinished;

  @override
  State<GeneralEventStep> createState() => _GeneralEventStepState();
}

class _GeneralEventStepState extends State<GeneralEventStep> {
  late TextEditingController _titleController;
  late TextEditingController _slugController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationNameController;
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    EventCreationAndEditingProvider provider =
        Provider.of<EventCreationAndEditingProvider>(context, listen: false);
    _locationNameController =
        TextEditingController(text: provider.locationName);
    _titleController = TextEditingController(text: provider.title);
    _slugController = TextEditingController(text: provider.slug);
    _descriptionController = TextEditingController(text: provider.description);

    // add listener to update provider
    _descriptionController.addListener(() {
      provider.setDescription(_descriptionController.text);
    });

    _locationNameController.addListener(() {
      provider.setLocationName(_locationNameController.text);
    });
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
    EventCreationAndEditingProvider provider =
        Provider.of<EventCreationAndEditingProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPaddings.medium,
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
                    EventImahePickerComponent(
                      currentImage: provider.eventImage,
                      existingImageUrl: provider.existingImageUrl,
                      onImageSelected: (Uint8List image) {
                        provider.setEventImage(image);
                      },
                    ),
                    const SizedBox(height: AppPaddings.medium),
                    InputFieldComponent(
                      controller: _titleController,
                      onEditingComplete: () {
                        provider.setTitle(_titleController.text);
                        if (_slugController.text.isEmpty) {
                          String slug = _titleController.text
                              .toLowerCase()
                              .replaceAll(' ', '-')
                              .replaceAll(RegExp(r'[^a-z0-9-]'), '');
                          _slugController.text = slug;
                          provider.setSlug(slug);
                          provider.checkSlugAvailability();
                        }
                      },
                      labelText: 'Event Title',
                      validator: (p0) =>
                          p0!.isEmpty ? 'Name cannot be empty' : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppPaddings.medium),
                    InputFieldComponent(
                      controller: _slugController,
                      labelText: 'URL Slug',
                      onEditingComplete: () {
                        provider.setSlug(_slugController.text);
                        provider.checkSlugAvailability();
                      },
                      footnoteText: provider.isSlugValid == false
                          ? "Please use only lowercase letters, numbers, and hyphens"
                          : (provider.isSlugAvailable == false
                              ? "This slug is already taken"
                              : 'This will be used in the URL of your event page'),
                      isFootnoteError: provider.isSlugAvailable == false ||
                          provider.isSlugValid == false,
                      textInputAction: TextInputAction.next,
                      suffixIcon: provider.isSlugAvailable == null &&
                              provider.isSlugValid == null
                          ? null
                          : (provider.isSlugAvailable == false ||
                                  provider.isSlugValid == false)
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
                      isFootnoteError: false,
                      footnoteText:
                          "Tip: You can use inline HTML to format your description",
                    ),
                    const SizedBox(height: AppPaddings.medium),
                    InputFieldComponent(
                      controller: _locationNameController,
                      labelText: 'Location name',
                      isFootnoteError: false,
                      footnoteText:
                          "This can be the name of the studio or park and will be displayed in the app instead of the full adress",
                    ),
                    const SizedBox(height: AppPaddings.medium),
                    CustomLocationInputComponent(
                      currentLocation: provider.location,
                      currentLoactionDescription: provider.locationDescription,
                      onLocationSelected:
                          (LatLng location, String? locationDescription) {
                        provider.setLocation(location);
                        provider
                            .setLocationDescription(locationDescription ?? '');
                      },
                    ),
                    const SizedBox(height: AppPaddings.medium),
                    CustomQueryOptionInputComponent(
                      hintText: 'What kind of event is it?',
                      currentOption: provider.eventType,
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
                          provider.setEventType(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppPaddings.large),
          StandardButton(onPressed: _onNext, text: 'Next'),
          const SizedBox(height: AppPaddings.small),
          DisplayErrorMessageComponent(errorMessage: _errorMessage),
        ],
      ),
    );
  }

  void _onNext() {
    setState(() {
      _errorMessage = null;
    });
    EventCreationAndEditingProvider provider =
        Provider.of<EventCreationAndEditingProvider>(context, listen: false);
    if (provider.eventImage == null && provider.existingImageUrl == null) {
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
    } else if (provider.location == null) {
      setState(() {
        _errorMessage = 'Please select a location for your event';
      });
    } else if (provider.locationName == null) {
      setState(() {
        _errorMessage = 'Please enter a location name for your event';
      });
    } else if (provider.isSlugValid == false) {
      setState(() {
        _errorMessage =
            'Please use only lowercase letters, numbers, and hyphens';
      });
    } else if (provider.isSlugAvailable == false) {
      setState(() {
        _errorMessage = 'This slug is already taken';
      });
    } else if (provider.eventType == null) {
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

    provider.setTitle(_titleController.text);
    provider.setSlug(_slugController.text);
    provider.setDescription(_descriptionController.text);
    provider.setLocationName(_locationNameController.text);
    widget.onFinished();
  }
}
