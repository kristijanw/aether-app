import 'dart:convert';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/widgets/post_card.dart';
import 'package:flutter/material.dart';
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
      final data = jsonEncode(response.data);
      final responseJson = jsonDecode(data)['posts'];

      for (var element in responseJson) {
        final elementItem = element;
        Post post = Post.fromJson(elementItem);

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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: TableCalendar(
            locale: 'hr_HR',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
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
        ),
        const Divider(
          height: 30,
          color: Colors.black,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ..._listOfDayServis(_selectedDate!).map((value) {
                Post post = value;
                return Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  width: size.width * 0.95,
                  child: PostCard(post: post),
                );
              })
            ],
          ),
        ),
      ],
    );
  }
}
