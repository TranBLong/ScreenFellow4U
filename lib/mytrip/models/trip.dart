class Trip {
  final int? id;
  final String location;
  final String date;
  final String timeFrom;
  final String timeTo;
  final int travelers;
  final double fee;
  final String language;
  final String attractions;
  final String status;
  final String createdAt;

  Trip({
    this.id,
    required this.location,
    required this.date,
    required this.timeFrom,
    required this.timeTo,
    required this.travelers,
    required this.fee,
    required this.language,
    required this.attractions,
    required this.status,
    required this.createdAt,
  });

  Trip copyWith({
    int? id,
    String? location,
    String? date,
    String? timeFrom,
    String? timeTo,
    int? travelers,
    double? fee,
    String? language,
    String? attractions,
    String? status,
    String? createdAt,
  }) {
    return Trip(
      id: id ?? this.id,
      location: location ?? this.location,
      date: date ?? this.date,
      timeFrom: timeFrom ?? this.timeFrom,
      timeTo: timeTo ?? this.timeTo,
      travelers: travelers ?? this.travelers,
      fee: fee ?? this.fee,
      language: language ?? this.language,
      attractions: attractions ?? this.attractions,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'location': location,
      'date': date,
      'timeFrom': timeFrom,
      'timeTo': timeTo,
      'travelers': travelers,
      'fee': fee,
      'language': language,
      'attractions': attractions,
      'status': status,
      'createdAt': createdAt,
      'isDeleted': 0,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    final idValue = map['id'];
    final feeValue = map['fee'];
    final travelersValue = map['travelers'];
    return Trip(
      id: idValue is int ? idValue : idValue is num ? idValue.toInt() : null,
      location: map['location'] as String,
      date: map['date'] as String,
      timeFrom: map['timeFrom'] as String,
      timeTo: map['timeTo'] as String,
      travelers: travelersValue is int
          ? travelersValue
          : travelersValue is num
              ? travelersValue.toInt()
              : int.parse(travelersValue.toString()),
      fee: feeValue is int
          ? feeValue.toDouble()
          : feeValue is num
              ? feeValue.toDouble()
              : double.parse(feeValue.toString()),
      language: map['language'] as String,
      attractions: map['attractions'] as String,
      status: map['status'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}
