class Status {
  int? id;
  String? statusName;
  int? postId;
  String? createdAt;
  String? updatedAt;

  Status({
    this.id,
    this.statusName,
    this.postId,
    this.createdAt,
    this.updatedAt,
  });

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statusName = json['status_name'];
    postId = json['post_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status_name'] = statusName;
    data['post_id'] = postId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
