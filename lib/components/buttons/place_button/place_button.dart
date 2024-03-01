import 'package:acroworld/components/buttons/standard_icon_button.dart';
import 'package:acroworld/provider/calendar_provider.dart';
import 'package:acroworld/screens/location_search_screen/place_search_screen.dart';
import 'package:acroworld/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceButton extends StatelessWidget {
  const PlaceButton({super.key, this.rightPadding = true});

  final bool rightPadding;

  @override
  Widget build(BuildContext context) {
    CalendarProvider calendarProvider = Provider.of<CalendarProvider>(context);
    return Container(
      height: INPUTFIELD_HEIGHT,
      padding: const EdgeInsets.symmetric(horizontal: 10.0)
          .copyWith(right: rightPadding ? 10 : 0),
      child: StandardIconButton(
        text: calendarProvider.place.description,
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
