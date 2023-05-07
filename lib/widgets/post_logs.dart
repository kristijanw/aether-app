import 'dart:convert';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/models/post_log.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class PostLogs extends StatefulWidget {
  PostLogs({super.key, required this.post, required this.roleName});

  Post post;
  String roleName;

  @override
  State<PostLogs> createState() => _PostLogsState();
}

class _PostLogsState extends State<PostLogs> {
  List postLogs = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  loadAllPostLogs() async {
    ApiResponse response = await getAllPostLogs(widget.post.id.toString());

    if (response.error == null) {
      final data = jsonEncode(response.data);
      final responseJson = jsonDecode(data)['postLogs'];

      setState(() {
        postLogs = responseJson;
      });
    }
  }

  void createLog() async {
    Map<String, String> createDataPost = {
      'title': titleController.text,
      'body': bodyController.text,
    };

    ApiResponse response = await createPostLog(
      createDataPost,
      widget.post.id.toString(),
    );

    if (response.error == null) {
      if (!mounted) return;
      statusMessage('Uspješno kreirano', context, 'success');
      setState(() {
        titleController.text = '';
        bodyController.text = '';
      });
      loadAllPostLogs();
    } else if (response.error == unauthorized) {
      logout().then(
        (value) => {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
            (route) => false,
          )
        },
      );
    } else {
      if (!mounted) return;
      statusMessage('${response.error}', context, 'error');
    }
  }

  void deleteLog(String id) async {
    ApiResponse response = await deletePostLog(id);

    if (response.error == null) {
      if (!mounted) return;
      statusMessage('Uspješno obrisano', context, 'success');
      loadAllPostLogs();
    } else if (response.error == unauthorized) {
      logout().then(
        (value) => {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const Login(),
            ),
            (route) => false,
          )
        },
      );
    } else {
      if (!mounted) return;
      statusMessage('${response.error}', context, 'error');
    }
  }

  createLogDialog() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Novi zapis',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      validator: (val) =>
                          val!.isEmpty ? 'Naziv je obavezan' : null,
                      decoration: const InputDecoration(
                        hintText: "Naziv",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: bodyController,
                      validator: (val) =>
                          val!.isEmpty ? 'Opis je obavezan' : null,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "Opis",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Ink(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(80.0),
                            ),
                          ),
                          child: Text(
                            'Odustani',
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          createLog();
                        },
                        child: Ink(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(
                              Radius.circular(80.0),
                            ),
                          ),
                          child: Text(
                            'Dodaj',
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadAllPostLogs();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Zapisi za servis',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (widget.roleName == 'admin' ||
                widget.roleName == 'serviser') ...{
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  minimumSize: const Size(50, 25),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () => createLogDialog(),
                child: Text(
                  'Dodaj',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.04,
                    ),
                  ),
                ),
              ),
            },
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        if (postLogs.isEmpty) ...{
          const Center(
            child: Text('Trenutno nema zapisa'),
          ),
        },
        if (postLogs.isNotEmpty) ...{
          SizedBox(
            height: size.height * 0.35,
            child: ListView(
              children: postLogs.map((element) {
                PostLog postLog = PostLog.fromJson(element);

                return Container(
                  padding: EdgeInsets.all(size.width * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${postLog.title}',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.width * 0.035,
                                ),
                              ),
                            ),
                          ),
                          if (widget.roleName == 'admin' ||
                              widget.roleName == 'serviser') ...{
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                minimumSize: const Size(50, 25),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft,
                              ),
                              onPressed: () => deleteLog(postLog.id.toString()),
                              child: Text(
                                'obriši',
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width * 0.03,
                                  ),
                                ),
                              ),
                            ),
                          },
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Wrap(
                        children: [
                          Text(
                            '${postLog.body}',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: size.width * 0.03,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.access_alarm_outlined,
                            size: size.width * 0.04,
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          Text(
                            '${postLog.createdAt}',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: size.width * 0.03,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        },
      ],
    );
  }
}
