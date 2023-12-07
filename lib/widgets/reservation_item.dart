import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realestatebf/screens/details_reservation_screen.dart';

import '../models/property.dart';
import '../models/reservation.dart';
import '../utils/constants.dart';

class ReservationItem extends StatelessWidget {
  final Reservation reservation;
  const ReservationItem({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Property? property = reservation.property;

    DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");

    DateTime dateDebut =
    format.parse(reservation.dateDebut ?? "2023-12-01 12:00:00");
    DateTime dateFin = format.parse(reservation.dateFin ?? "2023-12-01 12:00:00");

    String formatDateDebut = DateFormat.MMMd().format(dateDebut);
    String formatDateFin = DateFormat.MMMd().format(dateFin);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsReservationSceren(reservation: reservation)));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: property == null ? Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)
          ),
          child: const Center(
            child: Text("La publication n'existe plus"),
          ),
        ) : Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                "$mediaUrl${property.imagePrincipale}",
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${property.nom}",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${property.quartier}, ${property.ville}",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.black45),
                  ),
                  const Text("Réservation"),
                  Row(
                    children: [
                      Text(
                        formatDateDebut,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      const Text(" - "),
                      Text(
                        formatDateFin,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
