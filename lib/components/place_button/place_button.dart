import 'package:acroworld/provider/place_provider.dart';
import 'package:acroworld/screens/location_search_screen/place_search_screen.dart';
import 'package:acroworld/components/standard_icon_button/standard_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceButton extends StatelessWidget {
  const PlaceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlaceProvider placeProvider = Provider.of<PlaceProvider>(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: StandardIconButton(
            text: placeProvider.place?.description ?? 'No location set',
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
        ),
        placeProvider.place != null
            ? Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                    onTap: () {
                      placeProvider.updatePlace(null);
                    },
                    child: const Icon(Icons.close)),
              )
            : Container()
      ],
    );
  }
}
