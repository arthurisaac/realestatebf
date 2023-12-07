class User {
  int? id;
  String? name;
  String? nom;
  String? prenom;
  String? email;
  String? phone;
  //String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.nom,
        this.prenom,
        this.email,
        this.phone,
        //this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nom = json['nom'];
    prenom = json['prenom'];
    email = json['email'];
    phone = json['phone'];
    //emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['email'] = email;
    //data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
