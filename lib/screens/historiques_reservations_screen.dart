import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:realestatebf/models/reservation.dart';
import 'package:realestatebf/widgets/no_logged.dart';
import 'package:realestatebf/widgets/reservation_item.dart';

import '../utils/api_utils.dart';
import '../utils/constants.dart';
import '../utils/ui_utils.dart';

class HistoriqueReservationsScreen extends StatefulWidget {
  const HistoriqueReservationsScreen({Key? key}) : super(key: key);

  @override
  State<HistoriqueReservationsScreen> createState() => _HistoriqueReservationsScreenState();
}

class _HistoriqueReservationsScreenState extends State<HistoriqueReservationsScreen> {
  late final Future myFuture = getReservations();
  String? token = Hive.box(hive).get("token", defaultValue: null);

  @override
  Widget build(BuildContext context) {
    return token == null
        ? const NoLogged()
        : Scaffold(
            appBar: AppBar(
              title: _buildHeader(),
              automaticallyImplyLeading: false,
            ),
            body: _reservationList(),
          );
  }

  _buildHeader() {
    return const Row(
      children: [Text("Mes réservations")],
    );
  }

  _reservationList() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: FutureBuilder(
          future: myFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (snapshot.data!.length > 0) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Reservation reservation = snapshot.data![index];

                        return ReservationItem(reservation: reservation);
                      });
                } else {
                  return Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          children: [
                            Lottie.asset(
                              'assets/json/no_calendar.json',
                              width: 150,
                              height: 150,
                              fit: BoxFit.fill,
                              repeat: true,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text("Vous n'avez fait aucune réservation"),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Reservation reservation = snapshot.data![index];

                      return ReservationItem(reservation: reservation);
                    });
              } else {
                return const Center(child: Text("Aucune donnée"));
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Future<List<Reservation>?> getReservations() async {
    try {
      final response = await get(
        Uri.parse(reservationUrl),
        headers: ApiUtils.getHeaders(),
      );

      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<Reservation> list = jsonResponse.map((e) => Reservation.fromJson(e)).toList();

      return list;
    } catch (e) {
      if (mounted) {
        UiUtils.setSnackBar(errorOccured, e.toString(), context, false);
      }
      //throw AlertException(errorMessageCode: e.toString());
      return [];
    }
  }
}
