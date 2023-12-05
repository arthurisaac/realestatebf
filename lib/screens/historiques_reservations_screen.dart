import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:realestatebf/models/property.dart';
import 'package:realestatebf/models/reservation.dart';
import 'package:realestatebf/widgets/reservation_item.dart';

import '../theme/color.dart';
import '../utils/constants.dart';
import '../utils/ui_utils.dart';

class HistoriqueReservationsScreen extends StatefulWidget {
  const HistoriqueReservationsScreen({Key? key}) : super(key: key);

  @override
  State<HistoriqueReservationsScreen> createState() => _HistoriqueReservationsScreenState();
}

class _HistoriqueReservationsScreenState extends State<HistoriqueReservationsScreen> {
  late final Future myFuture = getReservations();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: AppColor.appBgColor,
          pinned: true,
          snap: true,
          floating: true,
          automaticallyImplyLeading: false,
          title: _buildHeader(),
        ),
        SliverToBoxAdapter(child: _buildBody())
      ],
    );
  }

  _buildHeader() {
    return const Row(
      children: [Text("Mes réservations")],
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          _reservationList(),
        ],
      ),
    );
  }

  _reservationList() {
    return Padding(
      padding: const EdgeInsets.all(8),
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
      final body = {
        //fcmIdKey: fcmToken
      };
      final response = await get(Uri.parse(reservationUrl));

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
