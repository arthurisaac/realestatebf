import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:realestatebf/models/property.dart';
import 'package:realestatebf/screens/reservation_screen.dart';
import 'package:realestatebf/utils/constants.dart';
import 'package:realestatebf/widgets/custom_details_indicator_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

import '../theme/color.dart';
import '../utils/trapezium__left_clipper.dart';
import '../widgets/old_widgets/icon_box.dart';
import '../widgets/property_images_item.dart';

class DetailsPropertyScreen extends StatefulWidget {
  final Property property;

  const DetailsPropertyScreen({Key? key, required this.property}) : super(key: key);

  @override
  State<DetailsPropertyScreen> createState() => _DetailsPropertyScreenState();
}

class _DetailsPropertyScreenState extends State<DetailsPropertyScreen> {
  ScrollController _scrollController = ScrollController();
  double _titleOpacity = 0.0;
  int _index = 0;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _titleOpacity = (_scrollController.offset / 800.0).clamp(0.0, 1.0);
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            //backgroundColor: AppColor.appBgColor,
            pinned: true,
            expandedHeight: 410,
            snap: false,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Opacity(
                opacity: _titleOpacity,
                child: Text(
                  '${widget.property.nom}',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              background: _buildHeader(),
            ),
            //title: Text('${widget.property.nom}'),
          ),
          SliverToBoxAdapter(child: _buildBody())
        ],
      ),
      bottomNavigationBar: _buildFooter(),
    );
  }

  _buildHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 400,
              enlargeCenterPage: false,
              enableInfiniteScroll: true,
              disableCenter: false,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() => _index = index);
              },
            ),
            items: List.generate(
              widget.property.pictures!.length,
              (index) => PropertyPicturesItem(
                picture: widget.property.pictures![index],
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: widget.property.pictures!.isNotEmpty ? CarouselIndicator(
              width: 8,
              height: 8,
              color: Colors.black,
              //activeColor: Theme.of(context).primaryColor,
              count: widget.property.pictures!.length,
              index: _index,
            ) : Container(),
          ),
        ),
        Positioned(
          right: 20,
          top: 380,
          child: _buildNavigation(),
        ),
      ],
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPropertyName(),
          _space,
          _buildIndicators(),
          _space,
          _buildPropertyInfo(),
        ],
      ),
    );
  }

  _buildFooter() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          ClipPath(
            clipper: TrapeziumLeftClipper(),
            child: Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 1 / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 6 / 15),
                    child: Center(
                        child: Text(
                      "${numberFormat.format(widget.property.prix)}$priceSymbole",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 6 / 15),
                    child: Center(
                      child: Text(
                        "(${widget.property.typePrix})",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  )
                ],
              ),
            ),
          ),
          /*Text(
            "${widget.property.prix}$priceSymbole",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),*/
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReservationScreen(property: widget.property,)));
              },
              child: Container(
                color: Colors.white,
                child: const Text(
                  "Reserver \nmaintenant",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final Widget _space = const SizedBox(
    height: 10,
  );

  /*Widget _buildPictures() {
    List<Widget> lists = List.generate(
      widget.property.pictures!.length,
      (index) => PropertyPicturesItem(
        picture: widget.property.pictures![index],
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }*/

  Widget _buildPropertyName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.property.nom}",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            "${widget.property.quartier}, ${widget.property.ville}, ${widget.property.pays}",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black45),
          ),
          const SizedBox(
            height: 2,
          ),
          Row(
            children: [
              Text(
                "${widget.property.superficie} ${widget.property.superficieUnite}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).primaryColorDark),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  "•",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black38),
                ),
              ),
              Text(
                "${widget.property.typePropriete}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).primaryColorDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyInfo() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${widget.property.description}"),
          const SizedBox(
            height: 10,
          ),
          Text("${widget.property.nombrePersonneMax} personne(s) max"),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    List<Widget> lists = [
      CustomDetailsIndicator(
        image: 'assets/images/bed_outline.png',
        label: "${widget.property.nombreChambre} Chambre(s)",
      ),
      CustomDetailsIndicator(
        image: 'assets/images/bath_outline.png',
        label: "${widget.property.nombreBain} douche(s)",
      ),
      CustomDetailsIndicator(
        image: 'assets/images/car_outline.png',
        label: "${widget.property.nombreParking} garage(s)",
      ),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  Widget _buildNavigation() {
    return GestureDetector(
      onTap: () {
        if (widget.property.latitude != null || widget.property.longitude != null) {
          String uri = "https://www.google.com/maps/dir//${widget.property.latitude},${widget.property.longitude}";
          _launchURL(Uri.parse(uri));
        }
      },
      child: IconBox(
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
      ),
    );
  }

  void _launchURL(url) async => await launchUrl(url);
}