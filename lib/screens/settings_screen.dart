import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:realestatebf/screens/my_properties_screen.dart';
import 'package:realestatebf/screens/login_screen.dart';
import 'package:realestatebf/screens/my_reservations_screen.dart';
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const MyPropertiesScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.signpost_outlined,
                            color: Theme
                                .of(context)
                                .primaryColor,
                            size: 35,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text("Mes publications"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const MyReservationsScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /*Icon(
                            Icons.calendar_month_outlined,
                            color: Theme
                                .of(context)
                                .primaryColor,
                            size: 35,
                          ),*/
                          AnimateIcon(
                            key: UniqueKey(),
                            onTap: () {},
                            iconType: IconType.continueAnimation,
                            animateIcon: AnimateIcons.calendar,
                            height: 35,
                            width: 35,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          const Text("Réservations"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                children: [
                  /*Icon(
                    Icons.account_circle_outlined,
                    color: Theme
                        .of(context)
                        .primaryColor,
                    size: 45,
                  ),*/
                  Image.asset("assets/images/account.gif", height: 40,),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("Gérer votre compte"),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  /*_buildBody() {
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
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MyPropertiesScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: Row(
                children: [
                  Icon(
                    Icons.signpost_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Mes publications"),
                ],
              ),
            ),
          ),
          _space,
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MyReservationsScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("Réservations"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }*/

  final Widget _space = const SizedBox(height: 15);
}
