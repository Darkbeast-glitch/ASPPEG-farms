import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/services/api_services.dart';

final batchListProvider = FutureProvider<List<Map<String, String>>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final batches = await apiService.getBatches();
  return batches.map((batch) {
    return {
      "name": batch.name,
      "date": batch.createdAt.toLocal().toString().split(' ')[0], // Formatting the date
    };
  }).toList();
});
