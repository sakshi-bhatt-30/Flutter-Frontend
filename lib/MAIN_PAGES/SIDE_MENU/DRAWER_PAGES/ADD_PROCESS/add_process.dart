import 'package:flutter/material.dart';
import '/SERVICES/DELETE SERVICES/delete_process_service.dart';
import '/SERVICES/GET SERVICES/get_bot_details_service.dart';
import "/MODALS/show_process_modal.dart";
import "/SERVICES/GET SERVICES/show_process_service.dart";
import 'PROCESS_DETAILS/add_details.dart';
import 'PROCESS_DETAILS/edit_schedule.dart';
import 'add_new_process.dart';
// import 'process_schedule.dart';

class AddProcessPage extends StatefulWidget {
  const AddProcessPage({super.key});

  @override
  _AddProcessPageState createState() => _AddProcessPageState();
}

class _AddProcessPageState extends State<AddProcessPage> {
  final Color customTeal = const Color(0xFFF5F8FF);
  final ProcessService _processService = ProcessService();
  List<Process> processes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProcesses();
  }

  Future<void> _deleteProcess(Process process) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Process'),
      content: Text('Are you sure you want to delete "${process.processName}"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    final deleteService = DeleteProcessService();
    final success = await deleteService.deleteProcess(process.processId); // Pass processId here
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Process deleted successfully.')),
      );
      refreshProcesses();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete process.')),
      );
    }
  }
}


  Future<void> _loadProcesses() async {
    try {
      final fetchedProcesses = await _processService.fetchProcesses();
      debugPrint('Fetched processes: $fetchedProcesses');
      setState(() {
        processes = fetchedProcesses;
        isLoading = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          // processes = fetchedProcesses;
          isLoading = false;
        });
      }
      debugPrint('Error loading processes: $error');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error loading processes: $error')),
      // );
    }
  }

  void refreshProcesses() {
    setState(() {
      isLoading = true; // Optional: Start loading animation if required
    });
    _loadProcesses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadProcesses,
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : processes.isEmpty
                      ? const Center(child: Text('No processes available'))
                      : ListView.builder(
                          itemCount: processes.length,
                          itemBuilder: (context, index) {
                            final process = processes[index];

                            return GestureDetector(
                              onTap: () async {
                                final process = processes[index];
                                print("process id sent ${process.processId}");
                                final GetBotDetails _processService =
                                    GetBotDetails(process.processId.toString());

                                try {
                                  // Show a dialog with a loading indicator
                                  showDialog(
                                    context: context,
                                    barrierDismissible:
                                        false, // Prevent dismissing the dialog by tapping outside
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Loading...'),
                                        content: Center(
                                            child: CircularProgressIndicator()),
                                      );
                                    },
                                  );

                                  // Fetch the detailed information for this process
                                  final botDetails = await _processService
                                      .getProcess(process.processId);

                                  // Close the loading dialog
                                  Navigator.of(context).pop();

                                  // Display the fetched details in the dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Process Details',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Row to display the label and fetched data in the same line
                                            Row(
                                              children: [
                                                Text('Name: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Expanded(
                                                    child: Text(botDetails
                                                        .processName)),
                                              ],
                                            ),
                                            SizedBox(height: 8),

                                            Row(
                                              children: [
                                                Text('Scheduled Time: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Expanded(
                                                    child: Text(botDetails
                                                        .scheduledTime
                                                        .join(", "))),
                                              ],
                                            ),
                                            SizedBox(height: 8),

                                            Row(
                                              children: [
                                                Text('Repeat Option: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Expanded(
                                                    child: Text(botDetails
                                                        .repeatOption)),
                                              ],
                                            ),
                                            SizedBox(height: 8),

                                            // Conditionally show the "Days of Week" based on repeatOption and if it's not null/empty
                                            if (botDetails.repeatOption !=
                                                    "DAILY" &&
                                                (botDetails.daysOfWeek
                                                        ?.isNotEmpty ??
                                                    false))
                                              Row(
                                                children: [
                                                  Text('Days of Week: ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Expanded(
                                                      child: Text(botDetails
                                                              .daysOfWeek
                                                              ?.join(", ") ??
                                                          '')),
                                                ],
                                              ),

                                            // Conditionally show the "Monthly Days" based on repeatOption
                                            if (botDetails.repeatOption ==
                                                "MONTHLY")
                                              Row(
                                                children: [
                                                  Text('Monthly Days: ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Expanded(
                                                      child: Text(botDetails
                                                          .monthlyDays
                                                          .join(", "))),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Optionally handle any action here (e.g., edit action)
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditBotDetailsPage(
                                                  processName:
                                                      process.processName,
                                                  processId: process.processId,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text('Edit'),
                                        ),
                                      ],
                                    ),
                                  );
                                } catch (error) {
                                  // Close the loading dialog in case of error
                                  Navigator.of(context).pop();
                                  // Handle any errors in fetching the process details
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Error fetching process details: $error')),
                                  );
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: customTeal,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.ac_unit_sharp,
                                        color: Colors.black),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        process.processName,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.black),
                                      onPressed: () => _deleteProcess(process),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Pass the callback to AddProcessBottomSheet
                      AddProcessBottomSheet.show(context,
                          onProcessAdded: refreshProcesses);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      "Add Process",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (processes.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBotDetailsPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No process available to select.'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF61A3FA),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      "Add Schedule",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
