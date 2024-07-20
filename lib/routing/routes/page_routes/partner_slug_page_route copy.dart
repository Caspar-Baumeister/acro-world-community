import 'package:acroworld/routing/routes/base_route.dart';
import 'package:acroworld/screens/teacher_profile/single_partner_slug_wrapper.dart';

class PartnerSlugPageRoute extends BaseRoute<void> {
  PartnerSlugPageRoute({required String urlSlug})
      : super(
          PartnerSlugWrapper(teacherSlug: urlSlug),
          guards: [],
        );
}
