class UserModel {
  final String firstName; // Updated to match the JSON key
  final String lastName; // Updated to match the JSON key
  final String email;
  final String mobileNumber;

  UserModel({
    required this.firstName, // Updated to match the JSON key
    required this.lastName, // Updated to match the JSON key
    required this.email,
    required this.mobileNumber,
  });

  // Factory method to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'] ?? '', // Updated to match the JSON key
      lastName: json['lastName'] ?? '', // Updated to match the JSON key
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName, // Updated to match the JSON key
      'lastname': lastName, // Updated to match the JSON key
      'email': email,
      'mobileNumber': mobileNumber,
    };
  }
}
