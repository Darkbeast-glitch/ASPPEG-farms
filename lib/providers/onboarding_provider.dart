import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod provider to manage the current page state
final currentPageProvider = StateProvider<int>((ref) => 0);

// Page count constant
const pageCount = 4;
