import 'dart:convert';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/post_form_admin.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/widget_post.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int userId = 0;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();

  loadPreviousEvents() async {
    await initializeDateFormatting();
    ApiResponse response = await getPosts();

    if (response.error == null) {
      final postList = response.data as List<dynamic>;

      for (var element in postList) {
        Post post = element;

        if (post.arrival != null) {
          final opis = post.body;
          final naziv = post.title;
          final dateFormat = DateFormat("yyyy-MM-dd");
          final date = dateFormat.format(
            DateFormat("dd.MM.yyyy").parse(post.arrival.toString()),
          );
          final event = {"opis": opis, "naziv": naziv};

          if (mySelectedEvents.containsKey(date)) {
            mySelectedEvents[date]!.add(event);
          } else {
            mySelectedEvents[date] = [event];
          }
        }
      }

      setState(() {
        mySelectedEvents = mySelectedEvents;
      });
    }
  }

  List _listOfDayServis(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.70,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Novi servis',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  PostFormAdmin(selectedDate: _selectedDate),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white,
                          ),
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => const Color.fromRGBO(196, 0, 117, 1),
                          ),
                          padding: MaterialStateProperty.resolveWith(
                            (states) =>
                                const EdgeInsets.symmetric(vertical: 15),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: const Text('Odustani'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
    loadPreviousEvents();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.only(left: 10, right: 10),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft,
              ),
              onPressed: () => _showAddEventDialog(),
              child: Text(
                'Dodaj novi servis',
                style: GoogleFonts.rubik(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          TableCalendar(
            locale: 'hr_HR',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDate, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
            eventLoader: _listOfDayServis,
          ),
          const Divider(
            height: 30,
            color: primaryColor,
          ),
          SizedBox(
            height: size.height * 0.30,
            child: ListView(
              children: _listOfDayServis(_selectedDate!).map((servis) {
                return ListTile(
                  leading: const Icon(
                    Icons.done,
                    color: primaryColor,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Naziv:   ${servis['naziv']}'),
                  ),
                  subtitle: Text(
                    'Opis:   ${servis['opis']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
