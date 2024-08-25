import 'dart:typed_data';

import 'package:acroworld/utils/colors.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdditionalImagePickerComponent extends StatefulWidget {
  final List<Uint8List> additionalImages;
  final Function(List<Uint8List>) onImagesSelected;

  const AdditionalImagePickerComponent({
    super.key,
    required this.additionalImages,
    required this.onImagesSelected,
  });

  @override
  AdditionalImagePickerComponentState createState() =>
      AdditionalImagePickerComponentState();
}

class AdditionalImagePickerComponentState
    extends State<AdditionalImagePickerComponent> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final List<Uint8List> images = await Future.wait(
          pickedFiles.map((file) => file.readAsBytes()),
        );
        widget.onImagesSelected(images);
      }
    } catch (e) {
      showErrorToast('Error picking additional images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPaddings.small).copyWith(top: 0),
      decoration: BoxDecoration(
          border: Border.all(
            color: CustomColors.inactiveBorderColor,
            width: 1.0,
          ),
          borderRadius: AppBorders.defaultRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Additional Images'),
              IconButton(onPressed: _pickImages, icon: const Icon(Icons.add)),
            ],
          ),
          widget.additionalImages.isEmpty
              ? Center(
                  child: Text('No additional images selected',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: CustomColors.primaryTextColor,
                          )),
                )
              : SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.additionalImages.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.memory(widget.additionalImages[index]),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
