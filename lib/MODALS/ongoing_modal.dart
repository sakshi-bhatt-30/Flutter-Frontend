class Task {
  final int processId;
  final String processName;
  final String startTime;
  final String endTime;
  final String? notificationTime;
  final String date;

  Task({
    required this.processId,
    required this.processName,
    required this.startTime,
    required this.endTime,
    this.notificationTime,
    required this.date,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      processId: json['processId'] as int,
      processName: json['processName'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      notificationTime: json['notificationTime'] as String?,
      date: json['date'] as String,
    );
  }
}
