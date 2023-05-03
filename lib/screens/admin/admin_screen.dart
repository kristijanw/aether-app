import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/post_details_screen.dart';
import 'package:app/services/posts_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

// ignore: must_be_immutable
class AdminScreen extends StatefulWidget {
  AdminScreen({super.key, this.setDate});

  Function? setDate;

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
          final dateFormat = DateFormat("yyyy-MM-dd");
          final date = dateFormat.format(
            DateFormat("dd.MM.yyyy").parse(post.arrival.toString()),
          );
          final event = post;

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

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
    widget.setDate!(_selectedDate);
    loadPreviousEvents();
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
          TableCalendar(
            locale: 'hr_HR',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            calendarFormat: _calendarFormat,
            rowHeight: 40,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Color.fromARGB(255, 213, 124, 181),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(123, 0, 0, 0),
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDate, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });

                widget.setDate!(_selectedDate);
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
              _focusedDay = focusedDay;
            },
            eventLoader: _listOfDayServis,
          ),
          const Divider(
            height: 30,
            color: Colors.black,
          ),
          SizedBox(
            height: size.height * 0.35,
            child: ListView(
              children: _listOfDayServis(_selectedDate!).map((servis) {
                Post post = servis;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PostView(post: post),
                          maintainState: false,
                        ),
                      );
                    },
                    child: Container(
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
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${post.title}',
                                style: GoogleFonts.rubik(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                '${post.arrival}',
                                style: GoogleFonts.rubik(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                post.repairman != null
                                    ? '${post.repairman!.name}'
                                    : 'Serviser nije odabran',
                                style: GoogleFonts.rubik(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: bgColorStatus(
                                    post.status!.statusName.toString(),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  '${post.status!.statusName}',
                                  style: GoogleFonts.rubik(
                                    textStyle: TextStyle(
                                      color: txtColorStatus(
                                        post.status!.statusName.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
