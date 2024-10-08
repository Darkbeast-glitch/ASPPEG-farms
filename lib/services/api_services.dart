import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/auth_services.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final authService = ref.read(authSerivceProvider); // Ensure correct spelling
  return ApiService(authService);
});

class ApiService {
  final AuthService authService;
  static const String baseUrl =
      'https://9639-102-176-94-103.ngrok-free.app'; // Use your Ngrok URL

  ApiService(this.authService);

  Future<void> createBatch(String name) async {
    // Get the Firebase ID token from the AuthService
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return;
    }

    final url = Uri.parse('$baseUrl/batch/add_batch');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
        body: jsonEncode({
          'name': name,
          'created_at':
              DateTime.now().toIso8601String(), // Added the created_at field
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Batch created successfully: ${response.body}');
      } else {
        print(
            'Failed to create batch. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error during batch creation: $e');
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
    try {
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
        print(
            'Failed to fetch batches. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error during fetching batches: $e');
    }
  }

  // function to getAtiveBatachesout
  Future<int> getActiveBatchCount() async {
    // Get the Firebase ID token from the AuthService
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return 0;
    }

    final url = Uri.parse('$baseUrl/batch/count_batches');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
      );

      if (response.statusCode == 200) {
        int batchCount = int.parse(response.body);
        print('Total number of active batches: $batchCount');
        return batchCount;
      } else {
        print(
            'Failed to fetch active batch count. Status code: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error during fetching active batch count: $e');
      return 0;
    }
  }
}
