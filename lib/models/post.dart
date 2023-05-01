import 'package:app/models/repairman.dart';
import 'package:app/models/status.dart';
import 'package:app/models/user.dart';

class Post {
  int? id;
  int? userId;
  int? userServisId;
  String? title;
  String? body;
  String? nameDevice;
  int? guarantee;
  int? sort;
  String? arrival;
  String? image;
  String? updatedAt;
  String? createdAt;
  User? user;
  Repairman? repairman;
  Status? status;

  Post({
    this.id,
    this.userId,
    this.userServisId,
    this.title,
    this.body,
    this.nameDevice,
    this.guarantee,
    this.sort,
    this.arrival,
    this.image,
    this.updatedAt,
    this.createdAt,
    this.user,
    this.repairman,
    this.status,
  });

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userServisId = json['user_servis_id'];
    title = json['title'];
    body = json['body'];
    nameDevice = json['name_device'];
    guarantee = json['guarantee'];
    sort = json['sort'];
    arrival = json['arrival'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    repairman = json['repairman'] != null
        ? Repairman.fromJson(json['repairman'])
        : null;
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_servis_id'] = userServisId;
    data['title'] = title;
    data['body'] = body;
    data['name_device'] = nameDevice;
    data['guarantee'] = guarantee;
    data['sort'] = sort;
    data['arrival'] = arrival;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (repairman != null) {
      data['repairman'] = repairman!.toJson();
    }
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}
