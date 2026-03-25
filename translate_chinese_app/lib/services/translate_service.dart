import 'package:translate_chinese_app/models/translate_model.dart';
import 'package:translate_chinese_app/services/api_service.dart';

class TranslateService {
  final ApiService _api = ApiService();

  Future<TranslateResponse> translate(String content) async {
  final res = await _api.post('/translate', data: {
    "text": content,
  });

  return TranslateResponse.fromJson(res.data);
}
}