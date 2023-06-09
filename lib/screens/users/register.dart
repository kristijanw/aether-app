import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/user.dart';
import 'package:app/screens/bottom_navigation.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  void _registerUser() async {
    Map<String, dynamic> dataPost = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'password_confirmation': passwordConfirmController.text,
    };

    ApiResponse response = await register(dataPost);

    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
    }
  }

  // Save and redirect to home
  void _saveAndRedirectToHome(User user) async {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
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
                height: 30,
              ),
              WidgetTitle(title: 'Registracija'),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (val) =>
                            val!.isEmpty ? 'Polje je obavezno' : null,
                        decoration: kInputDecoration('Ime i prezime'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) =>
                            val!.isEmpty ? 'Polje je obavezno' : null,
                        decoration: kInputDecoration('Email'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'Potrebno najmanje 6 znakova'
                            : null,
                        decoration: kInputDecoration('Lozinka'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordConfirmController,
                        obscureText: true,
                        validator: (val) => val != passwordController.text
                            ? 'Lozinka se ne podudara'
                            : null,
                        decoration: kInputDecoration('Potvrdi lozinku'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      loading
                          ? const Center(child: CircularProgressIndicator())
                          : kTextButton(
                              'Registracija',
                              () {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = !loading;
                                    _registerUser();
                                  });
                                }
                              },
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      kLoginRegisterHint('Već imate račun? ', 'Prijava', () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const Login(),
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
