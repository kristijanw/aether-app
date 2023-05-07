import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewUser extends StatefulWidget {
  NewUser({
    super.key,
    required this.roleName,
  });

  String roleName;

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  List<String> roleList = [
    'korisnik',
    'serviser',
    'admin',
  ];

  void registerUser() async {
    Map<String, dynamic> dataPost = {
      'name': nameController.text,
      'email': emailController.text,
      'role': roleController.text,
      'password': passwordController.text,
      'password_confirmation': passwordConfirmController.text,
    };

    ApiResponse response = await registerNewUser(dataPost);

    if (response.error == null) {
      if (!mounted) return;
      setState(() {
        nameController.text = '';
        emailController.text = '';
        passwordController.text = '';
        passwordConfirmController.text = '';
      });
      statusMessage('Uspješno kreirano', context, 'success');
    } else {
      if (!mounted) return;
      statusMessage('${response.error}', context, 'error');
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.roleName == 'admin') {
      roleController.text = roleList.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Registriraj novog korisnika',
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                validator: (val) => val!.isEmpty ? 'Polje je obavezno' : null,
                decoration: kInputDecoration('Ime i prezime'),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val!.isEmpty ? 'Polje je obavezno' : null,
                decoration: kInputDecoration('Email'),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              DropdownButtonFormField(
                value: roleController.text,
                hint: const Text(
                  'odaberi',
                ),
                isExpanded: true,
                decoration: kInputDecoration('Rola'),
                onChanged: (value) {
                  setState(() {
                    roleController.text = value.toString();
                  });
                },
                onSaved: (value) {
                  setState(() {
                    roleController.text = value.toString();
                  });
                },
                items: roleList.map((String val) {
                  return DropdownMenuItem(
                    value: val,
                    child: Text(
                      val,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Potrebno najmanje 6 znakova' : null,
                decoration: kInputDecoration('Lozinka'),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              TextFormField(
                controller: passwordConfirmController,
                obscureText: true,
                validator: (val) => val != passwordController.text
                    ? 'Lozinka se ne podudara'
                    : null,
                decoration: kInputDecoration('Potvrdi lozinku'),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              kTextButton(
                'Registracija',
                () {
                  if (formKey.currentState!.validate()) {
                    registerUser();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
