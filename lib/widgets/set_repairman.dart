import 'dart:convert';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class SetRepairMan extends StatefulWidget {
  SetRepairMan({super.key, required this.post});

  Post post;

  @override
  State<SetRepairMan> createState() => _SetRepairManState();
}

class _SetRepairManState extends State<SetRepairMan> {
  TextEditingController repairmanController = TextEditingController();
  List listServiser = [];
  late String serviserValue;
  late int serviserIDValue;

  void onSaveRepairman() async {
    Map<String, String> createDataPost = {
      'postid': widget.post.id.toString(),
      'user_servis_id': serviserIDValue.toString(),
    };

    ApiResponse response = await saveRepairMan(createDataPost);

    if (response.error == null) {
      if (!mounted) return;
      statusMessage('Uspješno ažurirano', context, 'success');
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

  void getRepairMansAll() async {
    ApiResponse response = await getRepairMan();
    final data = jsonEncode(response.data);
    Map<String, dynamic> responseJson = jsonDecode(data);
    final repairmans = responseJson['repairmans'];

    listServiser.add({
      "id": 0,
      "name": 'Odaberi servisera',
    });

    for (var repairman in repairmans) {
      listServiser.add({
        "id": repairman['id'],
        "name": repairman['name'],
      });
    }

    if (widget.post.repairman != null) {
      setState(() {
        serviserValue = widget.post.repairman!.name.toString();
        serviserIDValue = widget.post.repairman!.id!;
      });
    } else {
      setState(() {
        serviserValue = listServiser.first['name'];
        serviserIDValue = listServiser.first['id'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRepairMansAll();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Postavi servisera',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (listServiser.isNotEmpty) ...{
              Expanded(
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryColor),
                  ),
                  child: DropdownButtonFormField(
                    value: serviserValue,
                    hint: const Text(
                      'odaberi servisera',
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(
                        10,
                      ),
                      focusedBorder: InputBorder.none,
                    ),
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        serviserValue = value.toString();
                      });

                      for (var serviser in listServiser) {
                        if (serviserValue == serviser['name']) {
                          setState(() {
                            serviserIDValue = serviser['id'];
                          });
                        }
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        serviserValue = value.toString();
                      });

                      for (var serviser in listServiser) {
                        if (serviserValue == serviser['name']) {
                          setState(() {
                            serviserIDValue = serviser['id'];
                          });
                        }
                      }
                    },
                    items: listServiser.map((serviser) {
                      return DropdownMenuItem(
                        value: serviser['name'],
                        child: Text(
                          serviser['name'],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.30,
                child: TextButton(
                  onPressed: () => onSaveRepairman(),
                  child: Ink(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.01,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      gradient: linearGradient,
                      borderRadius: BorderRadius.all(
                        Radius.circular(80.0),
                      ),
                    ),
                    child: Text(
                      'Spremi',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            },
          ],
        ),
      ],
    );
    ;
  }
}
