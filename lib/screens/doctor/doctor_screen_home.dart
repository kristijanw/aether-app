import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/post.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/widget_post.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorScreen extends StatefulWidget {
  DoctorScreen({super.key});

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

    if (response.error == null) {
      setState(() {
        if (status == 'cekanje') {
          _postListCekanje = response.data as List<dynamic>;
          _loading = _loading ? !_loading : _loading;
        }
        if (status == 'aktivno') {
          _postListAktivno = response.data as List<dynamic>;
          _loading = _loading ? !_loading : _loading;
        }
        if (status == 'gotovo') {
          _postListGotovo = response.data as List<dynamic>;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          'Aktivni servisi',
          style: GoogleFonts.rubik(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (_postListAktivno.isEmpty) ...{
          Text(
            'Trenutno nema aktivnih servisa',
            style: GoogleFonts.rubik(),
          ),
          const SizedBox(
            height: 20,
          ),
        } else ...{
          SizedBox(
            width: double.infinity,
            height: size.height / 6,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              itemCount:
                  _postListAktivno.length < 2 ? _postListAktivno.length : 2,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                Post post = _postListAktivno[index];

                return ListPost(post: post);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        },
        Text(
          'Servisi na čekanju',
          style: GoogleFonts.rubik(
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
            style: GoogleFonts.rubik(),
          ),
          const SizedBox(
            height: 20,
          ),
        } else ...{
          SizedBox(
            width: double.infinity,
            height: size.height / 6,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              itemCount:
                  _postListCekanje.length < 2 ? _postListCekanje.length : 2,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                Post post = _postListCekanje[index];

                return ListPost(post: post);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        },
        Text(
          'Gotovi servisi',
          style: GoogleFonts.rubik(
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
            style: GoogleFonts.rubik(),
          ),
        } else ...{
          SizedBox(
            width: double.infinity,
            height: size.height / 6,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount:
                  _postListGotovo.length < 2 ? _postListGotovo.length : 2,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                Post post = _postListGotovo[index];

                return ListPost(post: post);
              },
            ),
          ),
        },
        const SizedBox(height: 40),
      ],
    );
  }
}
