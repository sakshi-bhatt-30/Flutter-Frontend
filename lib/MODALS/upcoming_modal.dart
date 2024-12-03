class UpcomingTask {
  final int processId;
  final int projectId;
  final String processName;
  final String startTime;
  final String endTime;
  final String notificationTime;
  final String date;

  UpcomingTask({
    required this.processId,
    required this.projectId,
    required this.processName,
    required this.startTime,
    required this.endTime,
    required this.notificationTime,
    required this.date,
  });

  // Factory method to create an instance from JSON
  factory UpcomingTask.fromJson(Map<String, dynamic> json) {
    return UpcomingTask(
      processId: json['processId'],
      projectId: json['projectId'],
      processName: json['processName'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      notificationTime: json['notificationTime'],
      date: json['date'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'processId': processId,
      'projectId': projectId,
      'processName': processName,
      'startTime': startTime,
      'endTime': endTime,
      'notificationTime': notificationTime,
      'date': date,
    };
  }
}
