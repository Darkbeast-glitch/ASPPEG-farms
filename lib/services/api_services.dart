import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/models/batch_models.dart';
import 'package:myapp/services/auth_services.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final authService = ref.read(authServiceProvider); // Ensure correct spelling
  return ApiService(authService);
});

class ApiService {
  final AuthService authService;
  // static const String baseUrl = 'https://sweetpotato-backend.onrender.com';
  static const String baseUrl = 'https://ab64-102-211-52-241.ngrok-free.app';

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

  // Method to get all batches from API

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

  // this method uploads Variety
  Future<String?> uploadVarietyImage(File imageFile) async {
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return null;
    }

    final uri = Uri.parse('$baseUrl/variety/upload_variety_image');
    var request = http.MultipartRequest('POST', uri);

    // Add authorization header
    request.headers['Authorization'] = 'Bearer $firebaseToken';

    // Add the file to the request
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
        return jsonResponse['image_url'];
      } else {
        print(
            'Failed to upload variety image. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading variety image: $e');
      return null;
    }
  }

// Update the existing addVarietyData method to include image_url
  Future<bool> addVarietyData(Map<String, dynamic> varietyData) async {
    final uri = Uri.parse('$baseUrl/variety/add_variety_data');
    String? firebaseToken = await authService.getIdToken();

    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return false;
    }

    try {
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
        body: jsonEncode(varietyData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Variety data added successfully.');
        return true;
      } else {
        print(
            'Failed to add variety data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding variety data: $e');
      return false;
    }
  }

  // Method to fetch variety data
  Future<List<Map<String, dynamic>>> getVarietyData() async {
    final uri = Uri.parse('$baseUrl/variety/get_variety_data');
    String? firebaseToken = await authService.getIdToken();

    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return [];
    }

    try {
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
            'Failed to fetch variety data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching variety data: $e');
      return [];
    }
  }

  // Method to fetch the full name of the user from FastAPI using the Firebase UID
  Future<String?> fetchUserFullName(String firebaseUID) async {
    final uri = Uri.parse('$baseUrl/users/get_user_full_name/$firebaseUID');

    try {
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData[
            'name']; // Assuming your API returns the user's name in the 'name' field
      } else {
        print(
            'Failed to fetch user full name. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user full name: $e');
      return null;
    }
  }

// method to fetch the variety names
  Future<List<String>> fetchVarietyNames() async {
    final uri = Uri.parse('$baseUrl/variety/get_variety_names');

    try {
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        return responseData.cast<String>();
      } else {
        print(
            'Failed to fetch variety names. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching variety names: $e');
      return [];
    }
  }

  // Function to add acclimatization data
  Future<bool> addAcclimatization(
      Map<String, dynamic> acclimatizationData) async {
    // Get Firebase ID token
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return false;
    }

    final url = Uri.parse('$baseUrl/aclamimtization_data/add_acclimatization');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
        body: jsonEncode(acclimatizationData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Acclimatization data submitted successfully.');
        return true;
      } else {
        print(
            'Failed to submit acclimatization data. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error submitting acclimatization data: $e');
      return false;
    }
  }

  // Fetch available varieties for selection
  Future<List<dynamic>> getAvailableVarieties() async {
    // Get Firebase ID token
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return [];
    }

    final url = Uri.parse('$baseUrl/aclamimtization_data/get_acclimatization');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch varieties. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching varieties: $e');
      return [];
    }
  }

  // Fetch all varieties with total_left from the first acclimatization
  Future<List<Map<String, dynamic>>> getFirstAcclimatizationData(
      {int? varietyId}) async {
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return [];
    }

    try {
      // Build the URL with the variety_id as a query parameter if provided
      Uri url = Uri.parse('$baseUrl/aclamimtization_data/get_acclimatization');
      if (varietyId != null) {
        url =
            url.replace(queryParameters: {'variety_id': varietyId.toString()});
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
            'Failed to fetch acclimatization data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching acclimatization data: $e');
      return [];
    }
  }

  // Add a second acclimatization entry (Same logic as first, but for second acclimatization)
  Future<bool> addSecondAcclimatization(
      Map<String, dynamic> acclimatizationData) async {
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return false;
    }

    final url = Uri.parse('$baseUrl/secondAccl/add_second_acclimatization');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
        body: jsonEncode(acclimatizationData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Second acclimatization data submitted successfully.');
        return true;
      } else {
        print(
            'Failed to submit second acclimatization data. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error submitting second acclimatization data: $e');
      return false;
    }
  }

  // Method to add a new cut record
  Future<bool> addCutRecord(Map<String, dynamic> cutData) async {
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return false;
    }

    final url = Uri.parse('$baseUrl/greenhouse_cut/add_cut_record');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
        body: jsonEncode(cutData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Cut record added successfully.');
        return true;
      } else {
        print('Failed to add cut record. Status code: ${response.statusCode}');
        print('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding cut record: $e');
      return false;
    }
  }


