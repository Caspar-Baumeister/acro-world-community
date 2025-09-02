import 'package:acroworld/presentation/components/buttons/standart_button.dart';
import 'package:acroworld/provider/riverpod_provider/place_provider.dart';
import 'package:acroworld/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceButton extends ConsumerWidget {
  const PlaceButton({super.key, this.rightPadding = true});

  final bool rightPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeState = ref.watch(placeProvider);
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10.0)
          .copyWith(right: rightPadding ? 10 : 0),
      child: StandartButton(
        text: placeState.currentPlace?.description ?? "Select Location",
        icon: Icon(Icons.location_on),
        onPressed: () {
          context.pushNamed(
            placeSearchRoute,
          );
        },
      ),
    );
  }
}
