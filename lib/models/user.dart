class User {
  final int? id;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final String phonenumber;
  final String role;

  User({
    this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phonenumber,
    required this.role,
  });

  /// Soporta claves alternativas por si tu backend usa camelCase
  factory User.fromJson(Map<String, dynamic> json) {
    // A veces role llega como string, otras como objeto { name: "ADMIN" }
    String roleValue;
    final roleField = json['role'];
    if (roleField is Map) {
      roleValue = (roleField['name'] ?? roleField['role'] ?? '').toString();
    } else {
      roleValue = (roleField ?? '').toString();
    }

    return User(
      id: json['id'] is int ? json['id'] as int : (json['id'] is num ? (json['id'] as num).toInt() : null),
      username: (json['username'] ?? '').toString(),
      firstname: (json['firstname'] ?? json['firstName'] ?? '').toString(),
      lastname: (json['lastname'] ?? json['lastName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phonenumber: (json['phonenumber'] ?? json['phoneNumber'] ?? '').toString(),
      role: roleValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phonenumber': phonenumber,
      'role': role,
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? firstname,
    String? lastname,
    String? email,
    String? phonenumber,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      phonenumber: phonenumber ?? this.phonenumber,
      role: role ?? this.role,
    );
  }
}
