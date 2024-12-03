class ExecutedBot {
  final int projectId;
  final int executedBotId;
  final String startTime;
  final String endTime;
  final String notificationTime;
  final String? date;
  final String status;
  final String remarks;
  final String acceptedBy;
  final String? processName; // Made nullable

  ExecutedBot({
    required this.projectId,
    required this.executedBotId,
    required this.startTime,
    required this.endTime,
    required this.notificationTime,
    this.date,
    required this.status,
    required this.remarks,
    required this.acceptedBy,
    this.processName, // Adjusted
  });

  // Factory constructor for creating an ExecutedBot instance from JSON
  factory ExecutedBot.fromJson(Map<String, dynamic> json) {
    return ExecutedBot(
      projectId: json['projectId'] ?? 0,
      executedBotId: json['executedBotId'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      notificationTime: json['notificationTime'] ?? '',
      date: json['date'],
      status: json['status'] ?? '',
      remarks: json['remarks'] ?? '',
      acceptedBy: json['acceptedBy'] ?? '',
      processName: json['processName'], // No default value, nullable
    );
  }

  // Method to convert an ExecutedBot instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'executedBotId': executedBotId,
      'startTime': startTime,
      'endTime': endTime,
      'notificationTime': notificationTime,
      'date': date,
      'status': status,
      'remarks': remarks,
      'acceptedBy': acceptedBy,
      'processName': processName, // Nullable
    };
  }
}
