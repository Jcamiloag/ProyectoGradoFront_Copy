class User {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final String phonenumber;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phonenumber,
    required this.role,
  });

  String get name => '$firstname $lastname';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      phonenumber: json['phonenumber'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phonenumber': phonenumber,
      'role': role,
    };
  }
}
