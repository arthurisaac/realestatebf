import 'package:realestatebf/models/user.dart';

import 'property.dart';

class Reservation {
  int? id;
  Property? property;
  String? dateDebut;
  String? dateFin;
  String? method;
  int? amount;
  String? phone;
  String? otp;
  int? status;
  String? createdAt;
  String? updatedAt;

  Reservation(
      {this.id,
        this.property,
        this.dateDebut,
        this.dateFin,
        this.method,
        this.amount,
        this.phone,
        this.otp,
        this.status,
        this.createdAt,
        this.updatedAt});

  Reservation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    property = json['property'] != null
        ? new Property.fromJson(json['property'])
        : null;
    dateDebut = json['date_debut'];
    dateFin = json['date_fin'];
    method = json['method'];
    amount = json['amount'];
    phone = json['phone'];
    otp = json['otp'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (property != null) {
      data['property'] = property!.toJson();
    }
    data['date_debut'] = dateDebut;
    data['date_fin'] = dateFin;
    data['method'] = method;
    data['amount'] = amount;
    data['phone'] = phone;
    data['otp'] = otp;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
