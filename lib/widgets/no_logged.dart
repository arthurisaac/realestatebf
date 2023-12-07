import 'package:flutter/material.dart';

import '../screens/login_screen.dart';

class NoLogged extends StatelessWidget {
  const NoLogged({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Icon(Icons.no_accounts_rounded, size: 150,),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text("Veuillez vous connecter à votre compte pour continuer s'il vous plaît!", textAlign: TextAlign.center,),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const LoginScreen()));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              child: const Center(
                child: Text(
                  "Se connecter",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
