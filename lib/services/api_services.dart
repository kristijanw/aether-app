import 'dart:convert';
import 'dart:developer';

import 'package:app/constant.dart';
import 'package:app/models/api_response.dart';
import 'package:app/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> apiCallGet(String url, String method) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    final response = await http.get(
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
    log('$e');
    log(method);
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> apiCallPost(
    Map createDataPost, String url, String method) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: createDataPost,
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
    log('$e');
    log(method);
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> apiCallPut(
    Map createDataPost, String url, String method) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: createDataPost,
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
    log('$e');
    log(method);
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> apiCallDelete(String url, String method) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();

    final response = await http.delete(
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
    log('$e');
    log(method);
    apiResponse.error = serverError;
  }

  return apiResponse;
}
