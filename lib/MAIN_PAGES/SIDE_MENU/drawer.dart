import 'package:flutter/material.dart';
import "/MAIN_PAGES/TEXT_FILES/privacy_policy.dart";
import '../TEXT_FILES/terms_and_conditions.dart';
// import 'DRAWER_PAGES/ADD_PROCESS/add_process.dart';
import 'DRAWER_PAGES/EDIT_PROFILE/profile_setting.dart';
// import 'DRAWER_PAGES/ADD_TEAM/add_team.dart';
// import 'DRAWER_PAGES/VIEW_PROJECTS/project_details.dart';
import 'DRAWER_PAGES/LOGOUT/logoutpage.dart';
import 'DRAWER_PAGES/VIEW_PROJECTS/project_list.dart'; // Import Add Team Page

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  final Color customTeal = const Color.fromARGB(255, 45, 90, 216);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: const Center(
              child: Text(
                'MENU',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSettingsPage()),
              );
            },
          ),
          // Projects Dropdown for Add Team Members and Add Process
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Projects'),
            // subtitle: const Text('Add Team or Process'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProjectPage()),
                // MaterialPageRoute(builder: (context) => ProjectDetailsPage()),
              );
            },
            // trailing: PopupMenuButton<String>(
            //   onSelected: (String value) {
            //     if (value == 'add_team_members') {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => AddTeamPage()),
            //       );
            //     } else if (value == 'add_process') {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => AddProcessPage()),
            //       );
            //     }
            //   },
            //   itemBuilder: (BuildContext context) {
            //     return [
            //       const PopupMenuItem<String>(
            //         value: 'add_team_members',
            //         child: Text('Add Team Members'),
            //       ),
            //       const PopupMenuItem<String>(
            //         value: 'add_process',
            //         child: Text('Add Process'),
            //       ),
            //     ];
            //   },
            // ),
          ),
          ListTile(
            leading: const Icon(Icons.terminal_sharp),
            title: const Text('Terms & Conditions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsConditions()),
              ); // Terms and condition page
            },
          ),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
              // Privacy policy page
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Account'),
            onTap: () {
              // account delete action
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogoutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
