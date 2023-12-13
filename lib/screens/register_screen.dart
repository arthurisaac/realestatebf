import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:realestatebf/root/root.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../utils/ui_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nomController = TextEditingController(text: "");
  TextEditingController prenomController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController passwordConfirmationController = TextEditingController(text: "");
  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _space,
                TextFormField(
                  controller: nomController,
                  keyboardType: TextInputType.name,
                  showCursor: true,
                  decoration: const InputDecoration(
                    hintText: "Nom",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Votre nom est requis';
                    }
                    return null;
                  },
                ),
                _space,
                TextFormField(
                  controller: prenomController,
                  keyboardType: TextInputType.name,
                  showCursor: true,
                  decoration: const InputDecoration(
                    hintText: "Prénom",
                    prefixIcon: Icon(Icons.person_2_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Votre prénom est requis';
                    }
                    return null;
                  },
                ),
                _space,
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  showCursor: true,
                  decoration: const InputDecoration(
                    hintText: "Adresse mail",
                    prefixIcon: Icon(Icons.alternate_email_outlined),
                  ),
                  /*validator: (value) {
                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!)) {
                      return 'Entrer un email valide!';
                    }
                    return null;
                  },*/
                ),
                _space,
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  showCursor: true,
                  decoration: const InputDecoration(
                    hintText: "Téléphone",
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Entrez votre numéro de téléphone";
                    }
                    return null;
                  },
                ),
                _space,
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    //labelText: password,
                    hintText: "Mot de passe",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFFd96e70),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Le mot de passe ne doit pas être vide";
                    }
                    return null;
                  },
                  onTap: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                _space,
                TextFormField(
                  controller: passwordConfirmationController,
                  keyboardType: TextInputType.text,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    //labelText: password,
                    hintText: "Confirmation de mot de passe",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFFd96e70),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Champ requis';
                    }
                    if (value.length < 8) {
                      return "Le mot de passe doit comporter au moins 8 caractères";
                    }
                    if (value != passwordController.text) {
                      return 'Les mots de passse ne correspondent pas';
                    }
                    return null;
                  },
                  onTap: () {},
                ),
                _space,
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
                      register();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    child: const Center(
                      child: Text(
                        "S'inscrire",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final Widget _space = const SizedBox(height: 15);

  Future register() async {
    UiUtils.modalLoading(context, "Inscription en cours...");

    final body = {
      "email": emailController.text,
      "password": passwordController.text,
      "password_confirmation": passwordConfirmationController.text,
      "nom": nomController.text,
      "prenom": prenomController.text,
      "phone": phoneController.text,
    };

    final response = await post(Uri.parse(registerUrl), headers: {}, body: body);

    final responseJson = jsonDecode(response.body);
    //print(response.body);

    if (!mounted) return;
    Navigator.of(context).pop();

    if (response.statusCode == 201 || response.statusCode == 200) {
      String token = responseJson["token"];
      Hive.box(hive).put("token", token);

      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RootApp()));
    } else {
      String body = responseJson['message'];
      if (kDebugMode) {
        print(responseJson['errors']);
      }
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
                    Padding(
                      padding: const EdgeInsets.all(20),
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
                      child: const Text(
                        "Fermer",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }

      return null;
    }
  }
}
