import 'package:translate_chinese_app/services/api_service.dart';

class TranslateService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getUser(String content) async {

    final res = await _api.post('/trans/', { 'content': content });
    return res.data;
  }
}