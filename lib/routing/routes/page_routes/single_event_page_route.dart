import 'package:acroworld/data/models/class_event.dart';
import 'package:acroworld/data/models/class_model.dart';
import 'package:acroworld/presentation/screens/single_class_page/single_class_page.dart';
import 'package:acroworld/routing/routes/base_route.dart';

class SingleEventPageRoute extends BaseRoute<void> {
  SingleEventPageRoute({required ClassModel classModel, ClassEvent? classEvent})
      : super(
          SingleClassPage(clas: classModel, classEvent: classEvent),
          guards: [],
        );
}
