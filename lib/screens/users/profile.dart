import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/user.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/new_user.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController namelastnameController = TextEditingController();
  TextEditingController nameCompanyController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  // get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        namelastnameController.text = user!.name ?? '';
        nameCompanyController.text = user!.nameCompany ?? '';
        addressController.text = user!.address ?? '';
        contactController.text = user!.contact ?? '';
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
      statusMessage('${response.error}', context, 'error');
    }
  }

  //update profile
  void updateProfile() async {
    Map<String, String> userData = {
      'id': user!.id.toString(),
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
      getUser();
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

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetTitle(title: 'Moj Profil'),
                      IconButton(
                        icon: const Icon(
                          Icons.exit_to_app,
                          size: 35.0,
                        ),
                        onPressed: () {
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
                        },
                      ),
                    ],
                  ),
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
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  if (user!.role == 'admin') ...{
                    NewUser(
                      roleName: user!.role.toString(),
                    ),
                  },
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                ],
              ),
            ),
          );
  }
}
