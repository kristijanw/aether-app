class User {
  int? id;
  String? name;
  String? email;
  String? role;
  String? nameCompany;
  String? address;
  String? contact;
  String? token;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.nameCompany,
    this.address,
    this.contact,
    this.token,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    nameCompany = json['nameCompany'];
    address = json['address'];
    contact = json['contact'];
    token = json['token'];
  }

  User.fromJsonLogin(Map<String, dynamic> json) {
    id = json['user']['id'];
    name = json['user']['name'];
    email = json['user']['email'];
    role = json['user']['role'];
    nameCompany = json['user']['nameCompany'];
    address = json['user']['address'];
    contact = json['user']['contact'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['nameCompany'] = nameCompany;
    data['address'] = address;
    data['contact'] = contact;
    return data;
  }
}
