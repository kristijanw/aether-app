import 'dart:convert';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  List<dynamic> _postListCekanje = [];
  List<dynamic> _postListAktivno = [];
  List<dynamic> _postListGotovo = [];
  bool _loading = true;

  // get posts by status
  Future<void> getPostsByStatus(String status) async {
    ApiResponse response = await getPostsStatus(status);
    final data = jsonEncode(response.data);
    final responseJson = jsonDecode(data)['posts'];

    if (response.error == null) {
      setState(() {
        if (status == 'cekanje') {
          _postListCekanje = responseJson;
          _loading = _loading ? !_loading : _loading;
        }
        if (status == 'aktivno') {
          _postListAktivno = responseJson;
          _loading = _loading ? !_loading : _loading;
        }
        if (status == 'gotovo') {
          _postListGotovo = responseJson;
          _loading = _loading ? !_loading : _loading;
        }
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
    getPostsByStatus('cekanje');
    getPostsByStatus('aktivno');
    getPostsByStatus('gotovo');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktivni servisi',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          if (_postListAktivno.isEmpty) ...{
            Text(
              'Trenutno nema aktivnih servisa',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          } else ...{
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._postListAktivno.map((value) {
                    Post post = Post.fromJson(value);
                    return Container(
                      padding: const EdgeInsets.all(10),
                      width: size.width * 0.70,
                      child: PostCard(post: post),
                    );
                  })
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          },
          Text(
            'Servisi na čekanju',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (_postListCekanje.isEmpty) ...{
            Text(
              'Trenutno nema servisa',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          } else ...{
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._postListCekanje.map((value) {
                    Post post = Post.fromJson(value);
                    return Container(
                      padding: const EdgeInsets.all(10),
                      width: size.width * 0.70,
                      child: PostCard(post: post),
                    );
                  })
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          },
          Text(
            'Gotovi servisi',
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (_postListGotovo.isEmpty) ...{
            Text(
              'Trenutno nema gotovih servisa',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          } else ...{
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._postListGotovo.map((value) {
                    Post post = Post.fromJson(value);
                    return Container(
                      padding: const EdgeInsets.all(10),
                      width: size.width * 0.70,
                      child: PostCard(post: post),
                    );
                  })
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          },
        ],
      ),
    );
  }
}
