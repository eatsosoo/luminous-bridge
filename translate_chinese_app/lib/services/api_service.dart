import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';

class ApiService {
  final Dio _dio = DioClient.dio;

  Future<Response> get(String path,
      {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(path, queryParameters: query);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic e) {
    if (e is DioException) {
      return Exception(e.response?.data['message'] ?? 'API Error');
    }
    return Exception('Unknown error');
  }
}