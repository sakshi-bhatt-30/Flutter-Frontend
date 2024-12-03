class Organization {
  // final int organizationId;
  // final String organizationName;
  final int projectId;
  final String? projectName; // Make projectName nullable
  final String? projectDescription; // Make projectDescription nullable
  // final int userId;
  // final String userFirstName;
  // final String userLastName;
  // final bool admin;

  Organization({
    // required this.organizationId,
    // required this.organizationName,
    required this.projectId,
    this.projectName, // Nullable constructor parameter
    this.projectDescription, // Nullable constructor parameter
    // required this.userId,
    // required this.userFirstName,
    // required this.userLastName,
    // required this.admin,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      // organizationId: json['organizationId'],
      // organizationName:
      //     json['organizationName'] ?? '', // Handle null or missing values
      projectId: json['projectId'],
      projectName: json['projectName'], // Nullable
      projectDescription: json['projectDescription'], // Nullable
      // userId: json['userId'],
      // userFirstName:
      //     json['userFirstName'] ?? '', // Handle null or missing values
      // userLastName: json['userLastName'] ?? '', // Handle null or missing values
      // admin: json['admin'] ?? false, // Default to false if missing
    );
  }

  get id => null;

  get name => null;

  Map<String, dynamic> toJson() {
    return {
      // 'organizationId': organizationId,
      // 'organizationName': organizationName,
      'projectId': projectId,
      'projectName': projectName,
      'projectDescription': projectDescription,
      // 'userId': userId,
      // 'userFirstName': userFirstName,
      // 'userLastName': userLastName,
      // 'admin': admin,
    };
  }
}
