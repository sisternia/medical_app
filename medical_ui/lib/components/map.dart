import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        center: LatLng(27.175002, 78.0421170902921),
        zoom: 17.0,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/michaelmuku/clwg520uy00h501nyfkiy0s93/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWljaGFlbG11a3UiLCJhIjoiY2x2dXlxcTFpMGV1ZzJrbjY3bGM3enY1cyJ9.j88Kmiz1HFReLxsEuGRyWQ",
          additionalOptions: const {
            'accessToken':
                'pk.eyJ1IjoibWljaGFlbG11a3UiLCJhIjoiY2x2dXlxcTFpMGV1ZzJrbjY3bGM3enY1cyJ9.j88Kmiz1HFReLxsEuGRyWQ',
            'id': 'mapbox.mapbox-streets-v7'
          },
        ),
      ],
    );
  }
}
