import 'dart:convert';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/user.dart';
import 'package:app/screens/user_details.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/user_service.dart';
import 'package:app/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({super.key});

  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  List<dynamic> usersList = [];
  bool _loading = true;

  Future<void> fetchAllUsers() async {
    ApiResponse response = await getAllUsers();
    final data = jsonEncode(response.data);
    final responseJson = jsonDecode(data)['users'];

    if (response.error == null) {
      setState(() {
        usersList = responseJson;
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

  void clickDeleteUser(String id) async {
    ApiResponse response = await deleteUser(id);

    if (response.error == null) {
      if (!mounted) return;
      statusMessage('Uspješno obrisano', context, 'success');
      fetchAllUsers();
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
    super.initState();
    fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () => fetchAllUsers(),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetTitle(title: 'Popis korisnika'),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: usersList.map((item) {
                          User user = User.fromJson(item);

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetailsScreen(user: user),
                                  maintainState: false,
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(size.width * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${user.name}',
                                        style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                            fontSize: size.height * 0.018,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Text(
                                          '${user.role}',
                                          style: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.height * 0.015,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.005,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          userInfo(size, 'Naziv firme:',
                                              user.nameCompany),
                                          SizedBox(
                                            height: size.height * 0.005,
                                          ),
                                          userInfo(
                                              size, 'Adresa:', user.address),
                                          SizedBox(
                                            height: size.height * 0.005,
                                          ),
                                          userInfo(
                                              size, 'Kontakt:', user.contact),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // TextButton(
                                          //   onPressed: () => clickDeleteUser(
                                          //     user.id.toString(),
                                          //   ),
                                          //   style: TextButton.styleFrom(
                                          //     backgroundColor: Colors.green,
                                          //     padding: const EdgeInsets.only(
                                          //       left: 10,
                                          //       right: 10,
                                          //     ),
                                          //     minimumSize: const Size(15, 25),
                                          //     tapTargetSize: MaterialTapTargetSize
                                          //         .shrinkWrap,
                                          //     alignment: Alignment.center,
                                          //   ),
                                          //   child: Icon(
                                          //     Icons.edit,
                                          //     color: Colors.white,
                                          //     size: size.width * 0.04,
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   width: size.width * 0.02,
                                          // ),
                                          TextButton(
                                            onPressed: () => clickDeleteUser(
                                              user.id.toString(),
                                            ),
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              minimumSize: const Size(15, 25),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              alignment: Alignment.center,
                                            ),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: size.width * 0.04,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget userInfo(Size size, String label, value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: size.height * 0.015,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: size.width * 0.50,
          child: Text(
            value != null ? value : '',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: size.height * 0.015,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
