import 'dart:developer';
import 'dart:io';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/screens/bottom_navigation.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/device.dart';
import 'package:app/services/notification.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget {
  const PostForm({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  final TextEditingController _txtControllerTitle = TextEditingController();
  final TextEditingController newDeviceController = TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();
  bool newDevice = false;
  List<String> list = <String>[
    'odaberi uređaj',
  ];
  late String dropdownValue;
  bool isChecked = false;
  String roleName = '';

  Future getImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void pushNotificationCreatePost() async {
    Map<String, String> createDataPost = {
      'title': 'Novi servis',
      'body': 'Novi servis je kreiran',
    };

    ApiResponse response = await pushNotificationsNewPost(createDataPost);

    if (response.error == null) {
      // ignore: avoid_print
      print('Notifikacija uspješno poslana.');
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const BottomNavigation(),
        ),
        (route) => false,
      );
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
        SnackBar(content: Text('${response.error}')),
      );
      setState(() {
        _loading = !_loading;
      });
    }
  }

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);

    Map<String, String> createDataPost = {
      'title': _txtControllerTitle.text,
      'body': _txtControllerBody.text,
      'image': image ?? '',
      'name_device': newDevice != true
          ? dropdownValue.toString()
          : newDeviceController.text,
      'guarantee': isChecked == true ? 'ima' : 'nema',
    };

    ApiResponse response = await createPost(createDataPost);

    if (response.error == null) {
      pushNotificationCreatePost();
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  Future getRoleName() async {
    final role = await getRole();

    if (role != '') {
      setState(() {
        roleName = role;
      });
    }
  }

  Future getDevices() async {
    ApiResponse response = await getAllDevices();

    log('TU SAM');
    log('$response');
  }

  @override
  void initState() {
    super.initState();
    getRoleName();
    getDevices();
    dropdownValue = list.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: WidgetTitle(title: 'Novi servis'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: _imageFile == null
                        ? null
                        : DecorationImage(
                            image: FileImage(_imageFile ?? File('')),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.black38,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _txtControllerTitle,
                          validator: (val) =>
                              val!.isEmpty ? 'Naziv je obavezan' : null,
                          decoration: const InputDecoration(
                            hintText: "Naziv",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black38,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField(
                          value: dropdownValue,
                          hint: const Text(
                            'odaberi',
                          ),
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black38,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.toString() == 'dodaj novi') {
                              setState(() {
                                newDevice = true;
                              });
                            } else {
                              setState(() {
                                newDevice = false;
                              });
                            }

                            setState(() {
                              dropdownValue = value.toString();
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              dropdownValue = value.toString();
                            });
                          },
                          validator: (String? value) {
                            if (value.toString().isEmpty ||
                                value.toString() == 'odaberi uređaj') {
                              return "Uređaj mora biti odabran";
                            } else {
                              return null;
                            }
                          },
                          items: list.map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(
                                val,
                              ),
                            );
                          }).toList(),
                        ),
                        if (newDevice == true) ...{
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: newDeviceController,
                            validator: (val) =>
                                val!.isEmpty ? 'Naziv je obavezan' : null,
                            decoration: const InputDecoration(
                              hintText: "Novi uređaj",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.black38,
                                ),
                              ),
                            ),
                          ),
                        },
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: primaryColor,
                              checkColor: Colors.white,
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            const Text('Garancija'),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _txtControllerBody,
                          maxLines: 9,
                          validator: (val) =>
                              val!.isEmpty ? 'Opis je obavezan' : null,
                          decoration: const InputDecoration(
                            hintText: "Opis",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black38,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                kTextButton(
                  'Objavi',
                  () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _loading = !_loading;
                      });

                      _createPost();
                    }
                  },
                ),
              ],
            ),
    );
  }
}
