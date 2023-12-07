import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:realestatebf/root/root.dart';
import 'package:realestatebf/utils/ui_utils.dart';

import '../models/property.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';

class BuyNowScreen extends StatefulWidget {
  final Property property;
  final DateTime startDate;
  final DateTime endDate;
  final int total;

  const BuyNowScreen(
      {Key? key,
      required this.property,
      required this.startDate,
      required this.endDate,
      required this.total})
      : super(key: key);

  @override
  State<BuyNowScreen> createState() => _BuyNowScreenState();
}

class _BuyNowScreenState extends State<BuyNowScreen> {
  TextEditingController phoneNumberController = TextEditingController(text: "");
  TextEditingController otpCodeController = TextEditingController(text: "");
  String payment = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBoody(),
    );
  }

  _buildBoody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _space,
            _buildPictures(),
            _space,
            _buildPropertyInfo(),
            const Divider(
              thickness: 0.5,
            ),
            _buildReservationInfo(),
            const Divider(
              thickness: 0.5,
            ),
            _space,
            _buildPaymentChoose(),
            _space,
            _buildPaymentForm(),
          ],
        ),
      ),
    );
  }

  final Widget _space = const SizedBox(height: 15);

  Widget _buildPictures() {
    List<Widget> lists = List.generate(
      widget.property.pictures!.length,
      (index) => Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            '$mediaUrl${widget.property.pictures![index].image}',
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

  Widget _buildPropertyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.property.nom}",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildReservationInfo() {
    String startDate = DateFormat('dd MMMM, yyyy').format(widget.startDate);
    String endDate = DateFormat('dd MMMM, yyyy').format(widget.endDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Votre réservation",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            Text(
              startDate,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            const Text(" - "),
            Text(endDate,
                style:
                    TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600)),
          ],
        ),
        _space,
        Row(
          children: [
            const Text("Total"),
            const SizedBox(width: 10),
            Text(
              "${numberFormat.format(widget.total)}$priceSymbole",
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }

  Widget _buildPaymentChoose() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Moyen de paiement",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            _space,
            GestureDetector(
              onTap: () {
                setState(() {
                  payment = "om";
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  "assets/images/orange_money.png",
                  width: 75,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          payment == "om"
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Paiement",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    _space,
                    _space,
                    TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      showCursor: false,
                      readOnly: false,
                      decoration: const InputDecoration(
                        labelText: "Téléphone",
                        hintText: "Numéro de téléphone",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Le numéro de téléphone ayant effectué le paiement est requis';
                        }
                        return null;
                      },
                      onTap: () {},
                    ),
                    _space,
                    TextFormField(
                      controller: otpCodeController,
                      keyboardType: TextInputType.number,
                      showCursor: false,
                      readOnly: false,
                      decoration: const InputDecoration(
                        labelText: "OTP",
                        hintText: "Code otp",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vous devez saisir le code otp fournis par Orange.';
                        }
                        if (value.length < 5) {
                          return 'Le code otp est composé de 6 chiffres';
                        }
                        return null;
                      },
                    ),
                    _space,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (phoneNumberController.text.isNotEmpty &&
                              otpCodeController.text.isNotEmpty) {
                            savePayment();
                          } else {
                            UiUtils.setSnackBar(
                                "Attention",
                                "Vous devez saisir le numéro de téléphone et le code otp fournis.",
                                context,
                                false);
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        child: const Center(
                          child: Text(
                            "Valider",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Future savePayment() async {
    UiUtils.modalLoading(context, "Paiement en cours...");

    final body = {
      "property": widget.property.id.toString(),
      "date_debut": DateFormat('yyyy-MM-dd hh:mm').format(widget.startDate),
      "date_fin": DateFormat('yyyy-MM-dd hh:mm').format(widget.endDate),
      "phone": phoneNumberController.text,
      "method": payment,
      "otp": otpCodeController.text,
      "amount": widget.total.toString()
    };

    final response = await post(Uri.parse(reservationUrl), headers: ApiUtils.getHeaders(), body: body);

    final responseJson = jsonDecode(response.body);
    //print(response.body);

    if (!mounted) return;
    Navigator.of(context).pop();

    if (response.statusCode == 201) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Votre réservation a été enregistrée.',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Consultez vos réservations dans la section réservations",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Lottie.asset(
                    'assets/json/booked.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      //if (!mounted) return;
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const RootApp()));
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (response.statusCode == 200) {
      var rpc = responseJson['data'];
      String body = rpc['message'];
      if (body.isNotEmpty) {
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (_) {
              return Dialog(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // The loading indicator
                      const Icon(
                        Icons.error,
                        color: Colors.orange,
                        size: 96,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Some text
                      const Text(
                        'Une erreur s\'est produite lors du paiement',
                        textAlign: TextAlign.center,
                      ),
                      _space,
                      Padding(
                        padding: const EdgeInsets.all(space),
                        child: Text(body),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Fermer"),
                      ),
                    ],
                  ),
                ),
              );
            });
      }

      return null;
    }
  }
}
