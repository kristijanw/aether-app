import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/notification.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ChangeStatus extends StatefulWidget {
  ChangeStatus({super.key, required this.post});

  Post post;

  @override
  State<ChangeStatus> createState() => _ChangeStatusState();
}

class _ChangeStatusState extends State<ChangeStatus> {
  List<String> priority = <String>[
    'odaberi status',
    'cekanje',
    'aktivno',
    'gotovo',
  ];
  late String priorityValue;
  bool changedStatus = false;

  void pushNotificationStatus() async {
    Map<String, String> createDataPost = {
      'userId': widget.post.user!.id.toString(),
      'title': 'Ažuriranje servisa',
      'body': 'Ažuriran status servisa.',
    };

    ApiResponse response = await pushNotificationUpdatePost(createDataPost);

    if (response.error == null) {
      // ignore: avoid_print
      print('Notifikacija uspješno poslana.');
    } else {
      // ignore: avoid_print
      print(response.error);
      // ignore: avoid_print
      print('greška');
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.post.status != null) {
      priorityValue = widget.post.status!.statusName.toString();
    } else {
      priorityValue = priority.first;
    }
  }

  void onSaveRepairman() async {
    Map<String, String> createDataPost = {
      'postid': widget.post.id.toString(),
      'new_status': priorityValue,
    };

    ApiResponse response = await updateStatus(createDataPost);

    if (response.error == null) {
      if (!mounted) return;
      statusMessage('Uspješno ažurirano', context, 'success');
      pushNotificationStatus();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promijeni status',
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
                  value: priorityValue,
                  hint: const Text(
                    'važnost servisa',
                  ),
                  isExpanded: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(
                      10,
                    ),
                    focusedBorder: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      changedStatus = true;
                      priorityValue = value.toString();
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      priorityValue = value.toString();
                    });
                  },
                  validator: (String? value) {
                    if (value.toString().isEmpty ||
                        value.toString() == 'važnost servisa') {
                      return "Važnost mora biti odabrana";
                    } else {
                      return null;
                    }
                  },
                  items: priority.map((String val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val,
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
          ],
        ),
        if (changedStatus) ...{
          Text(
            'Obavezno spremiti izmjenu',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        },
      ],
    );
  }
}
