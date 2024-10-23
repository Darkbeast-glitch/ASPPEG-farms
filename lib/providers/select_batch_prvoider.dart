// File: lib/providers/select_batch_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to store the selected batch information globally
final selectedBatchProvider = StateProvider<String?>((ref) => null); // Storing the batch name
final selectedBatchIdProvider = StateProvider<int?>((ref) => null); // Storing the batch id
