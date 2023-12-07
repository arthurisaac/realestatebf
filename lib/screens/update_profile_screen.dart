import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:realestatebf/models/user.dart';
import 'package:realestatebf/utils/constants.dart';

import '../utils/api_utils.dart';
import '../utils/ui_utils.dart';

class UpdateProfileScreen extends StatefulWidget {
  final User user;
  const UpdateProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nomController = TextEditingController(text: "");
  TextEditingController prenomController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nomController.text = widget.user.nom!;
    prenomController.text = widget.user.prenom!;
    phoneController.text = widget.user.phone!;
    emailController.text = widget.user.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informations personnelles"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Nom",
                  errorText: null,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Votre nom est requis";
                  }
                  return null;
                },
                onTap: () {},
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: prenomController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: "Prénom",
                  errorText: null,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Votre prénom";
                  }
                  return null;
                },
                onTap: () {},
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                showCursor: false,
                readOnly: false,
                decoration: const InputDecoration(
                  hintText: "Numéro téléphone",
                  errorText: null,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Numéro de téléphone requis";
                  }
                  return null;
                },
                onTap: () {},
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Email",
                  errorText: null,
                  border: OutlineInputBorder(),
                ),
                /*validator: (value) {
                  if (value!.isEmpty) {
                    return "Adresse mail";
                  }
                  return null;
                },*/
                onTap: () {},
              ),
              SizedBox(height: 15),
              TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _updateProfil();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(14),
                  child: const Text("Valider"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _updateProfil() async {
    UiUtils.modalLoading(context, "Mise à jour en cours");
    try {
      final body = {
        "nom": nomController.text,
        "prenom": prenomController.text,
        "phone": phoneController.text,
      };
      final response = await post(Uri.parse(updateUserUrl),
          body: body, headers: ApiUtils.getHeaders());
      final responseJson = jsonDecode(response.body);

      if (!mounted) return;
      Navigator.of(context).pop();

      if (responseJson.containsKey('errors')) {
        UiUtils.setSnackBar("Attention", responseJson['message'], context, false);
      }

      UiUtils.setSnackBar("Mise à jour", "Vos informations ont été mises à jour", context, false);

      return responseJson['message'];
    } on SocketException catch (_) {
      if (!mounted) return;
      UiUtils.setSnackBar("Attention", "Pas de connexion", context, false);
    }
  }
}
