import 'package:flutter/material.dart';
import 'package:realestatebf/models/property.dart';
import 'package:realestatebf/utils/constants.dart';
import 'old_widgets/icon_box.dart';
import 'dart:math' as math;

class PropertyItem extends StatefulWidget {
  final Property property;
  final Function() onTap;
  const PropertyItem({Key? key, required this.property, required this.onTap}) : super(key: key);

  @override
  State<PropertyItem> createState() => _PropertyItemState();
}

class _PropertyItemState extends State<PropertyItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 260,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                image: DecorationImage(
                  image: NetworkImage('$mediaUrl${widget.property.imagePrincipale}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: 15,
              child: _buildFavorite(),
            ),
            Positioned(
              right: 20,
              top: 130,
              child: _buildNavigation(),
            ),
            Positioned(
              left: 15,
              top: 160,
              child: _buildInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavorite() {
    return const Icon(
      Icons.bookmark_border_rounded,
      color: Colors.white,
      size: 28,
    );
  }

  Widget _buildNavigation() {
    return IconBox(
      bgColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Transform.rotate(
          angle: 20 * math.pi / 180,
          child: Icon(
            Icons.navigation_sharp,
            color: Theme.of(context).primaryColor,
            size: 23,
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${widget.property.nom}", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),),
        Text("${widget.property.quartier}, ${widget.property.ville}", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black45),),
        Text("${widget.property.prix}$priceSymbole (${widget.property.typePrix})", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).primaryColorDark),),
        const SizedBox(height: 10,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              indicator(image: "assets/images/bed.png", text: "${widget.property.nombreChambre} lit"),
              indicator(image: "assets/images/bath.png", text: "${widget.property.nombreBain} bain"),
              indicator(image: "assets/images/car.png", text: "${widget.property.nombreParking} garage"),
            ],
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget indicator({required String image, required String text,}) {
    return Row(
      children: [
        Image.asset(image, height: 30,),
        const SizedBox(width: 5,),
        Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black45),),
        SizedBox(width: 10,),
      ],
    );
  }
}
