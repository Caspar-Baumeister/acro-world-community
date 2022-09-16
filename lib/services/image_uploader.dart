// import 'package:image_picker/image_picker.dart';

// class TeacherImageUploader {
//   final double _maxWidth = 1024;
//   final double _maxHeight = 1024;
//   final int _imageQuality = 60; // Percent
//   final ImagePicker _picker = ImagePicker();

//   void selectAndUploadProfileImage() async {
//     try {
//       print('image');
//       XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//       );

//       print(image);
//     } catch (e) {
//       print(e);
//     } finally {
//       print('finally');
//     }
//   }

//   void selectAndUploadImages() async {
//     List<XFile>? images = await _picker.pickMultiImage(
//       maxWidth: _maxWidth,
//       maxHeight: _maxHeight,
//       imageQuality: _imageQuality,
//     );
//     print(images);
//   }
// }
