import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical/providers/dio_provider.dart';

class MapPage extends StatelessWidget {
  final bool showControls;

  const MapPage({super.key, this.showControls = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MapView(showControls: showControls),
    );
  }
}

class MapView extends StatefulWidget {
  final bool showControls;

  const MapView({super.key, required this.showControls});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late final MapController _mapController;
  final String _mapboxToken =
      'pk.eyJ1IjoibWljaGFlbG11a3UiLCJhIjoiY2x2dXlxcTFpMGV1ZzJrbjY3bGM3enY1cyJ9.j88Kmiz1HFReLxsEuGRyWQ';
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _suggestions = [];
  bool _isSearching = false;
  bool _showSearchBar = false;
  LatLng? _markerPosition;
  List<Map<String, dynamic>> locationData = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _fetchLocationData();
  }

  Future<void> _fetchLocationData() async {
    try {
      List<Map<String, dynamic>> data = await DioProvider().fetchLocationData();
      setState(() {
        locationData = data;
      });
    } catch (e) {
      print('Failed to fetch location data: $e');
    }
  }

  Future<void> _getPlaceSuggestions(String query) async {
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$_mapboxToken';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _suggestions = data['features'];
        _isSearching = true;
      });
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<void> _getAddressFromCoordinates(LatLng coordinates) async {
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/${coordinates.longitude},${coordinates.latitude}.json?access_token=$_mapboxToken';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['features'].isNotEmpty) {
        final placeName = data['features'][0]['place_name'];
        setState(() {
          _searchController.text = placeName;
          _markerPosition = coordinates;
        });
      }
    } else {
      throw Exception('Failed to get address from coordinates');
    }
  }

  void _onSuggestionSelected(dynamic suggestion) {
    final coordinates = suggestion['geometry']['coordinates'];
    final boundingBox = suggestion['bbox'];
    final latLng = LatLng(coordinates[1], coordinates[0]);

    _searchController.text = suggestion['place_name'];

    if (boundingBox != null) {
      final southWest = LatLng(boundingBox[1], boundingBox[0]);
      final northEast = LatLng(boundingBox[3], boundingBox[2]);
      final bounds = LatLngBounds(southWest, northEast);

      _mapController.fitBounds(
        bounds,
        options: const FitBoundsOptions(
          padding: EdgeInsets.all(20.0),
        ),
      );
    } else {
      _mapController.move(latLng, 17.0);
    }

    setState(() {
      _isSearching = false;
      _suggestions = [];
      _showSearchBar = false;
      _markerPosition = latLng;
    });
  }

  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _suggestions = [];
      _isSearching = false;
      _markerPosition = null;
    });
  }

  void _zoomIn() {
    _mapController.move(_mapController.center, _mapController.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(_mapController.center, _mapController.zoom - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: const LatLng(27.175002, 78.0421170902921),
            zoom: 17.0,
            onTap: (tapPosition, point) async {
              await _getAddressFromCoordinates(point);
            },
          ),
          children: [
            TileLayer(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/michaelmuku/clwg520uy00h501nyfkiy0s93/tiles/256/{z}/{x}/{y}@2x?access_token=$_mapboxToken",
              additionalOptions: const {
                'accessToken':
                    'pk.eyJ1IjoibWljaGFlbG11a3UiLCJhIjoiY2x2dXlxcTFpMGV1ZzJrbjY3bGM3enY1cyJ9.j88Kmiz1HFReLxsEuGRyWQ',
                'id': 'mapbox.mapbox-streets-v7'
              },
            ),
            MarkerLayer(
              markers: locationData.map((location) {
                final latLng =
                    LatLng(location['latitude'], location['longitude']);
                return Marker(
                  width: 80.0,
                  height: 80.0,
                  point: latLng,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                );
              }).toList(),
            ),
            if (_markerPosition != null)
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _markerPosition!,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
          ],
        ),
        if (widget.showControls) ...[
          Positioned(
            top: 40,
            right: 10,
            child: Column(
              children: [
                if (_showSearchBar)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      width: 340,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: _toggleSearchBar,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: locationData
                                        .map((location) => location['location'])
                                        .join(', '),
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: _clearSearch,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      _getPlaceSuggestions(value);
                                    } else {
                                      setState(() {
                                        _suggestions = [];
                                        _isSearching = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (_isSearching)
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: _suggestions.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title:
                                        Text(_suggestions[index]['place_name']),
                                    onTap: () {
                                      _onSuggestionSelected(
                                          _suggestions[index]);
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (!_showSearchBar)
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _toggleSearchBar,
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            right: 10,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _zoomIn,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _zoomOut,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (!widget.showControls)
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.crop_free),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MapPage(showControls: true)));
                },
              ),
            ),
          ),
      ],
    );
  }
}
