import 'package:acroworld/presentation/components/buttons/standard_icon_button.dart';
import 'package:acroworld/presentation/screens/user_mode_screens/location_search_screen/place_search_screen.dart';
import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
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
      child: StandardIconButton(
        text: calendarProvider.locationSingelton.place.description,
        icon: Icons.location_on,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PlaceSearchScreen(),
            ),
          );
        },
      ),
    );
  }
}
