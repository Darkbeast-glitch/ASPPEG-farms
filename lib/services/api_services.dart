import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/auth_services.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final authService = ref.read(authSerivceProvider);
  return ApiService(authService);
});

class ApiService {
  final AuthService authService;
  static const String baseUrl =
      'https://8cca-102-211-52-246.ngrok-free.app/'; // Use your Ngrok URL

  ApiService(this.authService);

  Future<void> createBatch(String name) async {
    // Get the Firebase ID token from the AuthService
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return;
    }

    final url = Uri.parse('$baseUrl/batch/add_batch');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $firebaseToken',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200) {
      print('Batch created successfully: ${response.body}');
    } else {
      print('Failed to create batch: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> getBatches() async {
    // Get the Firebase ID token from the AuthService
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return;
    }

    final url = Uri.parse('$baseUrl/batch/get_batches');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $firebaseToken',
      },
    );

    if (response.statusCode == 200) {
      print('Batches fetched successfully: ${response.body}');
    } else {
      print('Failed to fetch batches: ${response.statusCode} ${response.body}');
    }
  }
}
