import 'package:app/constant.dart';
import 'package:app/widgets/new_user.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';

class NewUserFromList extends StatefulWidget {
  const NewUserFromList({super.key});

  @override
  State<NewUserFromList> createState() => _NewUserFromListState();
}

class _NewUserFromListState extends State<NewUserFromList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetTitle(title: 'Novi korisnik'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              NewUser(),
            ],
          ),
        ),
      ),
    );
  }
}
