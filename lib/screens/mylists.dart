import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/widget_post.dart';
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            WidgetTitle(title: 'Moja lista'),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Sortiranje',
                  style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                sortButton('Aktivno', 'aktivno'),
                const SizedBox(width: 10),
                sortButton('Čekanje', 'cekanje'),
                const SizedBox(width: 10),
                sortButton('Gotovo', 'gotovo'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.only(bottom: 50),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                children: _postList.where((element) {
                  if (sortByStatus != '') {
                    Post post = element;

                    if (post.status!.statusName == sortByStatus) {
                      return true;
                    } else {
                      return false;
                    }
                  } else {
                    return true;
                  }
                }).map((item) {
                  Post post = item;

                  return ListPost(post: post, allPosts: true);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextButton sortButton(String title, String value) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => sortByStatus == value ? primaryColor : Colors.transparent,
        ),
        padding: MaterialStateProperty.resolveWith(
          (states) => const EdgeInsets.symmetric(vertical: 10),
        ),
        side: MaterialStateProperty.resolveWith<BorderSide>(
          (states) => const BorderSide(
            color: primaryColor,
          ),
        ),
      ),
      onPressed: () {
        setState(() {
          sortByStatus = sortByStatus == value ? '' : value;
        });
      },
      child: Text(
        title,
        style: GoogleFonts.rubik(
          textStyle: TextStyle(
            color: sortByStatus == value ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
