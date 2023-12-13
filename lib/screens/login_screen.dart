import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:realestatebf/root/root.dart';
import 'package:realestatebf/screens/register_screen.dart';
import '../utils/constants.dart';
import '../utils/ui_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _space,
                    Image.asset("assets/images/logo.png", height: 160),
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
                      showCursor: true,
                      readOnly: false,
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
                    const SizedBox(
                      height: 30,
                    ),
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
                          login();
                        }
                      },
                      child: Container(
                        //width: double.infinity,
                        width: 200,
                        padding: const EdgeInsets.all(14),
                        child: const Center(
                          child: Text(
                            "Connexion",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: const Text(
                        "Mot de passe oublié ?",
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          "Créer un compte",
                          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final Widget _space = const SizedBox(height: 15);

  Future login() async {
    UiUtils.modalLoading(context, "Connexion en cours...");

    final body = {
      "phone": phoneController.text,
      "password": passwordController.text,
    };

    final response = await post(Uri.parse(loginUrl), headers: {}, body: body);

    final responseJson = jsonDecode(response.body);
    //print(response.body);

    if (!mounted) return;
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      String token = responseJson["token"];
      Hive.box(hive).put("token", token);

      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RootApp()));
    } else {
      String body = responseJson['message'];
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
            });
      }

      return null;
    }
  }
}
