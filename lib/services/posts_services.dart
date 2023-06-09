import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/services/api_services.dart';
import 'package:app/services/user_service.dart';

Future<ApiResponse> getPosts() async {
  String role = await getRole();
  String url = role != 'korisnik' ? postsURL : myPostsUrl;

  final apiResponse = await apiCallGet(url, 'getPosts');

  return apiResponse;
}

Future<ApiResponse> getPostByIDServices(int postid) async {
  String url = '$getPostByIdURL/$postid';

  final apiResponse = await apiCallGet(url, 'getPostByID');

  return apiResponse;
}

Future<ApiResponse> getPostsStatus(String status) async {
  String url = '$myPostsStatus/$status';

  final apiResponse = await apiCallGet(url, 'getPostsStatus');

  return apiResponse;
}

// Create post
Future<ApiResponse> createPost(Map createDataPost) async {
  final apiResponse = await apiCallPost(createDataPost, postsURL, 'createPost');

  return apiResponse;
}

// Create post
Future<ApiResponse> getStatusPostId(String postid) async {
  String url = '$getStatusPostUrl/$postid';

  final apiResponse = await apiCallGet(url, 'getStatusPostId');

  return apiResponse;
}

// Update Post Status
Future<ApiResponse> updateStatus(Map createDataPost) async {
  final postid = createDataPost["postid"];
  final url = '$updateStatusUrl/$postid';

  final apiResponse =
      await apiCallPost(createDataPost, url, 'updateStatusPost');

  return apiResponse;
}

// Set Repairman
Future<ApiResponse> saveRepairMan(Map createDataPost) async {
  final postid = createDataPost["postid"];
  final url = '$setRepairMan/$postid';

  final apiResponse = await apiCallPut(createDataPost, url, 'saveRepairMan');

  return apiResponse;
}

// Create post
Future<ApiResponse> updateDateAndTime(Map createDataPost) async {
  final postid = createDataPost["postid"];
  final url = '$setDateAndTime/$postid';

  final apiResponse =
      await apiCallPost(createDataPost, url, 'updateDateAndTime');

  return apiResponse;
}

// Get all post logs
Future<ApiResponse> getAllPostLogs(String postid) async {
  final url = '$getPostLogsURL/$postid';

  final apiResponse = await apiCallGet(url, 'getAllPostLogs');

  return apiResponse;
}

// Create post log
Future<ApiResponse> createPostLog(Map createDataPost, String postid) async {
  final url = '$createPostLogsURL/$postid';

  final apiResponse = await apiCallPost(createDataPost, url, 'createPostLog');

  return apiResponse;
}

// Delete post log
Future<ApiResponse> deletePostLog(String postlogid) async {
  final url = '$deletePostLogsURL/$postlogid';

  final apiResponse = await apiCallDelete(url, 'deletePostLog');

  return apiResponse;
}
