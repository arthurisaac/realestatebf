import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realestatebf/models/user.dart';
import 'package:realestatebf/root/root.dart';
import 'package:http/http.dart';
import 'package:realestatebf/screens/update_profile_screen.dart';

import '../utils/api_utils.dart';
import '../utils/constants.dart';
import '../utils/ui_utils.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<User>? myFuture = getUser();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black],
            ).createShader(Rect.fromLTRB(0, -140, rect.width, rect.height - 20));
          },
          blendMode: BlendMode.darken,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/images/profile_bg.jpg'),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        FutureBuilder<User>(
            future: myFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 100,
                    color: Colors.red,
                  ),
                );
              }

              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return const Center(
                    child: Icon(
                      Icons.account_circle_outlined,
                      size: 100,
                      color: Colors.orange,
                    ),
                  );
                }
                User user = snapshot.data!;

                return Stack(
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black],
                        ).createShader(Rect.fromLTRB(0, -140, rect.width, rect.height - 20));
                      },
                      blendMode: BlendMode.darken,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: ExactAssetImage('assets/images/profile_bg.jpg'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                    Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        //title: const Text("Profil"),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.login_outlined),
                            tooltip: "Déconnexion",
                            onPressed: () {
                              logout();
                            },
                          ),
                        ],
                      ),
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _space,
                          Center(
                            child: Image.network(
                              "https://ui-avatars.com/api/?name=UN&rounded=true",
                              fit: BoxFit.fill,
                              loadingBuilder: (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          _space,
                          Center(
                              child: Text(
                            "${user.nom}",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          )),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              "${user.prenom}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              "${user.email ?? user.phone}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(23), topRight: Radius.circular(23))),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => UpdateProfileScreen(user: user,)),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Informations personnelles",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text("Mettre à jour"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => const ChangePasswordScreen()));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Mot de passe",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text("Changer le mot de passe"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Divider(),
                                  GestureDetector(
                                    onTap: () async {
                                      logout();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Déconnexion",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text("Déconnecter le compte"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ],
    );
  }

  final Widget _space = const SizedBox(height: 15);

  logout() {
    Hive.box(hive).put("token", null);
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RootApp()));
  }

  Future<User>? getUser() async {
    try {
      final response = await post(
        Uri.parse(meUrl),
        headers: ApiUtils.getHeaders(),
      );

      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['user'] as Map<String, dynamic>;

      return User.fromJson(jsonResponse);
    } catch (e) {
      if (mounted) {
        UiUtils.setSnackBar(errorOccured, e.toString(), context, false);
      }
      //throw AlertException(errorMessageCode: e.toString());
      return User();
    }
  }
}
