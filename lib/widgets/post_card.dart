import 'package:app/constant.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/post_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostCard extends StatelessWidget {
  PostCard({super.key, required this.post});

  Post post;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(0.0),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${post.title}',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: priorityBgColor(post.priority.toString()),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      size: size.width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: size.width * 0.05,
                        ),
                        Text(
                          '${post.user!.name}',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: size.width * 0.03,
                            ),
                          ),
                        ),
                      ],
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
                      style: GoogleFonts.montserrat(
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
              if (post.arrival != null || post.time != null) ...{
                SizedBox(
                  height: size.height * 0.02,
                ),
              },
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (post.arrival != null) ...{
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range_outlined,
                          size: 20,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text(
                          '${post.arrival}',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  },
                  if (post.time != null) ...{
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 20,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text(
                          '${post.time}',
                          textAlign: TextAlign.end,
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  },
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
