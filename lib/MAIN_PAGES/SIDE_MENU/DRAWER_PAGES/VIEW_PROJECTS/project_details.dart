import 'package:flutter/material.dart';
import '/MAIN_PAGES/SIDE_MENU/DRAWER_PAGES/ADD_PROCESS/add_process.dart';
import '/MAIN_PAGES/SIDE_MENU/DRAWER_PAGES/ADD_TEAM/add_team.dart';
import '/UTILITIES/secure_storage_contents.dart'; // For UserOrgData

class ProjectDetailsPage extends StatefulWidget {
  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  bool _isAdmin = false; // Tracks admin status
  final UserOrgData _userOrgData = UserOrgData(); // Secure storage handler

  @override
  void initState() {
    super.initState();
    _checkAdminStatus(); // Check admin status during initialization
  }

  Future<void> _checkAdminStatus() async {
    try {
      // Retrieve admin status from secure storage
      final String? isAdminString = await _userOrgData.getAdminStatus();
      setState(() {
        _isAdmin = isAdminString == 'true'; // Convert string to boolean
      });
      print('Admin status: $_isAdmin');
    } catch (e) {
      print('Error fetching admin status: $e');
      setState(() {
        _isAdmin = false; // Default to non-admin in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _isAdmin ? 2 : 1, // Show 2 tabs if admin, otherwise 1
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Project Details'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.transparent,
              ),
              onPressed: _checkAdminStatus, // Refresh admin status
            ),
          ],
          bottom: TabBar(
            labelColor: const Color(0xFF61A3FA),
            unselectedLabelColor: Colors.grey[400],
            indicator: BoxDecoration(
              color: Colors.white, // Active tab color
              borderRadius: BorderRadius.circular(9),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 1,
                  offset: Offset(0, 3),
                ),
                BoxShadow(
                  color: Color(0x1E000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            indicatorPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 1.5),
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontSize: 17,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: -0.08,
            ),
            tabs: [
              const Tab(
                text: 'Processes',
              ), // Always visible
              if (_isAdmin)
                const Tab(text: 'Add Members'), // Visible only if admin
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const AddProcessPage(),
            if (_isAdmin) const AddTeamPage(), // Conditionally visible
          ],
        ),
      ),
    );
  }
}
