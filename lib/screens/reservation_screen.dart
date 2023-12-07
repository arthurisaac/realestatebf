import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:realestatebf/models/date.dart';
import 'package:realestatebf/models/property.dart';
import 'package:realestatebf/screens/buy_now_screen.dart';
import 'package:realestatebf/utils/trapezium__right_clipper.dart';
import 'package:realestatebf/utils/ui_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../utils/api_utils.dart';
import '../utils/constants.dart';
import '../widgets/no_logged.dart';

class ReservationScreen extends StatefulWidget {
  final Property property;

  const ReservationScreen({Key? key, required this.property}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? token = Hive.box(hive).get("token", defaultValue: null);
  var firstDate = DateTime.now().add(const Duration(hours: 1));
  var price = 0;
  int differenceInDays = 1;
  DateTime startDate = DateTime.now();
  DateTime? endDate;

  late final Future myFuture = getUnAvailableDates();
  DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");

  @override
  void initState() {
    price = widget.property.prix ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return token == null
        ? Scaffold(
            appBar: AppBar(),
            body: const NoLogged(),
          )
        : Scaffold(
            appBar: AppBar(),
            body: _buildBody(),
            bottomNavigationBar: _buildFooter(),
          );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text("Réservation"),
          _space,
          _buildPropertyInfo(),
          _space,
          _buildReservationDatePicker(),
        ],
      ),
    );
  }

  final Widget _space = const SizedBox(height: 15);

  _buildFooter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 6 / 15),
                  child: Center(
                      child: Text(
                    "${numberFormat.format(price)}$priceSymbole",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  )),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 6 / 15),
                  child: Center(
                    child: Text(
                      differenceInDays > 1
                          ? "$differenceInDays ${widget.property.typePrix}s"
                          : "(${widget.property.typePrix})",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (endDate != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BuyNowScreen(
                    property: widget.property,
                    startDate: startDate,
                    endDate: endDate!,
                    total: price,
                  ),
                ),
              );
            } else {
              UiUtils.setSnackBar(
                  "Attention",
                  "Selectionnez vos dates de séjours avant de continuer s'il vous plaît",
                  context,
                  false);
            }
          },
          child: ClipPath(
            clipper: TrapeziumRightClipper(),
            child: Container(
              width: MediaQuery.of(context).size.width * 1 / 2,
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Payer \nmaintenant",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildPropertyInfo() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "$mediaUrl${widget.property.imagePrincipale}",
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.property.nom}",
                  style:
                      Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  "${widget.property.quartier}, ${widget.property.ville} ",
                  style: const TextStyle(color: Colors.black45),
                ),
                const SizedBox(height: 2),
                Text(
                  "${widget.property.superficie} ${widget.property.superficieUnite}",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildReservationDatePicker() {
    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Icon(
                Icons.error,
                size: 60,
              ),
            );
          }

          if (snapshot.hasData) {
            List<DateTime> _list = [];
            List<Date> dates = snapshot.data;

            for (var element in dates) {
              _list.add(format.parse(element.date!));
            }

            return SfDateRangePicker(
              enablePastDates: false,
              monthViewSettings: DateRangePickerMonthViewSettings(blackoutDates: _list),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  //print(args.value.toString());
                  //print('${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}');
                  //String startDate = DateFormat('dd/MM/yyyy').format(args.value.startDate);
                  //String endDate = DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate);
                  DateTime from = args.value.startDate;
                  DateTime to = args.value.endDate ?? args.value.startDate;
                  differenceInDays = to.difference(from).inDays;
                  setState(() {
                    price = (widget.property.prix ?? 1) * (differenceInDays + 1);
                    differenceInDays = differenceInDays;
                    startDate = from;
                    endDate = to;
                  });
                }
              },
              showNavigationArrow: true,
              selectionMode: DateRangePickerSelectionMode.range,
              minDate: firstDate,
              //maxDate: lastDate,
              /*monthCellStyle: const DateRangePickerMonthCellStyle(
                    //textStyle: TextStyle(color: Colors.lightGreen),
                    cellDecoration: BoxDecoration(color: Colors.green),
                    disabledDatesDecoration: BoxDecoration(color: Colors.red),
                    //cellDecoration: BoxDecoration(color:Colors.lightGreen),
                    disabledDatesTextStyle: TextStyle(color: Colors.white),
                  ),*/
            );
          }

          return const CircularProgressIndicator();
        });
  }

  Future<List<Date>> getUnAvailableDates() async {
    try {
      final response = await get(
        Uri.parse("$unavailableDatesUrl/?property=${widget.property.id}"),
        headers: ApiUtils.getHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = jsonDecode(response.body);

        var jsonResponse = responseJson['data'] as List<dynamic>;

        List<Date> list = jsonResponse.map((e) => Date.fromJson(e)).toList();

        return list;
      }

      return [];
    } catch (e) {
      if (mounted) {
        UiUtils.setSnackBar(errorOccured, e.toString(), context, false);
      }
      ;
      return [];
    }
  }
}
