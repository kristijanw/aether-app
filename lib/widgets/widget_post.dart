import 'package:app/constant.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/post_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListPost extends StatefulWidget {
  ListPost({super.key, required this.post, this.allPosts});

  Post post;
  bool? allPosts = false;

  @override
  State<ListPost> createState() => _ListPostState();
}

class _ListPostState extends State<ListPost> {
  Color statusColor = Colors.black;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width / 1.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: primaryColor),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PostView(post: widget.post),
              maintainState: false,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${widget.post.title}',
                      maxLines: widget.allPosts == true ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  if (widget.allPosts != true) ...{
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
                  }
                ],
              ),
              if (widget.allPosts == true) ...{
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
              },
              const SizedBox(
                height: 5,
              ),
              Text(
                '${widget.post.body}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.rubik(),
              ),
              const SizedBox(
                height: 10,
              ),
              if (widget.allPosts == true) ...{
                Wrap(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: primaryColor,
                          size: 15.0,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${widget.post.createdAt}',
                          style: GoogleFonts.rubik(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: primaryColor,
                          size: 15.0,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${widget.post.user!.name}',
                          style: GoogleFonts.rubik(),
                        ),
                      ],
                    ),
                  ],
                ),
              } else ...{
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: primaryColor,
                          size: 15.0,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${widget.post.createdAt}',
                          style: GoogleFonts.rubik(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: primaryColor,
                          size: 15.0,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${widget.post.user!.name}',
                          style: GoogleFonts.rubik(),
                        ),
                      ],
                    ),
                  ],
                ),
              }
            ],
          ),
        ),
      ),
    );
    ;
  }
}
