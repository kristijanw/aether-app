import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/services/api_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

// Create post log
Future<ApiResponse> saveToken(Map createDataPost, String userId) async {
  final url = '$saveTokenUrl/$userId';

  final apiResponse = await apiCallPost(createDataPost, url, 'saveToken');

  return apiResponse;
}

Future<String> token() async {
  return await FirebaseMessaging.instance.getToken() ?? "Empty";
}
