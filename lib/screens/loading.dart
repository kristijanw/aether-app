import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/user.dart';
import 'package:app/screens/bottom_navigation.dart';
import 'package:app/screens/splash_screen.dart';
import 'package:app/screens/users/login.dart';
import 'package:app/services/user_service.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  User? user;

  void _loadUserInfo() async {
    String token = await getToken();

    if (token == '') {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
        (route) => false,
      );
    } else {
      ApiResponse response = await getUserDetail();

      if (response.error == null) {
        setState(() {
          user = response.data as User;
        });

        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
          (route) => false,
        );
      } else if (response.error == unauthorized) {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}'),
        ));
      }
    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
