class Pictures {
  int? id;
  int? property;
  String? image;
  String? createdAt;
  String? updatedAt;

  Pictures(
      {this.id, this.property, this.image, this.createdAt, this.updatedAt});

  Pictures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    property = json['property'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['property'] = property;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}