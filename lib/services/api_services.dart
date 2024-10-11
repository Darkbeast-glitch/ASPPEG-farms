import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/batch_models.dart';
import 'package:myapp/services/auth_services.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final authService = ref.read(authSerivceProvider); // Ensure correct spelling
  return ApiService(authService);
});

class ApiService {
  final AuthService authService;
  static const String baseUrl =
      'https://1658-102-176-94-11.ngrok-free.app'; // Use your Ngrok URL

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

  Future<List<Batch>> getBatches() async {
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return [];
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
        List<dynamic> batchData = jsonDecode(response.body);
        return batchData.map((data) => Batch.fromJson(data)).toList();
      } else {
        print('Failed to fetch batches. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error during fetching batches: $e');
      return [];
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

// api function to upload Image
  Future<String?> uploadImage(File imageFile) async {
    final uri = Uri.parse('$baseUrl/arrival_data/upload_image');
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final Map<String, dynamic> jsonResponse = jsonDecode(responseData);
        return jsonResponse['image_path']; // Return the image path
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // api function to add arrival_data to the db
  Future<bool> submitArrivalData(Map<String, dynamic> arrivalData) async {
    final uri = Uri.parse('$baseUrl/arrival_data/add_arrival_data');
    try {
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(arrivalData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Arrival data submitted successfully.');
        return true; // Return true for success
      } else {
        print(
            'Failed to submit arrival data. Status code: ${response.statusCode}');
        return false; // Return false for failure
      }
    } catch (e) {
      print('Error submitting arrival data: $e');
      return false; // Return false if there is an error
    }
  }

  // Method to save user data to the FastAPI backend
  Future<bool> saveUserToBackend(
      String name, String email, String firebaseUID) async {
    final uri = Uri.parse('$baseUrl/users/create_user');
    final Map<String, dynamic> userData = {
      "name": name,
      "email": email,
      "firebase_uid": firebaseUID,
    };

    try {
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('User data saved successfully.');
        return true;
      } else {
        print('Failed to save user data. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }
}
