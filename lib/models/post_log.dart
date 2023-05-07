class PostLog {
  int? id;
  String? title;
  String? body;
  String? createdAt;
  int? postId;

  PostLog({this.id, this.title, this.body, this.createdAt, this.postId});

  PostLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    createdAt = json['created_at'];
    postId = json['post_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['created_at'] = createdAt;
    data['post_id'] = postId;
    return data;
  }
}
