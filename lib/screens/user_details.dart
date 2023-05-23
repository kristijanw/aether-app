import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/user.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetailsScreen extends StatefulWidget {
  UserDetailsScreen({super.key, required this.user});

  User user;

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController namelastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameCompanyController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  //update profile
  void updateProfile() async {
    Map<String, String> userData = {
      'id': widget.user.id.toString(),
      'name': namelastnameController.text,
      'nameCompany': nameCompanyController.text,
      'address': addressController.text,
      'contact': contactController.text,
    };

    ApiResponse response = await updateUser(userData);
    setState(() {
      loading = false;
    });

    if (response.error == null) {
      if (!mounted) return;
      statusMessage('Uspješno ažurirano', context, 'success');
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
      statusMessage('${response.error}', context, 'error');
    }
  }

  // get user detail
  void getUser() async {
    setState(() {
      User user = widget.user;
      loading = false;
      namelastnameController.text = user.name ?? '';
      emailController.text = user.email ?? '';
      nameCompanyController.text = user.nameCompany ?? '';
      addressController.text = user.address ?? '';
      contactController.text = user.contact ?? '';
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: WidgetTitle(title: 'Detalji korisnika'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: kInputDecoration('Ime i prezime'),
                      controller: namelastnameController,
                      validator: (val) => val!.isEmpty
                          ? 'Ovo polje ne smije biti prazno'
                          : null,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    TextFormField(
                      decoration: kInputDecoration('Email'),
                      controller: emailController,
                      validator: (val) => val!.isEmpty
                          ? 'Ovo polje ne smije biti prazno'
                          : null,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    TextFormField(
                      decoration: kInputDecoration('Ime tvrtke'),
                      controller: nameCompanyController,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    TextFormField(
                      decoration: kInputDecoration('Adresa'),
                      controller: addressController,
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    TextFormField(
                      decoration: kInputDecoration('Kontakt'),
                      controller: contactController,
                    ),
                  ],
                ),
              ),
              kTextButton(
                'Ažuriraj',
                () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    updateProfile();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
