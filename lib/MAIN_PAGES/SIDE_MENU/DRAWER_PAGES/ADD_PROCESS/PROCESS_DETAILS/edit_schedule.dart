import 'package:flutter/material.dart';
import 'package:rpa_bot_monitoring_ui/UTILITIES/secure_storage_contents.dart';

import '/SERVICES/PUT SERVICES/update_details_service.dart';

class EditBotDetailsPage extends StatefulWidget {
  final String processName;
  final int processId;
  const EditBotDetailsPage({
    super.key,
    required this.processName, // Add processName parameter
    required this.processId, // Add processId parameter
  });

  @override
  _EditBotDetailsPageState createState() => _EditBotDetailsPageState();
}

class _EditBotDetailsPageState extends State<EditBotDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color customTeal = const Color.fromARGB(255, 66, 105, 105);
  String? selectedProcess;
  int? selectedProcessId;
  String? repeatOption;
  TimeOfDay? selectedTime;
  bool _isLoading = false;
  final UserOrgData _userOrgData = UserOrgData();
  final List<TimeOfDay> selectedTimes = [];
  final List<String> repeatOptions = [
    'Daily',
    'Weekly',
    'Working_Days',
    'Non_Working_Days',
    'Monthly'
  ];
  final List<String> DaysOfWeek = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];
  final Map<String, String> dayMap = {
    'Sun': 'SUNDAY',
    'Mon': 'MONDAY',
    'Tue': 'TUESDAY',
    'Wed': 'WEDNESDAY',
    'Thu': 'THRUSDAY',
    'Fri': 'FRIDAY',
    'Sat': 'SATURDAY'
  };
  List<bool> selectedDays = List.generate(7, (_) => true);
  final List<int> monthlyDays = List.generate(31, (index) => index + 1);
  List<bool> selectedMonthlyDays = List.generate(31, (_) => false);
  List<String> selectedWeekDays = [];
  String? isAdmin = "false";
  // method to fetch projects
  @override
  void initState() {
    super.initState();
    _fetchProcesses();
    _checkIfAdmin();
  }

  Future<void> _checkIfAdmin() async {
    final adminStatus = await _userOrgData.getAdminStatus();
    setState(() {
      isAdmin = adminStatus;
    });
  }

  Future<void> _fetchProcesses() async {
    try {
      if (mounted) {
        setState(() {}); // Refresh the UI
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load processes: $e')),
        );
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        selectedTimes
            .add(selectedTime!); // Automatically save the selected time
        selectedTime = null; // Reset selectedTime for next input
      });
    }
  }

  void _onRepeatOptionChanged(String? value) {
    setState(() {
      repeatOption = value;
      if (repeatOption == 'Daily') {
        selectedDays = List.generate(7, (_) => true);
      } else if (repeatOption == 'Weekly') {
        selectedDays = List.generate(7, (_) => false);
      } else if (repeatOption == 'Working_Days' ||
          repeatOption == 'Non_Working_Days') {
        selectedDays =
            List.generate(7, (_) => false); // Clear selection for special cases
        selectedMonthlyDays = List.generate(31, (_) => false);
      } else if (repeatOption == 'Monthly') {
        selectedMonthlyDays = List.generate(31, (_) => false);
      }
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (selectedTimes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please add at least one schedule time')),
        );
        return;
      }
      if (repeatOption == 'Weekly' && !selectedDays.contains(true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Please select at least one day for Weekly repeat')),
        );
        return;
      }
      if (repeatOption == 'Monthly' && !selectedMonthlyDays.contains(true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Please select at least one date for Monthly repeat')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Prepare selected weekly days
      List<String>? selectedWeekDays;
      if (repeatOption == 'Weekly') {
        selectedWeekDays = [];
        for (int i = 0; i < selectedDays.length; i++) {
          if (selectedDays[i]) {
            selectedWeekDays.add(dayMap[DaysOfWeek[i]]!);
          }
        }
      }

      // Prepare selected monthly days
      List<int>? selectedMonthDays;
      if (repeatOption == 'Monthly') {
        selectedMonthDays = [];
        for (int i = 0; i < selectedMonthlyDays.length; i++) {
          if (selectedMonthlyDays[i]) {
            selectedMonthDays.add(i + 1);
          }
        }
      }

      // Prepare form data for submission
      final formData = {
        'processId': widget.processId, // Add processId here
        'scheduleTime': selectedTimes.map((time) {
          final hour = time.hour.toString().padLeft(2, '0');
          final minute = time.minute.toString().padLeft(2, '0');
          return '$hour:$minute'; // 24-hour format without AM/PM
        }).toList(),
        'repeatOption': repeatOption?.toUpperCase(),
        'selectedWeekDays': repeatOption == 'Weekly' ? selectedWeekDays : null,
        'selectedMonthDays':
            repeatOption == 'Monthly' ? selectedMonthDays : null,
      };

      // Check for processId
      if (widget.processId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Process ID')),
        );
        return;
      }

      // Send data to the service
      final processUpdateService = ProcessUpdateService();

      try {
        final success = await processUpdateService.updateBotDetails(
          formData,
          widget.processId, // Use widget.processId directly
        );

        if (success) {
          Navigator.pop(context); // Return to the last page
        } else {
          print('Failed to update schedule');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating bot details: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'EDIT DETAILS',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: customTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Process: ${widget.processName}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Schedule Time',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectTime(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF61A3FA),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              'Add Time',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Repeat Every',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: repeatOption,
                          items: repeatOptions.map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: _onRepeatOptionChanged,
                          validator: (value) => value == null
                              ? 'Please select a repeat option'
                              : null,
                          decoration: InputDecoration(
                            hintText: 'Select Repeat',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Weekly repeat
                        if (repeatOption == 'Weekly')
                          Wrap(
                            spacing: 8,
                            children: List<Widget>.generate(
                              DaysOfWeek.length,
                              (index) => ChoiceChip(
                                label: Text(DaysOfWeek[index]),
                                selected: selectedDays[index],
                                onSelected: (bool selected) {
                                  setState(() {
                                    selectedDays[index] = selected;
                                  });
                                },
                              ),
                            ),
                          ),

                        // Monthly repeat
                        if (repeatOption == 'Monthly')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Repeat On Day(s)',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: List.generate(31, (index) {
                                  return FilterChip(
                                    label: Text('${index + 1}'),
                                    selected: selectedMonthlyDays[index],
                                    onSelected: (isSelected) {
                                      setState(() {
                                        selectedMonthlyDays[index] = isSelected;
                                      });
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        const Text(
                          'Schedule Times',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: selectedTimes.map((time) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      selectedTimes.remove(time);
                                    });
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                backgroundColor: const Color(0xFF61A3FA),
                                foregroundColor: Colors.white,
                                shadowColor: Colors.black.withOpacity(0.5),
                                elevation: 8.0,
                              ),
                              child: const Text(
                                'Add',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
