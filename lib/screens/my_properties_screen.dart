import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:realestatebf/screens/new_form_property_screen.dart';
import 'package:realestatebf/widgets/my_property_item.dart';

import '../models/property.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';
import 'package:http/http.dart';

import 'my_property_details_screen.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  late Future myFuture = getProperties();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const NewFormPropertyScreen()));
        },
        child: const Icon(Icons.post_add),
      ),
    );
  }

  Widget _buildBody() {
    return _propertyList();
  }

  _propertyList() {
    return Padding(
      padding: const EdgeInsets.all(15),
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
                  return Container(
                    margin: const EdgeInsets.only(bottom: 45),
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Property property = snapshot.data![index];
                          return MyPropertyItem(
                            property: property,
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => MyPropertyDetails(
                                    property: property,
                                  ),
                                ),
                              );
                              setState(() {
                                myFuture = getProperties();
                              });
                            },
                          );
                        }),
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .2),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const NewFormPropertyScreen()),
                        );
                      },
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Column(
                            children: [
                              Lottie.asset(
                                'assets/json/empty.json',
                                width: 160,
                                height: 160,
                                fit: BoxFit.fill,
                                repeat: true,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Vous n'avez pas de publication. \n Ajouter une nouvelle en cliquez sur le bouton + ",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Future<List<Property>?> getProperties() async {
    try {
      Map<String, String> queryParams = {};
      final Uri uri = Uri.parse(myPropertiesUrl).replace(queryParameters: queryParams);

      final response = await get(
        uri,
        headers: ApiUtils.getHeaders(),
      );

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
}
