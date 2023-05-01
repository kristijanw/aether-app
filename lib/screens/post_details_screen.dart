import 'dart:io';

import 'package:app/constant.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/admin/admin_screen.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: WidgetTitle(title: 'Detalji servisa'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Text(
                    '${widget.post.title}',
                    style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: bgColorStatus(
                        widget.post.status!.statusName.toString(),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${widget.post.status!.statusName}',
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          color: txtColorStatus(
                            widget.post.status!.statusName.toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${widget.post.user!.name}'.toUpperCase(),
                    style: GoogleFonts.rubik(),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              if (widget.post.repairman != null) ...{
                Row(
                  children: [
                    Text(
                      'Servis preuzeo:',
                      style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${widget.post.repairman!.name}',
                      style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              },
              if (widget.post.repairman != null) ...{
                Row(
                  children: [
                    Text(
                      'Datum početka popravka:',
                      style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${widget.post.arrival}',
                      style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              },
              Row(
                children: [
                  Text(
                    'Garancija:',
                    style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.post.guarantee == 1 ? 'Ima' : 'Nema',
                    style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    'Uređaj:',
                    style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${widget.post.nameDevice}',
                    style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Opis:',
                style: GoogleFonts.rubik(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Wrap(
                children: [
                  Text(
                    '${widget.post.body}',
                    style: GoogleFonts.rubik(),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Slika:',
                style: GoogleFonts.rubik(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // ignore: dead_code
              if (widget.post.image != null) ...{
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('${widget.post.image}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              } else ...{
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.black38,
                    ),
                  ),
                ),
              },
              const SizedBox(
                height: 20,
              ),
              if (roleName == 'admin') ...{
                const Divider(
                  height: 2,
                  color: primaryColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Postavi datum i vrijeme',
                  style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
