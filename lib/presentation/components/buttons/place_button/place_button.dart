import 'package:acroworld/presentation/components/buttons/standart_icon_button.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PlaceButton extends StatelessWidget {
  const PlaceButton({super.key, this.rightPadding = true});

  final bool rightPadding;

  @override
  Widget build(BuildContext context) {
    PlaceProvider calendarProvider = Provider.of<PlaceProvider>(context);
    return Container(
      height: INPUTFIELD_HEIGHT,
      padding: const EdgeInsets.symmetric(horizontal: 10.0)
          .copyWith(right: rightPadding ? 10 : 0),
      child: StandartIconButton(
        text: calendarProvider.locationSingelton.place.description,
        icon: Icons.location_on,
        onPressed: () {
          context.pushNamed(
            placeSearchRoute,
          );
        },
      ),
    );
  }
}
