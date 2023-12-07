import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:realestatebf/models/property.dart';
import 'package:realestatebf/screens/details_property_screen.dart';
import 'package:realestatebf/screens/filter_dialog.dart';
import 'package:realestatebf/screens/properties_map_screen.dart';
import 'package:realestatebf/screens/search_property_screen.dart';
import 'package:realestatebf/utils/constants.dart';
import 'package:realestatebf/widgets/property_item.dart';

import '../models/filter.dart';
import '../theme/color.dart';
import '../utils/api_utils.dart';
import '../utils/ui_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future myFuture = getProperties(filter: null);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*return CustomScrollView(
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
    );*/
    return Scaffold(
      appBar: AppBar(
        title: _buildHeader(),
        automaticallyImplyLeading: false,
      ),
      body: _buildBody(),
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 60),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const PropertiesMapScreen()));
          },
          child: const Icon(Icons.map_outlined),
        ),
      ),
    );
  }

  _buildHeader() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text("Bonjour"), Container()],
        ),
      ],
    );
  }

  _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        _buildSearch(),
        _space(),
        _propertyList(),
        const SizedBox(height: 30),
      ],
    );
  }

  _buildSearch() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const SearchPropertyScreen()));
            },
            child: Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.only(left: 8),
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
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
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _showFilterDialog,
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(), //<-- SEE HERE
                padding: const EdgeInsets.all(10),
                backgroundColor: Theme.of(context).primaryColor),
            child: Image.asset(
              "assets/images/options.png",
              height: 25,
            ),
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
                if (snapshot.data!.length > 0) {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
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
                                builder: (context) => DetailsPropertyScreen(
                                  property: property,
                                ),
                              ),
                            );
                          },
                        );
                      });
                } else {
                  return Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .2),
                    child: ListView(
                      shrinkWrap: true,
                      children: const [
                        Column(
                          children: [
                            Icon(
                              Icons.bedtime_off_sharp,
                              size: 100,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text("Pas de publication pour le moment. \nRevenez plus tard!", textAlign: TextAlign.center,),
                          ],
                        ),
                      ],
                    ),
                  );
                }
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

  Future<List<Property>?> getProperties({required Filter? filter}) async {
    try {
      Map<String, String> queryParams = {};
      if (filter != null) {
        queryParams = {
          "prix-min": filter.prixMin ?? "0",
          "prix-max": filter.prixMax ?? "0",
          "nombre-chambre": filter.chambre ?? "0",
          "nombre-garage": filter.garage ?? "0",
        };
      }
      final Uri uri = Uri.parse(propertiesUrl).replace(queryParameters: queryParams);

      final response = await get(
        uri,
        headers: ApiUtils.getHeaders(),
      );

      print(response.statusCode);

      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<Property> list = jsonResponse.map((e) => Property.fromJson(e)).toList();

      return list;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      //throw AlertException(errorMessageCode: e.toString());
      return [];
    }
  }

  _showFilterDialog() async {
    final Filter result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return const FilterDialog();
      },
    );
    setState(() {
      myFuture = getProperties(filter: result);
    });
    //print(result);
  }
}
