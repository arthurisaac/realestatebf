import 'package:flutter/material.dart';
import 'package:realestatebf/models/pictures.dart';
import 'package:realestatebf/utils/constants.dart';

import 'custom_image.dart';

class PropertyPicturesItem extends StatefulWidget {
  final Pictures picture;
  const PropertyPicturesItem({Key? key, required this.picture}) : super(key: key);

  @override
  State<PropertyPicturesItem> createState() => _PropertyPicturesItemState();
}

class _PropertyPicturesItemState extends State<PropertyPicturesItem> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      '$mediaUrl${widget.picture.image}',
      fit: BoxFit.cover,
    );
  }
}
