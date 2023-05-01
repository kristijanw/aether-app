// ----- STRINGS ------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const baseURL = 'http://192.168.1.7:8000/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const postsURL = '$baseURL/posts';
const myPostsUrl = '$baseURL/my-posts';
const myPostsStatus = '$baseURL/posts/status';

const primaryColor = Color.fromRGBO(196, 0, 117, 1);

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// --- input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    floatingLabelStyle: const TextStyle(color: primaryColor),
    labelText: label,
    labelStyle: GoogleFonts.rubik(),
    contentPadding: const EdgeInsets.all(10),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: primaryColor),
      borderRadius: BorderRadius.circular(20),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

// Pogledaj sve
TextButton viewAllBtn(String label, Function onPressed) {
  return TextButton(
    style: TextButton.styleFrom(
      backgroundColor: Colors.black,
      padding: const EdgeInsets.only(left: 10, right: 10),
      minimumSize: const Size(50, 20),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      alignment: Alignment.centerLeft,
    ),
    onPressed: () => onPressed(),
    child: Text(
      label,
      style: GoogleFonts.rubik(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    ),
  );
}

Color bgColorStatus(String status) {
  if (status == 'aktivno') {
    return Colors.greenAccent;
  }
  if (status == 'cekanje') {
    return Colors.orangeAccent;
  }
  if (status == 'gotovo') {
    return primaryColor;
  }

  return primaryColor;
}

Color txtColorStatus(String status) {
  if (status == 'aktivno') {
    return Colors.black;
  }
  if (status == 'cekanje') {
    return Colors.black;
  }
  if (status == 'gotovo') {
    return Colors.white;
  }

  return Colors.white;
}

// button
TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith(
          (states) => const Color.fromRGBO(196, 0, 117, 1)),
      padding: MaterialStateProperty.resolveWith(
        (states) => const EdgeInsets.symmetric(vertical: 15),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    ),
    onPressed: () => onPressed(),
    child: Text(
      label,
      style: GoogleFonts.rubik(
        textStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

// loginRegisterHint
Row kLoginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(
          label,
          style: GoogleFonts.rubik(
            textStyle: const TextStyle(
              color: Color.fromRGBO(196, 0, 117, 1),
            ),
          ),
        ),
        onTap: () => onTap(),
      )
    ],
  );
}
