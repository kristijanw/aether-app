import 'package:app/constant.dart';
import 'package:app/screens/list_users.dart';
import 'package:app/screens/my_home.dart';
import 'package:app/screens/mylists.dart';
import 'package:app/screens/post_form.dart';
import 'package:app/screens/users/profile.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;
  String roleName = '';
  List<BottomNavigationBarItem> listItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.list), label: 'MyPost'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];
  List<Widget> screens = [
    const MyHome(),
    const MyList(),
    const Profile(),
  ];

  void getRoleName() async {
    await getRole().then((value) {
      setState(() {
        roleName = value;
      });
    });

    if (roleName == 'admin') {
      setState(() {
        screens = [
          const MyHome(),
          const MyList(),
          const Profile(),
          const ListUsers(),
        ];

        listItems = const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'MyPost'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'ListUsers',
          ),
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRoleName();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: screens[currentIndex],
      floatingActionButton: (roleName == 'korisnik')
          ? SizedBox(
              width: 50,
              height: 60,
              child: FloatingActionButton(
                mini: true,
                elevation: 0,
                backgroundColor: primaryColor,
                onPressed: () async {
                  if (!mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PostForm(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      bottomNavigationBar: BottomAppBar(
        height: size.height * 0.07,
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          fixedColor: primaryColor,
          unselectedItemColor: const Color.fromARGB(255, 87, 87, 87),
          elevation: 0,
          iconSize: 30,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: listItems,
          currentIndex: currentIndex,
          onTap: (val) {
            setState(() {
              currentIndex = val;
            });
          },
        ),
      ),
    );
  }
}
