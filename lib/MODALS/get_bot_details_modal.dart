class GetDetails {
  final int processId;
  final String processName;
  final List<String> scheduledTime;
  final String repeatOption;
  final List<String> daysOfWeek;
  final List<int> monthlyDays;
  final bool active;

  GetDetails({
    required this.processId,
    required this.processName,
    required this.scheduledTime,
    required this.repeatOption,
    required this.daysOfWeek,
    required this.monthlyDays,
    required this.active,
  });

  // Factory constructor to parse JSON into a Process object
  factory GetDetails.fromJson(Map<String, dynamic> json) {
    return GetDetails(
      processId: json['processId'],
      processName: json['processName'],
      scheduledTime: List<String>.from(json['scheduledTime']),
      repeatOption: json['repeatOption'],
      daysOfWeek: List<String>.from(json['daysOfWeek']),
      monthlyDays: List<int>.from(json['monthlyDays']),
      active: json['active'],
    );
  }

  // Method to convert a Process object to JSON
  Map<String, dynamic> toJson() {
    return {
      'processId': processId,
      'processName': processName,
      'scheduledTime': scheduledTime,
      'repeatOption': repeatOption,
      'daysOfWeek': daysOfWeek,
      'monthlyDays': monthlyDays,
      'active': active,
    };
  }
}
