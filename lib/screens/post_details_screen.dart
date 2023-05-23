import 'package:app/constant.dart';
import 'package:app/models/post.dart';
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
  PostView({super.key, required this.post});

  Post post;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  String roleName = '';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
              ContentSinglePost(post: widget.post),
              SizedBox(
                height: size.height * 0.02,
              ),
              if (roleName == 'admin' || roleName == 'serviser') ...{
                const Divider(
                  height: 2,
                  color: primaryColor,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SetDateTime(
                  postid: widget.post.id.toString(),
                  post: widget.post,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SetRepairMan(
                  post: widget.post,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                ChangeStatus(
                  post: widget.post,
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
              },
              PostLogs(
                post: widget.post,
                roleName: roleName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
