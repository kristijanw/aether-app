import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/post_card.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyList extends StatefulWidget {
  const MyList({super.key});

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;
  String sortByStatus = '';
  String sortByPriority = '';

  // get all posts
  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();

    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () => retrievePosts(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    children: [
                      WidgetTitle(title: 'Popis servisa'),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          sortButton('Aktivno', 'aktivno', 'status'),
                          const SizedBox(width: 10),
                          sortButton('Čekanje', 'cekanje', 'status'),
                          const SizedBox(width: 10),
                          sortButton('Gotovo', 'gotovo', 'status'),
                        ],
                      ),
                      Row(
                        children: [
                          sortButton('Visok', 'visoka', 'priority'),
                          const SizedBox(width: 10),
                          sortButton('Srednji', 'srednja', 'priority'),
                          const SizedBox(width: 10),
                          sortButton('Niski', 'niska', 'priority'),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: _postList.where((element) {
                          Post post = element;

                          if (sortByStatus != '' && sortByPriority != '') {
                            if (post.status!.statusName == sortByStatus &&
                                post.priority.toString() == sortByPriority) {
                              return true;
                            } else {
                              return false;
                            }
                          } else if (sortByStatus != '') {
                            if (post.status!.statusName == sortByStatus) {
                              return true;
                            } else {
                              return false;
                            }
                          } else if (sortByPriority != '') {
                            if (post.priority.toString() == sortByPriority) {
                              return true;
                            } else {
                              return false;
                            }
                          }

                          return true;
                        }).map((item) {
                          Post post = item;

                          // return ListPost(post: post, allPosts: true);
                          return PostCard(post: post);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  TextButton sortButton(String title, String value, String purpose) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => sortByStatus == value || sortByPriority == value
              ? primaryColor
              : Colors.transparent,
        ),
        padding: MaterialStateProperty.resolveWith(
          (states) => const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        ),
        side: MaterialStateProperty.resolveWith<BorderSide>(
          (states) => const BorderSide(
            color: primaryColor,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      onPressed: () {
        if (purpose == 'status') {
          setState(() {
            sortByStatus = sortByStatus == value ? '' : value;
          });
        }

        if (purpose == 'priority') {
          setState(() {
            sortByPriority = sortByPriority == value ? '' : value;
          });
        }
      },
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            color: sortByStatus == value || sortByPriority == value
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
