import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/property.dart';
import '../theme/color.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';
import 'package:http/http.dart';

import '../utils/ui_utils.dart';
import '../widgets/property_item.dart';
import 'details_property_screen.dart';

class SearchPropertyScreen extends StatefulWidget {
  const SearchPropertyScreen({Key? key}) : super(key: key);

  @override
  State<SearchPropertyScreen> createState() => _SearchPropertyScreenState();
}

class _SearchPropertyScreenState extends State<SearchPropertyScreen> {
  TextEditingController searchController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildHeader(),
      ),
      body: _buildBody(),
    );
  }

  _buildHeader() {
    return Column(
      children: [
        TextField(
          controller: searchController,
          keyboardType: TextInputType.text,
          showCursor: true,
          decoration: const InputDecoration(
            hintText: "Taper pour rechercher",
          ),
          onTap: () {},
          onChanged: (text) {
            //print('First text field: $text');
            if (text.isNotEmpty && text.length > 2) {
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  _buildBody() {
    return RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            setState(() {});
          });
        },
        child: searchController.text.isEmpty
            ? Container() : Container(
          margin: const EdgeInsets.all(15),
          child: FutureBuilder(
              future: getProperties(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (snapshot.hasData) {
                  if (snapshot.data != null) {
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
                    return const Center(child: Text("Aucune donnée"));
                  }
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        )
    );
  }

  Future<List<Property>?> getProperties() async {
    try {
      Map<String, String> queryParams = {
        "q" : searchController.text
      };

      final Uri uri = Uri.parse(searchPropertiesUrl).replace(queryParameters: queryParams);

      final response = await get(
        uri,
        headers: ApiUtils.getHeaders(),
      );

      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<Property> list = jsonResponse.map((e) => Property.fromJson(e)).toList();

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
