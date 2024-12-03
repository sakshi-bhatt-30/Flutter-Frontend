class Process {
  final int userId;
  final int processId;
  final String processName;
  final int executionTime;
  final String createdAt;
  final String? updatedAt;
  final String createdBy;
  final bool active;

  Process({
    required this.userId,
    required this.processId,
    required this.processName,
    required this.executionTime,
    required this.createdAt,
    this.updatedAt,
    required this.createdBy,
    required this.active,
  });

  // Factory method to parse JSON into a Process object
  factory Process.fromJson(Map<String, dynamic> json) {
    return Process(
      userId: json['userId'],
      processId: json['processId'],
      processName: json['processName'],
      executionTime: json['executionTime'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      active: json['active'],
    );
  }

  // Method to convert the Process object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'processId': processId,
      'processName': processName,
      'executionTime': executionTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'active': active,
    };
  }
}
