import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> checkServerHealth() async {
  final url = 'https://ekumpas-backend.onrender.com/health'; // Your health check endpoint

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'Server is running') {
        print('Server is running');
      } else {
        print('Unexpected response from server');
      }
    } else {
      print('Server returned an error: ${response.statusCode}');
    }
  } catch (e) {
    print('Failed to connect to the server: $e');
  }
}
