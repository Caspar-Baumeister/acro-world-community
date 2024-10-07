import 'package:acroworld/routing/routes/base_route.dart';

abstract class BaseRouteGuard {
  bool onNavigation(BaseRoute route);
}
