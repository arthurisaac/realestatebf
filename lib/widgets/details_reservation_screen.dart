import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:realestatebf/models/property.dart';
import 'package:realestatebf/models/reservation.dart';
import 'package:realestatebf/theme/color.dart';

import '../utils/constants.dart';
import 'old_widgets/icon_box.dart';

class DetailsReservationSceren extends StatefulWidget {
  final Reservation reservation;

  const DetailsReservationSceren({Key? key, required this.reservation}) : super(key: key);

  @override
  State<DetailsReservationSceren> createState() => _DetailsReservationScerenState();
}

class _DetailsReservationScerenState extends State<DetailsReservationSceren> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final MapController _mapController = MapController();

  Property? property;
  DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");

  @override
  void initState() {
    property = widget.reservation.property;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: AppBar(),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _space,
          _buildPictures(),
          _space,
          _buildMapLocation(),
          _space,
          _buildAuthor(),
          _space,
          _buildReservationInfo(),
          _space,
        ],
      ),
    );
  }

  final Widget _space = const SizedBox(height: 15);

  Widget _buildPictures() {
    List<Widget> lists = List.generate(
      property!.pictures!.length,
      (index) => Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            '$mediaUrl${property!.pictures![index].image}',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  Widget _buildMapLocation() {
    if (property!.latitude != null && property!.longitude != null) {
      double latitude = double.parse(property!.latitude!);
      double longitude = double.parse(property!.latitude!);
      return Container(
        height: 250,
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(latitude, longitude),
              zoom: 14.0,
              maxZoom: 18.0,
              minZoom: 3.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: LatLng(latitude, longitude),
                    builder: (ctx) => const Icon(Icons.location_on, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text("${property!.quartier}, ${property!.ville}, ${property!.pays}"),
      );
    }
  }

  Widget _buildAuthor() {
    if (property!.user != null) {
      // DateTime dateDebut = format.parse(property!.user!.createdAt ?? "2023-12-01 12:00:00");
      // String formatDateDebut = DateFormat.yMMM().format(dateDebut);
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${property!.user!.name}",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text("Contact ${property!.user!.email}"),
                  ],
                ),
                IconBox(
                  bgColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Icon(
                      Icons.person_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(15),
        child: const Row(children: [
          Icon(
            Icons.dangerous_outlined,
            color: Colors.red,
          ),
          SizedBox(
            width: 15,
          ),
          Text("Ce utilisateur n'existe plus")
        ]),
      );
    }
  }

  Widget _buildReservationInfo() {
    DateTime dateDebut = format.parse(widget.reservation.dateDebut ?? "2023-12-01 12:00:00");
    DateTime dateFin = format.parse(widget.reservation.dateFin ?? "2023-12-01 12:00:00");

    String formatDateDebut = DateFormat.MMMd().format(dateDebut);
    String formatDateFin = DateFormat.MMMd().format(dateFin);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Votre réservation",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Text(
                formatDateDebut,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              const Text(" - "),
              Text(
                formatDateFin,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          _space,
          Row(
            children: [
              const Text("Coût total"),
              const SizedBox(width: 10),
              Text(
                "${numberFormat.format(widget.reservation.amount)}$priceSymbole",
                style:
                    TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<Position?> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return null;
    }

    return _geolocatorPlatform.getCurrentPosition();
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
}
