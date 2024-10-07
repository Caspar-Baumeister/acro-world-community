import 'package:acroworld/presentation/screens/single_class_page/single_class_query_wrapper.dart';
import 'package:acroworld/routing/routes/base_route.dart';

class SingleEventIdWrapperPageRoute extends BaseRoute<void> {
  SingleEventIdWrapperPageRoute(
      {String? urlSlug, String? classId, String? classEventId})
      : super(
          SingleEventQueryWrapper(
              urlSlug: urlSlug, classId: classId, classEventId: classEventId),
          guards: [],
        );
}
