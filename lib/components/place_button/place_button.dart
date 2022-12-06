import 'package:acroworld/models/places/place.dart';
import 'package:acroworld/screens/location_search_screen/place_search_screen.dart';
import 'package:acroworld/components/standard_icon_button/standard_icon_button.dart';
import 'package:flutter/material.dart';

class PlaceButton extends StatefulWidget {
  const PlaceButton({Key? key, required this.onPlaceSet, this.initialPlace})
      : super(key: key);

  final Function(Place? place) onPlaceSet;
  final Place? initialPlace;

  @override
  State<PlaceButton> createState() => _PlaceButtonState();
}

class _PlaceButtonState extends State<PlaceButton> {
  late Place? place;

  @override
  void initState() {
    super.initState();
    place = widget.initialPlace;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StandardIconButton(
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
        ),
        place != null
            ? Positioned(
                right: 15,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          place = null;
                        },
                      );
                      widget.onPlaceSet(null);
                    },
                    child: const Icon(Icons.close)),
              )
            : Container()
      ],
    );
  }
}
