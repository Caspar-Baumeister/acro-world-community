import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/utils/helper_functions/formater.dart';
import 'package:share_plus/share_plus.dart';

/// Helper function to share a class event via a dynamic deep link.
void shareEvent(ClassEvent? classEvent, ClassModel clas) {
  // Build base deep link URL
  String deeplinkUrl = "https://acroworld.net/event/${clas.urlSlug}";
  if (classEvent?.id != null) {
    deeplinkUrl += "?event=${classEvent!.id!}";
  }

  // Compose share content
  String content = '''
Hi, I just found this event on AcroWorld:

${clas.name}
${formatInstructors(clas.classTeachers)}
${classEvent != null ? getDateStringMonthDay(DateTime.parse(classEvent.startDate!)) : ''}
At: ${clas.locationName}
''';

  if (clas.urlSlug != null) {
    content += "\n\nFind more info and book here: $deeplinkUrl";
  }

  // Trigger the native share dialog
  Share.share(content);
}
