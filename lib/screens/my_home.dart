import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/user.dart';
import 'package:app/screens/admin/admin_screen.dart';
import 'package:app/screens/doctor/doctor_screen_home.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool _loading = true;
  User? user;

  // get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();

    if (response.error == null) {
      setState(() {
        user = response.data as User;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Dobrodošao ${user!.name}',
                                style: GoogleFonts.rubik(
                                  textStyle: const TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (user!.role != 'admin') ...{
                          DoctorScreen(),
                        },
                        if (user!.role != 'korisnik') ...{
                          const AdminScreen(),
                        }
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
