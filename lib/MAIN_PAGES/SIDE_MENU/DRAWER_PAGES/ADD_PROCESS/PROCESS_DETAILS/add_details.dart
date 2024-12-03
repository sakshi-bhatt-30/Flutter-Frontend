import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../../../SERVICES/POST SERVICES/add_details_service.dart';
import '../../../../../SERVICES/GET SERVICES/show_process_service.dart';
import '../../../../../MODALS/show_process_modal.dart';
import 'package:rpa_bot_monitoring_ui/UTILITIES/secure_storage_contents.dart';
// import 'package:logging/logging.dart'; // Logging framework

class AddBotDetailsPage extends StatefulWidget {
  const AddBotDetailsPage({super.key});

  @override
  _AddBotDetailsPageState createState() => _AddBotDetailsPageState();
}

class _AddBotDetailsPageState extends State<AddBotDetailsPage> {
  // final Logger _logger = Logger('UserService'); // Logger instance

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color customTeal = const Color.fromARGB(255, 66, 105, 105);
  String? selectedProcess;
  int? selectedProcessId;
  String? repeatOption;
  TimeOfDay? selectedTime;
  bool _isLoading = true;
  // String? _selectedProject;
  final UserOrgData _userOrgData = UserOrgData(); // Secure storage service
  List<Map<String, dynamic>> _projects = [];
  final List<TimeOfDay> selectedTimes = [];
  List<Process> processes = []; // Change to List<Process>
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
    _fetchProjects(); // Fetch projects from secure storage
    _checkIfAdmin();
  }

  Future<void> _checkIfAdmin() async {
    // Fetch or set the isAdmin flag here
    final adminStatus = await _userOrgData.getAdminStatus();
    setState(() {
      isAdmin = adminStatus;
    });
  }

  Future<void> _fetchProjects() async {
    try {
      String? projectData = await _userOrgData.getFromStorage('projects');
      if (projectData != null) {
        List<dynamic> decodedData =
            jsonDecode(projectData); // Decode the JSON string to List
        setState(() {
          _projects = decodedData.map<Map<String, dynamic>>((item) {
            return {
              'id': item['id'],
              'name': item['name'],
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching projects from secure storage: $e');
    }
  }

  Future<void> _fetchProcesses() async {
    try {
      ProcessService processService = ProcessService();
      processes = await processService
          .fetchProcesses(); // Fetch the list of Process objects
      if (mounted) {
        // Check if the widget is still mounted before calling setState
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

  String _truncateText(String text) {
    if (text.length > 30) {
      return '${text.substring(0, 30)}...';
    }
    return text;
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
      // Example userId
      const int userId = 2;
      // Ensure selectedProcessId is not null before making the request
      if (selectedProcessId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a process')),
        );
        return;
      }
      // Submit data via the service
      try {
        final isSuccess = await AddBotService.submitBotDetails(
            formData, userId, selectedProcessId!);
        if (isSuccess) {
          print("Form submission successful");
          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding bot details: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }
  //submitform ended

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text(
            'ADD DETAILS',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold), // Set title color to white
          ),
          // backgroundColor: const Color(0xFF61A3FA),
          iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
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
                    const SizedBox(height: 16),

                    //dropdwon dor process name
                    const Text(
                      'Process Name',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedProcess,
                      items: processes.map((process) {
                        return DropdownMenuItem<String>(
                          value:
                              process.processName, // Use processName as value
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width -
                                  50, // Limit the width of items
                            ),
                            child: Text(
                              _truncateText(process
                                  .processName), // Call truncate function
                              overflow: TextOverflow
                                  .ellipsis, // Handle long text with ellipsis
                              maxLines: 1,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedProcess = value; // Store selected process
                          selectedProcessId = processes
                              .firstWhere((p) => p.processName == value)
                              .processId;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a process' : null,
                      decoration: InputDecoration(
                        hintText: 'Select Process',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    // Function to truncate text

                    // schedule time textfield
                    const SizedBox(height: 20),
                    const Text(
                      'Schedule Time',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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

                    // repeat operation weekly
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

                    // repeat operation for monthly
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
                    // if (repeatOption == 'Working_Days' ||
                    //     repeatOption == 'Non_Working_Days')
                    // const Text(
                    //   'No additional options needed for Working-Days or Non-Working-Days.',
                    //   style: TextStyle(color: Colors.grey),
                    // ),
                    const SizedBox(height: 16),
                    const Text(
                      'Schedule Times',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                    // ElevatedButton(
                    //   onPressed: () => _selectTime(context),
                    //   child: const Text('Add Schedule Time'),
                    // ),
                    const SizedBox(height: 20),
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
                                side: const BorderSide(
                                    color: Colors.transparent, width: 2.0),
                              ),
                              backgroundColor: const Color(0xFF61A3FA),
                              foregroundColor: Colors.white,
                              shadowColor: Colors.black.withOpacity(0.5),
                              elevation: 8.0),
                          child:
                              const Text('Add', style: TextStyle(fontSize: 25)),
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
    );
  }
}
