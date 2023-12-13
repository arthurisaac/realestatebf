import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:realestatebf/models/property.dart';
import 'package:realestatebf/screens/edit_property_screen.dart';
import 'package:realestatebf/utils/ui_utils.dart';
import 'package:http/http.dart';

import '../utils/api_utils.dart';
import '../utils/constants.dart';

class MyPropertyDetails extends StatefulWidget {
  final Property property;

  const MyPropertyDetails({Key? key, required this.property}) : super(key: key);

  @override
  State<MyPropertyDetails> createState() => _MyPropertyDetailsState();
}

class _MyPropertyDetailsState extends State<MyPropertyDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildBody(),
      bottomNavigationBar: InkWell(
        onTap: () {
          _showFilterDialog();
        },
        child: Container(
          color: Colors.orange,
          padding: const EdgeInsets.all(15),
          child: const Text(
            "Options",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _space,
            _buildPictures(),
            _space,
            _buildPropertyName(),
            _space,
            _buildPropertyInfo(),
            _space,
          ],
        ),
      ),
    );
  }

  final Widget _space = const SizedBox(
    height: 10,
  );

  Widget _buildPictures() {
    List<Widget> lists = List.generate(
      widget.property.pictures!.length,
      (index) => Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            '$mediaUrl${widget.property.pictures![index].image}',
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Center(child: Text('😢'));
            },
          ),
        ),
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(children: lists),
    );
  }

  Widget _buildPropertyName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.property.nom}",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          "${widget.property.quartier}, ${widget.property.ville} ",
          style: const TextStyle(color: Colors.black45),
        ),
        const SizedBox(height: 2),
        Text(
          "${widget.property.superficie} ${widget.property.superficieUnite}",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }

  Widget _buildPropertyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${widget.property.description}"),
        const SizedBox(
          height: 10,
        ),
        Text("${widget.property.nombrePersonneMax} personne(s) max"),
      ],
    );
  }

  _showFilterDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Modifier'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditPropertyScreen(property: widget.property)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Supprimer'),
              onTap: () {
                Navigator.of(context).pop();
                UiUtils.msgConfirmationDialog(
                    context, "Suppression", "Souhaitez-vous vraiment supprimer cet annonce",
                    () async {
                  await deleteProperty();
                }, () {
                  Navigator.of(context).pop();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Annuler'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteProperty() async {
    try {
      UiUtils.modalLoading(context, "Suppression en cours...");

      Map<String, String> queryParams = {};
      final Uri uri =
          Uri.parse("$propertiesUrl/${widget.property.id}").replace(queryParameters: queryParams);

      await delete(
        uri,
        headers: ApiUtils.getHeaders(),
      );

      if (mounted) {
        Navigator.of(context)
          ..pop()
          ..pop()
          ..pop();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
      //throw AlertException(errorMessageCode: e.toString());
    }
  }
}
