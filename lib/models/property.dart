import 'package:realestatebf/models/pictures.dart';

import 'user.dart';

class Property {
  int? id;
  User? user;
  String? nom;
  String? quartier;
  String? ville;
  String? pays;
  String? latitude;
  String? longitude;
  String? description;
  String? imagePrincipale;
  int? meublee;
  String? typePropriete;
  int? superficie;
  String? superficieUnite;
  int? nombreChambre;
  int? nombreBain;
  int? nombreParking;
  int? nombrePersonneMax;
  int? minimumReservation;
  int? reductionNombreReservation;
  int? prix;
  String? typePrix;
  int? vue;
  int? partage;
  int? favorite;
  String? createdAt;
  String? updatedAt;
  List<Pictures>? pictures;

  Property(
      {this.id,
        this.user,
        this.nom,
        this.quartier,
        this.ville,
        this.pays,
        this.latitude,
        this.longitude,
        this.description,
        this.imagePrincipale,
        this.meublee,
        this.typePropriete,
        this.superficie,
        this.superficieUnite,
        this.nombreChambre,
        this.nombreBain,
        this.nombreParking,
        this.nombrePersonneMax,
        this.minimumReservation,
        this.reductionNombreReservation,
        this.prix,
        this.typePrix,
        this.vue,
        this.partage,
        this.favorite,
        this.createdAt,
        this.updatedAt,
        this.pictures});

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    nom = json['nom'];
    quartier = json['quartier'];
    ville = json['ville'];
    pays = json['pays'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    description = json['description'];
    imagePrincipale = json['image_principale'];
    meublee = json['meublee'];
    typePropriete = json['type_propriete'];
    superficie = json['superficie'];
    superficieUnite = json['superficie_unite'];
    nombreChambre = json['nombre_chambre'];
    nombreBain = json['nombre_bain'];
    nombreParking = json['nombre_parking'];
    nombrePersonneMax = json['nombre_personne_max'];
    minimumReservation = json['minimum_reservation'];
    reductionNombreReservation = json['reduction_nombre_reservation'];
    prix = json['prix'];
    typePrix = json['type_prix'];
    vue = json['vue'];
    partage = json['partage'];
    favorite = json['favorite'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures!.add(Pictures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['nom'] = nom;
    data['quartier'] = quartier;
    data['ville'] = ville;
    data['pays'] = pays;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['description'] = description;
    data['image_principale'] = imagePrincipale;
    data['meublee'] = meublee;
    data['type_propriete'] = typePropriete;
    data['superficie'] = superficie;
    data['superficie_unite'] = superficieUnite;
    data['nombre_chambre'] = nombreChambre;
    data['nombre_bain'] = nombreBain;
    data['nombre_parking'] = nombreParking;
    data['nombre_personne_max'] = nombrePersonneMax;
    data['minimum_reservation'] = minimumReservation;
    data['reduction_nombre_reservation'] = reductionNombreReservation;
    data['prix'] = prix;
    data['type_prix'] = typePrix;
    data['vue'] = vue;
    data['partage'] = partage;
    data['favorite'] = favorite;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pictures != null) {
      data['pictures'] = pictures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
