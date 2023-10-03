import '../constant.dart';
import '../models/api_response.dart';
import 'api_services.dart';

Future<ApiResponse> getAllDevices() async {
  const url = getDevices;

  final apiResponse = await apiCallGet(url, 'getDevices');

  return apiResponse;
}
