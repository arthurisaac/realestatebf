import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realestatebf/screens/login_screen.dart';
import 'package:realestatebf/screens/new_form_property_screen.dart';
import 'package:realestatebf/screens/profile_screen.dart';
import 'package:realestatebf/utils/constants.dart';
import 'package:realestatebf/widgets/no_logged.dart';

import '../theme/color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? token = Hive.box(hive).get("token", defaultValue: null);
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return token == null
        ? const NoLogged()
        : CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: AppColor.appBgColor,
                pinned: true,
                snap: true,
                floating: true,
                title: _buildHeader(),
                automaticallyImplyLeading: false,
              ),
              SliverToBoxAdapter(child: _buildBody())
            ],
          );
  }

  _buildHeader() {
    return const Column(
      children: [
        Text("Paramètres"),
      ],
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          token != null
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Gérer votre compte"),
                      ],
                    ),
                  ),
                )
              : Container(),
          _space,
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NewFormPropertyScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: Row(
                children: [
                  Icon(
                    Icons.post_add,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Nouveau"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final Widget _space = const SizedBox(height: 15);
}
