import 'package:acroworld/routing/routes/base_route_guards.dart';
import 'package:acroworld/routing/routes/route_transitions.dart';
import 'package:flutter/material.dart';

class BaseRoute<T> extends PageRouteBuilder<T> {
  Widget page;

  List<BaseRouteGuard>? guards = [];
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
      transitionsBuilderFunction;

  BaseRoute(this.page,
      //this.name,
      { //this.path,
      this.guards,
      this.transitionsBuilderFunction = Transitions.noTransition})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) {
              return page;
            }, //PageFactory(page);},

            transitionsBuilder: transitionsBuilderFunction);
}
