// import 'package:flutter/material.dart';
// import '../../../../MODALS/show_project_modal.dart'; // Ensure this contains the Organization model
// import '../SERVICES/GET SERVICES/show_project_service.dart'; // Ensure this fetches organizations/projects

// class DropdownExample extends StatefulWidget {
//   const DropdownExample({Key? key}) : super(key: key);

//   @override
//   _DropdownExampleState createState() => _DropdownExampleState();
// }

// class _DropdownExampleState extends State<DropdownExample> {
//   final OrganizationService _organizationService = OrganizationService();
//   List<Organization> _organizations = [];
//   String? _selectedProjectId;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProjects();
//   }

//   Future<void> _fetchProjects() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       final organizations = await _organizationService.fetchOrganizations();
//       setState(() {
//         _organizations = organizations;
//       });
//     } catch (e) {
//       _showErrorDialog("Failed to load projects. Please try again.");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showErrorDialog(String message) {
//     if (!mounted) return;
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Error"),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dropdown Example'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : DropdownButtonFormField<String>(
//                 value: _selectedProjectId,
//                 items: _organizations
//                     .map((org) => DropdownMenuItem(
//                           value: org.projectId.toString(),
//                           child: Text(
//                             org.projectName ?? 'Unnamed Project',
//                           ),
//                         ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedProjectId = value;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   labelText: "Select Project",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
