import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapControllerProvider extends ChangeNotifier {
  // keeps track of the classevents in the map view
  MapController controller = MapController();
}
