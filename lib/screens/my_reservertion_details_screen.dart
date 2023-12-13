import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/property.dart';
import '../models/reservation.dart';
import '../utils/constants.dart';
import '../widgets/custom_network_image.dart';
import '../widgets/old_widgets/icon_box.dart';
import 'details_property_screen.dart';

class MyReservationDetailsScreen extends StatefulWidget {
  final Reservation reservation;

  const MyReservationDetailsScreen({Key? key, required this.reservation}) : super(key: key);

  @override
  State<MyReservationDetailsScreen> createState() => _MyReservationDetailsScreenState();
}

class _MyReservationDetailsScreenState extends State<MyReservationDetailsScreen> {
  Property? property;
  DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");

  DateTime dateDebut = DateTime.now();
  DateTime dateFin = DateTime.now();

  String formatDateDebut = "";
  String formatDateFin = "";

  @override
  void initState() {
    property = widget.reservation.property;

    dateDebut = format.parse(widget.reservation.dateDebut ?? "2023-12-01 12:00:00");
    dateFin = format.parse(widget.reservation.dateFin ?? "2023-12-01 12:00:00");



    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    formatDateDebut = DateFormat("dd MMMM yyyy hh:mm").format(dateDebut);
    formatDateFin = DateFormat("dd MMMM yyyy hh:mm").format(dateFin);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPropertyPicture(),
          _space,
          _buildProppertyInfo(),
          _divider,
          _buildReservationUser(),
          _space,
          _buildContacts(),
          _divider,
          _buildReservation()
        ],
      ),
    );
  }

  final Widget _space = const SizedBox(height: 15);
  final Widget _divider = const Padding(
    padding: EdgeInsets.all(15.0),
    child: Divider(),
  );

  _buildPropertyPicture() {
    return CustomNetworkImage(
      image: '$mediaUrl${property!.imagePrincipale}',
      height: 200,
      width: double.infinity,
    );
  }

  _buildProppertyInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${property!.nom}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "${property!.quartier}, ${property!.ville}, ${property!.pays}",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black45),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailsPropertyScreen(property: property!)));
            },
            child: const Icon(
              Icons.open_in_new,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  _buildContacts() {
    List<Widget> lists = [
      GestureDetector(
        onTap: () {
          String uri = "tel:${widget.reservation.user!.phone}";
          _launchURL(Uri.parse(uri));
        },
        child: IconBox(
          bgColor: Colors.white,
          child: Row(
            children: [
              Icon(
                Icons.call,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text("Appeler"),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        width: 15,
      ),
      GestureDetector(
        onTap: () {
          String uri = "sms:${widget.reservation.user!.phone}";
          _launchURL(Uri.parse(uri));
        },
        child: IconBox(
          bgColor: Colors.white,
          child: Row(
            children: [
              Icon(
                Icons.message_rounded,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text("Ecrire"),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        width: 15,
      ),
      widget.reservation.user!.email != null ? GestureDetector(
        onTap: () {
          String uri = "mailto:${widget.reservation.user!.email}";
          _launchURL(Uri.parse(uri));
        },
        child: IconBox(
          bgColor: Colors.white,
          child: Row(
            children: [
              Icon(
                Icons.alternate_email_outlined,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text("Email"),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ) : Container(),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  _buildReservationUser() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.reservation.user!.nom} ${widget.reservation.user!.prenom}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5,),
                Text("Contact : ${widget.reservation.user!.phone}"),
              ],
            ),
          ),
          IconBox(
            bgColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Icon(
                Icons.person_rounded,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildReservation() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month, color: Colors.green,),
              const SizedBox(width: 10,),
              Text("$formatDateDebut"),
            ],
          ),
          _space,
          Row(
            children: [
              const Icon(Icons.calendar_month, color: Colors.red,),
              const SizedBox(width: 10,),
              Text("$formatDateFin"),
            ],
          ),
        ],
      ),
    );
  }

  void _launchURL(url) async => await launchUrl(url);
}
