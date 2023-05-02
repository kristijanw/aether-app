import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/user.dart';
import 'package:app/screens/admin/admin_screen.dart';
import 'package:app/screens/doctor/doctor_screen_home.dart';
import 'package:app/screens/post_form_admin.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool _loading = true;
  User? user;
  DateTime? _selectedDate;

  void closeDialog() {
    Navigator.pop(context);
  }

  _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.70,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Novi servis',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  PostFormAdmin(
                    selectedDate: _selectedDate,
                    closeDialog: closeDialog,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Ink(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(80.0),
                            ),
                          ),
                          child: Text(
                            'Odustani',
                            style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  void updateSelectedDate(choiseDay) {
    _selectedDate = choiseDay;
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _loading
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
            child: SizedBox(
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
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        if (user!.role != 'korisnik') ...{
                          TextButton(
                            onPressed: () => _showAddEventDialog(),
                            child: Ink(
                              width: size.width * 0.30,
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.01,
                                vertical: 10,
                              ),
                              decoration: const BoxDecoration(
                                gradient: linearGradient,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(80.0),
                                ),
                              ),
                              child: Text(
                                'Dodaj servis',
                                style: GoogleFonts.rubik(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        }
                      ],
                    ),
                    if (user!.role != 'admin') ...{
                      DoctorScreen(),
                    },
                    if (user!.role != 'korisnik') ...{
                      AdminScreen(
                        setDate: updateSelectedDate,
                      ),
                    }
                  ],
                ),
              ),
            ),
          );
  }
}
