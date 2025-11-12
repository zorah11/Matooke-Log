class Record {
  int? id;
  String cropName;
  String date; // ISO-8601
  double quantity;
  String? notes;

  Record({
    this.id,
    required this.cropName,
    required this.date,
    required this.quantity,
    this.notes,
  });

  factory Record.fromMap(Map<String, dynamic> m) => Record(
    id: m['id'] as int?,
    cropName: m['crop_name'] as String? ?? '',
    date: m['date'] as String? ?? '',
    quantity: (m['quantity'] is int)
        ? (m['quantity'] as int).toDouble()
        : (m['quantity'] as double? ?? 0.0),
    notes: m['notes'] as String?,
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'crop_name': cropName,
      'date': date,
      'quantity': quantity,
      'notes': notes,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
