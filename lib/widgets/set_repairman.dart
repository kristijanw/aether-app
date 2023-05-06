import 'dart:convert';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SetRepairMan extends StatefulWidget {
  SetRepairMan({super.key, required this.postid, required this.post});

  String postid;
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
      'postid': widget.postid,
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

    setState(() {
      serviserValue = listServiser.first['name'];
      serviserIDValue = listServiser.first['id'];
    });
  }

  @override
  void initState() {
    super.initState();
    getRepairMansAll();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        children: [
          if (listServiser.isNotEmpty) ...{
            Container(
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
            SizedBox(
              height: size.height * 0.02,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
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
            ),
          },
        ],
      ),
    );
    ;
  }
}
