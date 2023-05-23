import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/user.dart';
import 'package:app/screens/bottom_navigation.dart';
import 'package:app/screens/users/register.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);

    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setString('role', user.role ?? '');
    await pref.setInt('userId', user.id ?? 0);
    await pref.setString('userName', user.name ?? '');

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const BottomNavigation()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/logo.svg',
                width: 100,
              ),
              const SizedBox(
                height: 40,
              ),
              WidgetTitle(title: 'Prijava'),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: Form(
                  key: formkey,
                  child: ListView(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: txtEmail,
                        validator: (val) =>
                            val!.isEmpty ? 'Nevažeća adresa e-pošte' : null,
                        decoration: kInputDecoration('Email'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: txtPassword,
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'Potrebno najmanje 6 znakova'
                            : null,
                        decoration: kInputDecoration('Lozinka'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      loading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : kTextButton(
                              'Prijava',
                              () {
                                if (formkey.currentState!.validate()) {
                                  setState(
                                    () {
                                      loading = true;
                                      _loginUser();
                                    },
                                  );
                                }
                              },
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      kLoginRegisterHint('Nemate račun? ', 'Registracija', () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                          (route) => false,
                        );
                      })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
