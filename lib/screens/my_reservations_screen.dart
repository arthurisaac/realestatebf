import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/reservation.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';
import '../utils/ui_utils.dart';
import '../widgets/my_reservation_item.dart';
import '../widgets/reservation_item.dart';
import 'package:http/http.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({Key? key}) : super(key: key);

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  late final Future myFuture = getReservations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _reservationList(),
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

                        return MyReservationItem(reservation: reservation);
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
                            const Text("Il n'y a pas de réservation pour vous!"),
                          ],
                        ),
                      ],
                    ),
                  );
                }
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
        Uri.parse(myReservationUrl),
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
      if (kDebugMode) {
        print(e.toString());
      }
      //throw AlertException(errorMessageCode: e.toString());
      return [];
    }
  }
}
