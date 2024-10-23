class Batch {
  final int id;
  final String name;
  final DateTime createdAt;

  Batch({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  // Method to parse JSON into a Batch object
  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at']), // Assuming `created_at` is the key in the JSON
    );
  }
}
