import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ChooseCoordonatesScreen extends StatefulWidget {
  const ChooseCoordonatesScreen({Key? key}) : super(key: key);

  @override
  State<ChooseCoordonatesScreen> createState() =>
      _ChooseCoordonatesScreenState();
}

class _ChooseCoordonatesScreenState extends State<ChooseCoordonatesScreen> {
  late final MapController _mapController;
  LatLng? current;

  Point<double>? _textPos;

  @override
  void initState() {
    _mapController = MapController();
    _getCurrentLocation();

    super.initState();
  }

  void onMapEvent(MapEvent mapEvent) {
    if (mapEvent is! MapEventMove && mapEvent is! MapEventRotate) {
      // do not flood console with move and rotate events
      debugPrint(mapEvent.toString());
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        current = LatLng(position.latitude, position.longitude);
      });
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print("Erreur $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Position de la propriété"),
      ),
      body: Stack(
        children: [
          (current != null)
              ? FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    onMapEvent: onMapEvent,
                    onTap: (tapPos, latLng) {
                      final pt1 = _mapController.latLngToScreenPoint(latLng);
                      _textPos = Point(pt1.x, pt1.y);
                      current = latLng;
                      setState(() {});
                    },
                    center: current,
                    zoom: 14,
                    rotation: 0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    )
                  ],
                )
              : const Center(
                  child: Text("Calcul de votre position"),
                ),
          _textPos != null
              ? Positioned(
                  left: _textPos!.x.toDouble(),
                  top: _textPos!.y.toDouble(),
                  width: 30,
                  height: 30,
                  child: Icon(Icons.location_on_rounded, color: Theme.of(context).primaryColor,),
                )
              : Container()
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          Navigator.pop(context, current);
        },
        child: Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          //margin: EdgeInsets.all(10),
          padding: const EdgeInsets.all(20),
          child: const Text("Enregistrer", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        ),
      ),
    );
  }
}
