import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realestatebf/screens/details_reservation_screen.dart';
import 'package:realestatebf/screens/my_reservertion_details_screen.dart';

import '../models/property.dart';
import '../models/reservation.dart';
import '../utils/constants.dart';

class MyReservationItem extends StatelessWidget {
  final Reservation reservation;

  const MyReservationItem({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Property? property = reservation.property;

    DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");

    DateTime dateDebut = format.parse(reservation.dateDebut ?? "2023-12-01 12:00:00");
    DateTime dateFin = format.parse(reservation.dateFin ?? "2023-12-01 12:00:00");

    String formatDateDebut = DateFormat.MMMd().format(dateDebut);
    String formatDateFin = DateFormat.MMMd().format(dateFin);

    final diffInDays = dateFin
        .difference(dateDebut)
        .inDays;
    final diffInMinutes = dateFin
        .difference(dateDebut)
        .inMinutes;

    Widget remain() {
      if (diffInDays > 0) {
        return Column(
          children: [
            Text(
              "$diffInDays",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Text(
              "Jours",
              style: Theme
                  .of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Colors.black45),
            ),
          ],
        );
      } else {
        if (diffInMinutes >= 1440) {
          return Column(
            children: [
              Image.asset("assets/images/event-accepted.gif"),
              const SizedBox(
                height: 5,
              ),
              const Text("Aujourd'hui"),
            ],
          );
        } else if (diffInDays == 1) {
          return Column(
            children: [
              Text(
                "$diffInMinutes",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text(
                "Minutes",
                style: Theme
                    .of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.black45),
              ),
            ],
          );
        } else {
          return const Column(
              children: [
                Icon(Icons.dangerous_rounded, size: 50, color: Colors.red,),
                SizedBox(height: 5,),
                Text("Passée")
              ]
          );
        }
      }

    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MyReservationDetailsScreen(reservation: reservation)));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: property == null
            ? Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: const Center(
            child: Text("La publication n'existe plus"),
          ),
        )
            : Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              constraints: const BoxConstraints(
                minHeight: 100,
                minWidth: 90,
              ),
              child: remain(),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${property.nom}",
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${property.quartier}, ${property.ville}",
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.black45),
                        ),
                        const Text("Réservation"),
                        Row(
                          children: [
                            Text(
                              formatDateDebut,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme
                                      .of(context)
                                      .primaryColor),
                            ),
                            const Text(" - "),
                            Text(
                              formatDateFin,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme
                                      .of(context)
                                      .primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
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
