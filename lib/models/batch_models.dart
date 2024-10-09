class Batch {
  final String name;
  final DateTime createdAt;

  Batch({required this.name, required this.createdAt});

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
