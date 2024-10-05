import 'dart:typed_data';

import 'package:acroworld/utils/helper_functions/messanges/toasts.dart';
import 'package:image_picker/image_picker.dart';

Future<void> customPickImage(
    ImagePicker picker, Function(Uint8List) onImageSelected) async {
  try {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      onImageSelected(imageBytes);
    }
  } catch (e) {
    showErrorToast('Error picking profile image: $e');
  }
}
