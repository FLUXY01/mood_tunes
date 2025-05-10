import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  final String baseUrl = "Your IP Address";

  Future<String> detectEmotion(File imageFile) async {
    final url = Uri.parse("$baseUrl/detect-emotion");
    final request = http.MultipartRequest("POST", url);

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imageFile.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = jsonDecode(responseBody);

        // Debugging: Log the response
        print("API Response: $decodedResponse");

        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey('predictions')) {
          final predictions = decodedResponse['predictions'];
          if (predictions is List<dynamic>) {
            // Find the label with the highest score
            final highestPrediction =
                predictions.reduce((a, b) => a['score'] > b['score'] ? a : b);
            return highestPrediction['label'];
          } else {
            throw Exception(
                "Unexpected response format: 'predictions' is not a list.");
          }
        } else {
          throw Exception(
              "Unexpected response format: Missing 'predictions' key.");
        }
      } else {
        throw Exception("Failed to detect emotion: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
      rethrow;
    }
  }
}
