// ----- STRINGS ------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// https://aether.hr/backend/api
// http://192.168.1.7:8000/api
const baseURL = 'https://aether.hr/backend/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const registerNewURL = '$baseURL/register-new';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const allUsersURL = '$baseURL/all-users';
const searchUser = '$baseURL/search-user';
const deleteUserURL = '$baseURL/user';
const postsURL = '$baseURL/posts';
const getPostByIdURL = '$baseURL/posts';
const myPostsUrl = '$baseURL/my-posts';
const myPostsStatus = '$baseURL/posts/status';
const updateStatusUrl = '$baseURL/post-update-status';
const setDateAndTime = '$baseURL/post-update-datetime';
const getStatusPostUrl = '$baseURL/post-get-status';
const getRepairMans = '$baseURL/get-repairmans';
const setRepairMan = '$baseURL/assign-user-post';
const getPostLogsURL = '$baseURL/post-logs';
const createPostLogsURL = '$baseURL/create-post-log';
const deletePostLogsURL = '$baseURL/post-log';
const saveTokenUrl = '$baseURL/update-token';
const removeTokenUrl = '$baseURL/remove-token';
const sendNotificationAdminUrl = '$baseURL/send-notification-all';
const sendNotificationUrl = '$baseURL/send-notification';
const getDevices = '$baseURL/devices';
const loadAllUsersUrl = '$baseURL/load-users';
const updatePasswordUrl = '$baseURL/update-password';

const primaryColor = Color.fromRGBO(196, 0, 117, 1);

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// Linear gradietn
const linearGradient = LinearGradient(
  begin: Alignment.bottomRight,
  end: Alignment.topLeft,
  colors: [
    Color.fromRGBO(178, 40, 113, 1),
    Color.fromRGBO(236, 0, 140, 1),
  ],
);

// Message
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> statusMessage(
  String message,
  context,
  String status,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: status == 'success' ? Colors.green : Colors.red,
      padding: const EdgeInsets.all(20),
      content: Text(
        message,
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

// --- input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    floatingLabelStyle: const TextStyle(color: primaryColor),
    labelText: label,
    labelStyle: GoogleFonts.montserrat(),
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
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    ),
  );
}

Color priorityBgColor(String status) {
  if (status == 'visoka') {
    return Colors.red;
  }
  if (status == 'srednja') {
    return Colors.orangeAccent;
  }
  if (status == 'niska') {
    return Colors.grey;
  }

  return Colors.transparent;
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
    onPressed: () => onPressed(),
    child: Ink(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: const BoxDecoration(
        gradient: linearGradient,
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            color: Colors.white,
          ),
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
          style: GoogleFonts.montserrat(
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

class Constants {
  static const String baseUrl = 'https://fcm.googleapis.com/fcm/send';
  static const String keyServer =
      'AAAA3EJ_CTk:APA91bFcjGtY3xlOzFFo9pJR9lVJT3wreyYQ9BDGNZmzurTF1dKipG45azY85tamKD6jAvsopTrrQ1h1fZY1nlYd5kF8dapdNYl_sAfK2yxpu8qe3PUHV_65XpFV_j6sxzOc9QXWBk3u';
  static const String senderID = '946008426809';
}
