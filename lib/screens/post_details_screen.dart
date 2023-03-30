import 'package:app/constant.dart';
import 'package:app/models/post.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostView extends StatefulWidget {
  PostView({super.key, required this.post});

  Post post;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetTitle(title: 'Detalji servisa'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Text(
                  '${widget.post.title}',
                  style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Status servisa',
                  style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: bgColorStatus(
                      widget.post.status!.statusName.toString(),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${widget.post.status!.statusName}',
                    style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                        color: txtColorStatus(
                          widget.post.status!.statusName.toString(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            if (widget.post.repairman != null) ...{
              Text('Servis preuzeo: ${widget.post.repairman!.name}'),
            },
          ],
        ),
      ),
    );
  }
}
