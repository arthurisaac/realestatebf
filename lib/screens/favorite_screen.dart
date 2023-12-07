import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/property.dart';
import '../theme/color.dart';
import '../utils/api_utils.dart';
import '../utils/constants.dart';
import '../utils/ui_utils.dart';
import '../widgets/no_logged.dart';
import 'package:http/http.dart';

import '../widgets/property_item.dart';
import 'details_property_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late final Future myFuture = getFavorites();
  String? token = Hive.box(hive).get("token", defaultValue: null);

  @override
  Widget build(BuildContext context) {
    return token == null
        ? const NoLogged() :
        Scaffold(
          appBar: AppBar(
            title: _buildHeader(),
          ),
          body: _buildBody(),
        );
    /*CustomScrollView(
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
  }

  _buildHeader() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Mes favoris"),
            Container()
          ],
        ),
      ],
    );
  }

  _buildBody() {
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
                  return Column(
                    children: [
                      const SizedBox(height: 15),
                      ListView.builder(
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
                          }),
                    ],
                  );
                } else {
                  return Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: const [
                        Column(
                          children: [
                            Icon(Icons.bookmark_remove, size: 100,),
                            SizedBox(height: 15,),
                            Text("Vous n'avez pas de favoris"),
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

  Future<List<Property>?> getFavorites() async {
    try {
      final response = await get(Uri.parse(favoriteUrl), headers: ApiUtils.getHeaders(),);

      final responseJson = jsonDecode(response.body);

      var jsonResponse = responseJson['data'] as List<dynamic>;

      List<Property> list =
      jsonResponse.map((e) => Property.fromJson(e)).toList();

      return list;
    } catch (e) {
      if (mounted) {
        UiUtils.setSnackBar(errorOccured, e.toString(), context, false);
      };
      return [];
    }
  }
}
