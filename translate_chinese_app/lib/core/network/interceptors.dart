import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: lấy token từ storage
    const token = 'your_token_here';

    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }
}