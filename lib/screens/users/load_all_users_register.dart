import 'dart:convert';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/user.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadAllUsersWidget extends StatefulWidget {
  const LoadAllUsersWidget({super.key, required this.setChoiseUser});

  final Function setChoiseUser;

  @override
  State<LoadAllUsersWidget> createState() => _LoadAllUsersWidgetState();
}

class _LoadAllUsersWidgetState extends State<LoadAllUsersWidget> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchName = TextEditingController();
  bool _loading = true;
  List<dynamic> usersList = [];
  String searchByName = '';
  int currentPage = 1;
  String isSelected = '';
  int isSelectedId = 0;

  Future<void> searchUsers() async {
    ApiResponse response = await searchUsersByName(searchByName);
    final data = jsonEncode(response.data);

    if (jsonDecode(data) == null) {
      setState(() {
        if (currentPage == 1) {
          usersList = jsonDecode(data)['users'];
        } else {
          usersList.addAll(jsonDecode(data)['users']);
        }
        _loading = _loading ? !_loading : _loading;
      });
    }

    if (response.error == null) {
      setState(() {
        usersList = jsonDecode(data)['users'];
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

  Future<void> fetchAllUsers() async {
    ApiResponse response = await getAllUsers(currentPage);
    final data = jsonEncode(response.data);

    if (jsonDecode(data) == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
      return;
    }

    if (response.error == null) {
      setState(() {
        if (currentPage == 1) {
          usersList = jsonDecode(data)['users']['data'];
        } else {
          usersList.addAll(jsonDecode(data)['users']['data']);
        }
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void scrollListener() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        currentPage++;
        fetchAllUsers();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
    scrollListener();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Potražite i odaberite svoje ime iz popisa prije nego se registrirate. U slučaju da Vas nema slobodno preskočite odabir.',
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: searchName,
          onChanged: (value) {
            setState(() {
              searchByName = value;
            });

            if (value.length > 3) {
              searchUsers();
            }

            if (value.isEmpty) {
              fetchAllUsers();
            }
          },
          decoration: kInputDecoration(
            'Pretraži korisnike',
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: usersList.where((el) {
                User user = User.fromJson(el);

                if (searchByName != '') {
                  return user.name!.toLowerCase().contains(
                        searchByName.toLowerCase(),
                      );
                }

                return true;
              }).map((item) {
                User user = User.fromJson(item);
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(user.name!),
                  onTap: () {
                    widget.setChoiseUser(user.id!);

                    setState(() {
                      isSelected = user.name!;
                      isSelectedId = user.id!;
                      searchName.text = user.name!;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        if (isSelectedId != 0) ...{
          TextButton(
            onPressed: () {
              setState(() {
                isSelected = '';
                isSelectedId = 0;
                searchName.text = '';
              });

              widget.setChoiseUser(0);
            },
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              decoration: const BoxDecoration(
                gradient: linearGradient,
                borderRadius: BorderRadius.all(Radius.circular(80.0)),
              ),
              child: Text(
                'Očisti odabir',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Odabrani korisnik je:',
            textAlign: TextAlign.left,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            isSelected,
            textAlign: TextAlign.left,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          )
        }
      ],
    );
  }
}
