import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SetDateTime extends StatefulWidget {
  SetDateTime({super.key, required this.postid, required this.post});

  String postid;
  Post post;

  @override
  State<SetDateTime> createState() => _SetDateTimeState();
}

class _SetDateTimeState extends State<SetDateTime> {
  late String _hour, _minute, _time;
  late String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            DateFormat('dd.M.yyyy').format(selectedDate).toString();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '$_hour : $_minute';
        timeController.text = _time;
        timeController.text = formatDate(
            DateTime(2023, 01, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " "]).toString();
      });
    }
  }

  void setControllerData() {
    if (widget.post.arrival != null) {
      setState(() {
        dateController.text = widget.post.arrival.toString();
      });
    }

    if (widget.post.time != null) {
      setState(() {
        timeController.text = widget.post.time.toString();
      });
    }
  }

  void onSaveDateTime() async {
    Map<String, String> createDataPost = {
      'postid': widget.postid,
      'arrival': dateController.text,
      'time': timeController.text,
    };

    ApiResponse response = await updateDateAndTime(createDataPost);

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

  @override
  void initState() {
    super.initState();
    setControllerData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  width: size.width / 2.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryColor),
                  ),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: dateController,
                    onSaved: (val) {},
                    decoration: const InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.only(top: 0),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _selectTime(context);
                },
                child: Container(
                  width: size.width / 2.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryColor),
                  ),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    onSaved: (val) {},
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: timeController,
                    decoration: const InputDecoration(
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(5),
                    ),
                  ),
                ),
              ),
            ],
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
              onPressed: () => onSaveDateTime(),
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
      ],
    );
  }
}
