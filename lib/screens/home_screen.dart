import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:realestatebf/models/property.dart';
import 'package:realestatebf/screens/details_property_screen.dart';
import 'package:realestatebf/utils/constants.dart';
import 'package:realestatebf/widgets/property_item.dart';

import '../theme/color.dart';
import '../utils/ui_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future myFuture = getProperties();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /*const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bonjour,",
                  style: TextStyle(
                    color: AppColor.darker,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Trouvez une maison",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),*/
            const Text("Hello"),
            Container()
          ],
        ),
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
          _buildSearch(),
          _space(),
          _propertyList(),
        ],
      ),
    );
  }

  _buildSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/search.png",
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      "Rechercher une propriété",
                      style: TextStyle(color: Colors.black38),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {},
            child: Image.asset(
              "assets/images/options.png",
              height: 25,
            ),
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(), //<-- SEE HERE
                padding: const EdgeInsets.all(10),
                backgroundColor: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  _propertyList() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FutureBuilder(
          future: myFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Property property = snapshot.data![index];
                      return PropertyItem(
                        property: property,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsProperty(
                                property: property,
                              ),
                            ),
                          );
                        },
                      );
                    });
              } else {
                return const Center(child: Text("Aucune donnée"));
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  _space() {
    return const SizedBox(
      height: 20,
    );
  }

  Future<List<Property>?> getProperties() async {
    try {
      final body = {
        //fcmIdKey: fcmToken
      };
      final response = await get(Uri.parse(propertiesUrl));

      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<Property> list =
          jsonResponse.map((e) => Property.fromJson(e)).toList();

      return list;
    } catch (e) {
      if (mounted) {
        UiUtils.setSnackBar(errorOccured, e.toString(), context, false);
      }
      //throw AlertException(errorMessageCode: e.toString());
      return [];
    }
  }
}
