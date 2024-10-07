import 'package:acroworld/presentation/screens/teacher_profile/single_partner_slug_wrapper.dart';
import 'package:acroworld/routing/routes/base_route.dart';

class PartnerSlugPageRoute extends BaseRoute<void> {
  PartnerSlugPageRoute({required String urlSlug})
      : super(
          PartnerSlugWrapper(teacherSlug: urlSlug),
          guards: [],
        );
}
