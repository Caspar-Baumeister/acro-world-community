import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/screens/location_search_screen/place_search_screen.dart';
import 'package:acroworld/widgets/standard_icon_button/standard_icon_button.dart';
import 'package:flutter/material.dart';

class PlaceButton extends StatefulWidget {
  const PlaceButton({Key? key, required this.onPlaceSet, this.initialPlace})
      : super(key: key);

  final Function(Place place) onPlaceSet;
  final Place? initialPlace;

  @override
  State<PlaceButton> createState() => _PlaceButtonState();
}

class _PlaceButtonState extends State<PlaceButton> {
  Place? place;

  @override
  void initState() {
    place = widget.initialPlace;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StandardIconButton(
      text: place?.description ?? 'No location set',
      icon: Icons.location_on,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceSearchScreen(
              onPlaceSet: (_place) {
                setState(
                  () {
                    place = _place;
                  },
                );
                widget.onPlaceSet(_place);
              },
            ),
          ),
        );
      },
    );
  }
}
