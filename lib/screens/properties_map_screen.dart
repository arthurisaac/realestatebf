import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/property.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';
import 'package:http/http.dart';

import 'details_property_screen.dart';

class PropertiesMapScreen extends StatefulWidget {
  const PropertiesMapScreen({Key? key}) : super(key: key);

  @override
  State<PropertiesMapScreen> createState() => _PropertiesMapScreenState();
}

class _PropertiesMapScreenState extends State<PropertiesMapScreen> {
  final MapController _mapController = MapController();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  LatLng? current;
  final List<Marker> _properties = [];

  @override
  void initState() {
    _getCurrentLocation();
    _getProperties();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: current != null
          ? FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: current,
                zoom: 12.0,
                maxZoom: 18.0,
                minZoom: 3.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: current!,
                      builder: (ctx) => const Icon(Icons.location_on, color: Colors.red),
                    ),
                    ..._properties,
                  ],
                ),
              ],
            )
          : const Center(
              child: Text("Chargement de la position en cours"),
            ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      final hasPermission = await _handlePermission();

      if (!hasPermission) {
        return;
      }

      Position position =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        current = LatLng(position.latitude, position.longitude);
      });
      if (kDebugMode) {
        print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      }
    } catch (e) {
      print("Erreur $e");
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return true;
  }

  Future<List<Property>?> _getProperties() async {
    try {
      Map<String, String> queryParams = {};
      final Uri uri = Uri.parse(propertiesUrl).replace(queryParameters: queryParams);

      final response = await get(
        uri,
        headers: ApiUtils.getHeaders(),
      );
      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;
      List<Property> list = jsonResponse.map((e) => Property.fromJson(e)).toList();

      for (var element in list) {
        if (element.latitude != null && element.longitude != null) {
          var marker = Marker(
            width: 40.0,
            height: 40.0,
            point: LatLng(double.parse(element.latitude.toString()),
                double.parse(element.longitude.toString())),
            builder: (ctx) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPropertyScreen(
                      property: element,
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Icon(Icons.king_bed_rounded, color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          );

          _properties.add(marker);
        }
      }

      setState(() => _properties);

      return list;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      //throw AlertException(errorMessageCode: e.toString());
      return [];
    }
  }
}
