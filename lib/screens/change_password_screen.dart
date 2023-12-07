import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:realestatebf/utils/ui_utils.dart';

import '../utils/api_utils.dart';
import '../utils/constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController passwordConfirmationController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau mot de passe"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Nouveau mot de passe",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Mot de passe invalide";
                  }
                  if (value.length < 7) {
                    return "Le mot de passe doit avoir au moins 6 caractères";
                  }
                  return null;
                },
                onTap: () {},
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordConfirmationController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Confirmer le mot de passe",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Champ requis";
                  }
                  return null;
                },
                onTap: () {},
              ),
              const SizedBox(height: 15),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _updatePassword();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(14),
                  child: const Text("Valider", style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _updatePassword() async {
    UiUtils.modalLoading(context, "Mise à jour en cours");
    try {
      final body = {
        "password": passwordController.text,
        "password_confirmation": passwordConfirmationController.text,
        //fcmIdKey: fcmToken,
      };
      final response = await post(Uri.parse(updatePasswordUrl),
          body: body, headers: ApiUtils.getHeaders());
      final responseJson = jsonDecode(response.body);

      if (!mounted) return;
      Navigator.of(context).pop();

      if (responseJson.containsKey('errors')) {
        print(response.body);
        if (!mounted) return;
        UiUtils.setSnackBar("Attention", responseJson['message'], context, false);
      }

      UiUtils.setSnackBar("Mise à jour", "Votre mot de passe a bien été modifié", context, false);

      return responseJson['message'];
    } on SocketException catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
      UiUtils.setSnackBar("Attention", "Pas de connexion", context, false);
    }
  }
}
