import 'dart:convert';
import 'dart:io';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/screens/bottom_navigation.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/notification.dart';
import 'package:app/services/posts_services.dart';
import 'package:app/services/user_service.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
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
  final TextEditingController timeController = TextEditingController();
  final TextEditingController newDeviceController = TextEditingController();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  late String _hour, _minute, _time;
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();
  bool newDevice = false;
  List<String> list = <String>[
    'odaberi uređaj',
    'dodaj novi',
    'Uređaj 1',
    'Uređaj 2',
    'Uređaj 3',
    'Uređaj 4'
  ];
  List<String> priority = <String>[
    'važnost servisa',
    'niska',
    'srednja',
    'visoka',
  ];
  List listServiser = [];
  String searchByName = '';
  late String userValue;
  late int userIDValue;
  List usersList = [];
  late String serviserValue;
  late int serviserIDValue;
  late String dropdownValue;
  late String priorityValue;
  bool isChecked = false;
  String roleName = '';
  bool created = false;

  void getRepairMansAll() async {
    ApiResponse response = await getRepairMan();
    final data = jsonEncode(response.data);
    Map<String, dynamic> responseJson = jsonDecode(data);
    final repairmans = responseJson['repairmans'];

    listServiser.add({
      "id": 0,
      "name": 'Odaberi servisera',
    });

    for (var repairman in repairmans) {
      listServiser.add({
        "id": repairman['id'],
        "name": repairman['name'],
      });
    }

    setState(() {
      serviserValue = listServiser.first['name'];
      serviserIDValue = listServiser.first['id'];
    });
  }

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
      Navigator.pop(widget.dialogContext);
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

  void setUserDrop() async {
    usersList.add({
      "id": 0,
      "name": 'Odaberi korisnika',
    });

    setState(() {
      userValue = usersList.first['name'];
      userIDValue = usersList.first['id'];
    });
  }

  Future<void> searchUsers(String name) async {
    ApiResponse response = await searchUsersByName(name);
    final data = jsonEncode(response.data);

    if (response.error == null) {
      usersList.clear();

      usersList.add({
        "id": 0,
        "name": 'Odaberi korisnika',
      });

      for (var user in jsonDecode(data)['users']) {
        usersList.add({
          "id": user['id'],
          "name": user['name'],
        });
      }

      setState(() {
        userValue = usersList.first['name'];
        userIDValue = usersList.first['id'];
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

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);

    Map<String, String> createDataPost = {
      'title': _txtControllerTitle.text,
      'body': _txtControllerBody.text,
      'user_id': userIDValue.toString(),
      'image': image ?? '',
      'name_device': newDevice != true
          ? dropdownValue.toString()
          : newDeviceController.text,
      'guarantee': isChecked == true ? 'ima' : 'nema',
      'arrival': widget.selectedDate.toString(),
      'time': timeController.text,
      'repairman': serviserIDValue.toString(),
      'priority': priorityValue.toString(),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
      setState(() {
        _loading = !_loading;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF8CE7F1),
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 187, 14, 95),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '$_hour : $_minute';
        timeController.text = _time;
        timeController.text = formatDate(
            DateTime(2023, 01, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " "]).toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dropdownValue = list.first;
    priorityValue = priority.first;
    getRepairMansAll();
    setUserDrop();
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
                    onChanged: (value) {
                      setState(() {
                        searchByName = value;
                      });

                      if (value.length > 3) {
                        searchUsers(value);
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Pretraži korisnike",
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
                    value: userValue,
                    hint: const Text(
                      'odaberi korisnika',
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
                        userValue = value.toString();
                      });

                      for (var user in usersList) {
                        if (userValue == user['name']) {
                          setState(() {
                            userIDValue = user['id'];
                          });
                        }
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        userValue = value.toString();
                      });

                      for (var user in usersList) {
                        if (userValue == user['name']) {
                          setState(() {
                            userIDValue = user['id'];
                          });
                        }
                      }
                    },
                    validator: (value) {
                      if (value.toString().isEmpty ||
                          value.toString() == 'Odaberi korisnika') {
                        return "Korisnik mora biti odabran";
                      } else {
                        return null;
                      }
                    },
                    items: usersList.map((user) {
                      return DropdownMenuItem(
                        value: user['name'],
                        child: Text(
                          user['name'],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                  InkWell(
                    onTap: () {
                      _selectTime(context);
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black38),
                      ),
                      child: TextFormField(
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                        onSaved: (val) {},
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: timeController,
                        decoration: const InputDecoration(
                          labelText: 'Vrijeme',
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (listServiser.isNotEmpty) ...{
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
                      height: 20,
                    ),
                  },
                  DropdownButtonFormField(
                    value: priorityValue,
                    hint: const Text(
                      'važnost servisa',
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
                        priorityValue = value.toString();
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        priorityValue = value.toString();
                      });
                    },
                    validator: (String? value) {
                      if (value.toString().isEmpty ||
                          value.toString() == 'važnost servisa') {
                        return "Važnost mora biti odabrana";
                      } else {
                        return null;
                      }
                    },
                    items: priority.map((String val) {
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
