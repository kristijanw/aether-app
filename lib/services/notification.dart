import 'dart:convert';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/services/api_services.dart';
import 'package:app/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> pushNotificationsNewPost(Map createDataPost) async {
  const url = sendNotificationAdminUrl;

  final apiResponse = await apiCallPost(
    createDataPost,
    url,
    'pushNotificationsAll',
  );

  return apiResponse;
}

Future<ApiResponse> pushNotificationUpdatePost(Map createDataPost) async {
  const url = sendNotificationUrl;

  final apiResponse = await apiCallPost(
    createDataPost,
    url,
    'pushNotification',
  );

  return apiResponse;
}

// Save token
Future<ApiResponse> saveToken(Map createDataPost, String userId) async {
  final url = '$saveTokenUrl/$userId';

  final apiResponse = await apiCallPost(createDataPost, url, 'saveToken');

  return apiResponse;
}

// Remove token
Future<ApiResponse> removeToken(String userId) async {
  final url = '$removeTokenUrl/$userId';

  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
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

Future<String> token() async {
  return await FirebaseMessaging.instance.getToken() ?? "Empty";
}
