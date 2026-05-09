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
  final String coverImageUrl;

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
    this.coverImageUrl = '',
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
    String? coverImageUrl,
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
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
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
      'coverImageUrl': coverImageUrl,
      'isDeleted': 0,
    };
  }

  Map<String, dynamic> toJson() {
    return {
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
      'coverImageUrl': coverImageUrl,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip.fromJson(map);
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'] ?? json['Id'];
    final feeValue = json['fee'] ?? json['Fee'];
    final travelersValue = json['travelers'] ?? json['Travelers'];

    String valueAsString(Map<String, dynamic> source, String lowerKey, String upperKey) {
      final value = source[lowerKey] ?? source[upperKey];
      return value == null ? '' : value.toString();
    }

    return Trip(
      id: idValue is int ? idValue : idValue is num ? idValue.toInt() : null,
      location: valueAsString(json, 'location', 'Location'),
      date: valueAsString(json, 'date', 'Date'),
      timeFrom: valueAsString(json, 'timeFrom', 'TimeFrom'),
      timeTo: valueAsString(json, 'timeTo', 'TimeTo'),
      travelers: travelersValue is int
          ? travelersValue
          : travelersValue is num
              ? travelersValue.toInt()
              : int.tryParse(travelersValue.toString()) ?? 0,
      fee: feeValue is int
          ? feeValue.toDouble()
          : feeValue is num
              ? feeValue.toDouble()
              : double.tryParse(feeValue.toString()) ?? 0.0,
      language: valueAsString(json, 'language', 'Language'),
      attractions: valueAsString(json, 'attractions', 'Attractions'),
      status: valueAsString(json, 'status', 'Status'),
      createdAt: valueAsString(json, 'createdAt', 'CreatedAt'),
      coverImageUrl: valueAsString(json, 'coverImageUrl', 'CoverImageUrl'),
    );
  }
}
