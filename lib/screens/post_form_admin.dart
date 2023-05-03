import 'dart:io';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/screens/bottom_navigation.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostFormAdmin extends StatefulWidget {
  PostFormAdmin({super.key, this.selectedDate, required this.dialogContext});

  DateTime? selectedDate;
  BuildContext dialogContext;

  @override
  State<PostFormAdmin> createState() => _PostFormAdminState();
}

class _PostFormAdminState extends State<PostFormAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  final TextEditingController _txtControllerTitle = TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();
  List<String> list = <String>[
    'odaberi uređaj',
    'Uređaj 1',
    'Uređaj 2',
    'Uređaj 3',
    'Uređaj 4'
  ];
  late List listServiser;
  late String dropdownValue;
  late String serviserValue;
  late int serviserIDValue;
  bool isChecked = false;
  String roleName = '';
  bool created = false;

  void setServiser() {
    final listServiserData = [
      {'id': 0, 'name': 'odaberi servisera'},
      {'id': 2, 'name': 'Pero Peric'},
      {'id': 3, 'name': 'Marko Maric'},
    ];

    setState(() {
      listServiser = listServiserData;
      serviserValue = listServiser.first['name'];
      serviserIDValue = listServiser.first['id'];
    });
  }

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _checkPost() async {
    Navigator.pop(widget.dialogContext);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const BottomNavigation(),
      ),
      (route) => false,
    );
  }

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);

    Map<String, String> createDataPost = {
      'title': _txtControllerTitle.text,
      'body': _txtControllerBody.text,
      'image': image ?? '',
      'name_device': dropdownValue.toString(),
      'guarantee': isChecked == true ? 'ima' : 'nema',
      'arrival': widget.selectedDate.toString(),
      'repairman': serviserIDValue.toString(),
    };

    ApiResponse response = await createPost(createDataPost);

    if (response.error == null) {
      _checkPost();
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

  @override
  void initState() {
    super.initState();
    dropdownValue = list.first;
    setServiser();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 0,
      ),
      child: Column(
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
                  DropdownButtonFormField(
                    value: serviserValue,
                    hint: const Text(
                      'odaberi servisera',
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
                      setState(() {
                        serviserValue = value.toString();
                      });

                      for (var serviser in listServiser) {
                        if (serviserValue == serviser['name']) {
                          setState(() {
                            serviserIDValue = serviser['id'];
                          });
                        }
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        serviserValue = value.toString();
                      });

                      for (var serviser in listServiser) {
                        if (serviserValue == serviser['name']) {
                          setState(() {
                            serviserIDValue = serviser['id'];
                          });
                        }
                      }
                    },
                    items: listServiser.map((serviser) {
                      return DropdownMenuItem(
                        value: serviser['name'],
                        child: Text(
                          serviser['name'],
                        ),
                      );
                    }).toList(),
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
          SizedBox(
            width: double.infinity,
            child: kTextButton(
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
          ),
        ],
      ),
    );
  }
}
