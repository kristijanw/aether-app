import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetTitle extends StatelessWidget {
  WidgetTitle({super.key, required this.title});

  String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.genos(
        textStyle: const TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}