// Fetch second acclimatization data
  Future<List<Map<String, dynamic>>> getSecondAcclimatizationData() async {
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return [];
    }

    final url = Uri.parse('$baseUrl/secondAccl/all_second_accl');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch second acclimatization data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching second acclimatization data: $e');
      return [];
    }
  }

  // code to add the Field Details to the first Reproducwtion Area
  Future<bool> addFieldDetails(Map<String, dynamic> fieldDetails) async {
    String? firebaseToken = await authService.getIdToken();
    if(firebaseToken == null){
      print("Failed to retrieve Firebase Token");
    }

    final url = Uri.parse('$baseUrl/first_rep/add_first_rep_details');

    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type' : 'application/json',
          'Authorizatioin' : 'Beareer $firebaseToken',
        },
        body:  jsonEncode(fieldDetails)
      );
      if (response.statusCode == 200 || response.statusCode == 201){
        print("Field detials added successfully.");
        return true;
      }else{
        print("Failed to add field details. Status code: ${response.statusCode}");
        print("Response body : ${response.body}");
        return false;

      }
    }catch(e){
      print('Error adding field details: $e');
      return false;
    } 

  }

//Method to get the First Detail Page Data
   Future<List<Map<String, dynamic>>> firstDetailPageData() async {
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return [];
    }

    final url = Uri.parse('$baseUrl/first_rep/get_first_rep_details');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
      );

     if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print('API Response: $data'); // Log the API response
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load first details data');
    }
    } catch (e) {
      print('Error fetching first details data: $e');
      return [];
    }
  }

  // code to add the Field Details to the first Reproducwtion Area
  Future<bool> addSecondFieldDetails(Map<String, dynamic> secondfieldDetails) async {
  String? firebaseToken = await authService.getIdToken();
  if (firebaseToken == null) {
    print("Failed to retrieve Firebase Token");
    return false;
  }

  final url = Uri.parse('$baseUrl/second_rep/add_second_rep_details');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $firebaseToken', // Correct the typo here
      },
      body: jsonEncode(secondfieldDetails),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Field details added successfully.");
      return true;
    } else {
      print("Failed to add field details. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      return false;
    }
  } catch (e) {
    print('Error adding field details: $e');
    return false;
  }
}
  


  // Method to add a new cut record
  Future<bool> addSecondCutRecord(Map<String, dynamic> cutData) async {
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return false;
    }

    final url = Uri.parse('$baseUrl/second_cut/add_second_cut');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
        body: jsonEncode(cutData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Cut record added successfully.');
        return true;
      } else {
        print('Failed to add cut record. Status code: ${response.statusCode}');
        print('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding cut record: $e');
      return false;
    }
  }


  

Future<bool> analyzeImage(Map<String, dynamic> image) async {
    String? firebaseToken = await authService.getIdToken();
    if (firebaseToken == null) {
      print('Failed to retrieve Firebase token.');
      return false;
    }

    final url = Uri.parse('$baseUrl/image)analysis/analyze-plant-image');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
        body: jsonEncode(image),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Cut record added successfully.');
        return true;
      } else {
        print('Failed to add cut record. Status code: ${response.statusCode}');
        print('Error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding cut record: $e');
      return false;
    }
  }



  


  
  
}
