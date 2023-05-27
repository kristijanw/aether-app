import 'package:app/constant.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FullImage extends StatelessWidget {
  FullImage({
    super.key,
    required this.imageUrl,
  });

  String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetTitle(title: 'Pregled slike'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
