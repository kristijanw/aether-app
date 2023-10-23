import 'dart:convert';

import 'package:app/constant.dart';
import 'package:app/models/post.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/change_status.dart';
import 'package:app/widgets/content_single_post.dart';
import 'package:app/widgets/post_logs.dart';
import 'package:app/widgets/set_datetime.dart';
import 'package:app/widgets/set_repairman.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PostView extends StatefulWidget {
  PostView({super.key, required this.postID});

  int? postID;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  String roleName = '';
  bool loading = false;
  List dataJson = [];

  Future getPostByID() async {
    final response = await getPostByIDServices(widget.postID ?? 0);
    final data = jsonEncode(response.data);
    final responseJson = jsonDecode(data)['post'];

    setState(() {
      dataJson = responseJson;
    });
  }

  Future getRoleName() async {
    final role = await getRole();

    if (role != '') {
      setState(() {
        roleName = role;
      });
    }
  }

  @override
  void initState() {
    getRoleName();
    getPostByID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (dataJson.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      Post post = Post.fromJson(dataJson[0]);

      return Scaffold(
        appBar: AppBar(
          title: WidgetTitle(title: 'Detalji servisa'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentSinglePost(post: post),
                SizedBox(
                  height: size.height * 0.02,
                ),
                if (roleName == 'admin') ...{
                  const Divider(
                    height: 2,
                    color: primaryColor,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  SetDateTime(
                    postid: post.id.toString(),
                    post: post,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  SetRepairMan(
                    post: post,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  ChangeStatus(
                    post: post,
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                },
                PostLogs(
                  post: post,
                  roleName: roleName,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
