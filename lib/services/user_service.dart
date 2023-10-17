// login
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/user.dart';
import 'package:app/services/api_services.dart';
import 'package:app/services/notification.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    // ignore: avoid_print
    print(response.statusCode);
    // ignore: avoid_print
    print(loginURL);

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJsonLogin(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    log('login');
    // ignore: avoid_print
    print(e);
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// Register
Future<ApiResponse> register(Map dataPost) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse('https://aether.hr/backend/api/register'),
      headers: {'Accept': 'application/json'},
      body: dataPost,
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    log('register');
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// registerNewUser
Future<ApiResponse> registerNewUser(Map dataPost) async {
  final apiResponse =
      await apiCallPost(dataPost, registerNewURL, 'registerNewUser');

  return apiResponse;
}

Future<ApiResponse> getRepairMan() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();

    String url = getRepairMans;

    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    log('getRepairMan');
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// User
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJsonLogin(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    log('getUserDetails');
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Update user
Future<ApiResponse> updateUser(Map userData) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.put(
      Uri.parse(userURL),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: userData,
    );

    // ignore: avoid_print
    print(response.body);

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// All users
Future<ApiResponse> getAllUsers(int page) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    final response = await http.get(
      Uri.parse('$allUsersURL?page=$page'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// search users
Future<ApiResponse> searchUsersByName(String name) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    final response = await http.get(
      Uri.parse('$searchUser/$name'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Delete user
Future<ApiResponse> deleteUser(String userID) async {
  final url = '$deleteUserURL/$userID';

  final apiResponse = await apiCallDelete(url, 'deleteUser');

  return apiResponse;
}

// get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get role
Future<String> getRole() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('role') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// logout
Future<bool> logout() async {
  String userid = '';
  await getUserId().then((value) => userid = value.toString());
  await removeToken(userid);

  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
