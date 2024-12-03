import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ShowTeamPage(),
  ));
}

class ShowTeamPage extends StatelessWidget {
  // Dummy data for the team members
  final List<Map<String, String>> teamMembers = [
    {'name': 'Alice', 'role': 'Team Lead', 'image': 'assets/alice.jpg'},
    {'name': 'Bob', 'role': 'Developer', 'image': 'assets/bob.jpg'},
    {'name': 'Charlie', 'role': 'Designer', 'image': 'assets/charlie.jpg'},
    {'name': 'David', 'role': 'Tester', 'image': 'assets/david.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Team'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(teamMembers[index]['image']!),
              ),
              title: Text(teamMembers[index]['name']!),
              subtitle: Text(teamMembers[index]['role']!),
              trailing: Icon(Icons.info),
              onTap: () {
                // Show more info on tap
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(teamMembers[index]['name']!),
                    content: Text('Role: ${teamMembers[index]['role']!}'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
