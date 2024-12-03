import 'package:flutter/material.dart';
import '../../../../SERVICES/POST SERVICES/add_new_process_service.dart';
import '/UTILITIES/secure_storage_contents.dart';
import 'package:logging/logging.dart'; // Logging framework

class AddProcessBottomSheet extends StatefulWidget {
  const AddProcessBottomSheet({Key? key, required this.onProcessAdded})
      : super(key: key);

  final VoidCallback onProcessAdded; // Callback to trigger refresh

  @override
  _AddProcessBottomSheetState createState() => _AddProcessBottomSheetState();

  // Static method to show the Bottom Sheet
  static void show(BuildContext context,
      {required VoidCallback onProcessAdded}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          AddProcessBottomSheet(onProcessAdded: onProcessAdded),
    );
  }
}

class _AddProcessBottomSheetState extends State<AddProcessBottomSheet> {
  final Logger _logger = Logger('UserService');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Color customTeal = const Color(0xFF61A3FA);
  final TextEditingController _processNameController = TextEditingController();
  final TextEditingController _executionTimeController =
      TextEditingController();
  final AddNewProcessService _addNewProcessService = AddNewProcessService();
  final UserOrgData _userOrgData = UserOrgData();

  String? _projectIdWhenNotAdmin;
  bool _isLoading = false; // Loader state

  @override
  void initState() {
    super.initState();
    _fetchProjectId();
  }

  Future<void> _fetchProjectId() async {
    try {
      _projectIdWhenNotAdmin =
          await _userOrgData.getFromStorage('projectIdentiForUrl');
      setState(() {});
    } catch (e) {
      _logger.info('Error fetching project ID: $e');
    }
  }

  @override
  void dispose() {
    _processNameController.dispose();
    _executionTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24.0,
        right: 24.0,
        top: 32.0,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: _processNameController,
              decoration: const InputDecoration(labelText: 'Process Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a process name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _executionTimeController,
              decoration: const InputDecoration(
                labelText: 'Process Execution Time (in minutes)',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a process execution time';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true; // Start loading
                        });
                        final processName = _processNameController.text;
                        final executionTime = _executionTimeController.text;
                        final active = true;

                        if (_projectIdWhenNotAdmin != null) {
                          bool success = await _addNewProcessService.addProcess(
                            processName,
                            executionTime,
                            active,
                            _projectIdWhenNotAdmin!,
                          );

                          if (success) {
                            widget.onProcessAdded(); // Trigger the refresh
                            Navigator.of(context)
                                .pop(true); // Close the BottomSheet
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to add process')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to fetch project ID')),
                          );
                        }

                        setState(() {
                          _isLoading = false; // Stop loading
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: const BorderSide(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      backgroundColor: customTeal,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.black.withOpacity(0.5),
                      elevation: 8.0,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}
