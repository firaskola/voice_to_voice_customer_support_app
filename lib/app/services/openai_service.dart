import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey;
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";

  OpenAIService(this.apiKey);

  Future<String> generateResponse(List<Map<String, String>> messages) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo", // or "gpt-4"
        "messages": messages,
        "max_tokens": 150, // Limit response length
        "temperature": 0.7, // Adjust creativity (0 = strict, 1 = creative)
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception("Failed to fetch response: ${response.statusCode}");
    }
  }
}
