// lib/services/jira_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class JiraService {
  final String baseUrl;
  final String username;
  final String apiToken;

  JiraService({
    required this.baseUrl,
    required this.username,
    required this.apiToken,
  });

  Future<List<dynamic>> importStories(String projectKey) async {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$apiToken'))}';
    final response = await http.get(
      Uri.parse('$baseUrl/rest/api/2/search?jql=project=$projectKey'),
      headers: {'Authorization': basicAuth},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['issues'];
    } else {
      throw Exception('Failed to load stories from JIRA');
    }
  }
}
