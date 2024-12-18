class User {
  final String id; // Add the id field
  final String email;
  final String name;
  bool isBanned; // Add the isBanned field

  User({
    required this.id, // Include the id in the constructor
    required this.email,
    required this.name,
    required this.isBanned,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'], // Assuming the backend returns _id for the user
      email: json['email'],
      name: json['name'],
      isBanned: json['isBanned'], // Ensure the isBanned attribute is properly fetched
    );
  }
}
