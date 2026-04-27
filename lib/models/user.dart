class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? password;
  final String role;
  final String country;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    required this.role,
    this.country = '',
  });

  String get fullName => '$firstName $lastName'.trim();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _readInt(json, const ['id', 'ID', 'userId', 'UserID']),
      firstName: _readString(
        json,
        const ['FirstName', 'first_name', 'firstName', 'firstname'],
      ),
      lastName: _readString(
        json,
        const ['LastName', 'last_name', 'lastName', 'lastname'],
      ),
      email: _readString(json, const ['Email', 'email']),
      password: _readString(json, const ['Password', 'password']),
      role: _readString(json, const ['Role', 'role']) == ''
          ? 'Traveler'
          : _readString(json, const ['Role', 'role']),
      country: _readString(json, const ['Country', 'country']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'role': role,
      'country': country,
    };
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return '';
  }

  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) continue;
      final parsed = int.tryParse(value.toString());
      if (parsed != null) return parsed;
    }
    return null;
  }
}
