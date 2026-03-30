import 'dart:convert';

import 'package:http/http.dart' as http;

import '../backend/services/api_endpoint.dart';
import 'language_model.dart';

class LanguageService {
  Future<List<Language>> fetchLanguages() async {
    final response = await http.get(Uri.parse(ApiEndpoint.languagesURL));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> languageDataList = data["data"]["languages"];
      final List<Language> languages =
          languageDataList.map((json) => Language.fromJson(json)).toList();
      return languages;
    } else {
      // if (response.statusCode == 503) {
      //   ErrorResponse res = ErrorResponse.fromJson(jsonDecode(response.body));
      //   print(res.data.title);
      //   Get.to(() => MaintainScreen(
      //       title: res.data.title,
      //       image:
      //           "${res.data.baseUrl}/${res.data.imagePath}/${res.data.image}"));
      // }
      // CustomSnackBar.error('Failed to load language data');
      throw Exception('Failed to load language data');
    }
  }
}
