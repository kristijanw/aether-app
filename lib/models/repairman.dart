class Repairman {
  int? id;
  String? name;
  String? email;

  Repairman({
    this.id,
    this.name,
    this.email,
  });

  // function to convert json data to user model
  factory Repairman.fromJson(Map<String, dynamic> json) {
    return Repairman(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
