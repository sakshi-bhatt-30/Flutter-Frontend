import 'package:flutter/material.dart';
import 'package:rpa_bot_monitoring_ui/UTILITIES/secure_storage_contents.dart';
// import 'package:rpa_bot_monitoring_ui/SERVICES/notification_services.dart';
import '../../MODALS/show_project_modal.dart';
import '../../SERVICES/GET SERVICES/show_project_service.dart';
import '../../SERVICES/POST SERVICES/status_service.dart';
import '../../global.dart';
import '/MAIN_PAGES/HOME_PAGE/remarks.dart';
import '../../SERVICES/GET SERVICES/completed_service.dart';
import '../../SERVICES/POST SERVICES/accept_service.dart';
// import '/MAIN_PAGES/HOME_PAGE/ADD_DETAILS/add_details.dart';
import '/MODALS/completed_modal.dart';
import '/MODALS/ongoing_modal.dart';
import '/MODALS/upcoming_modal.dart';
import '../../SERVICES/GET SERVICES/ongoing_service.dart';
import '../../SERVICES/GET SERVICES/upcoming_service.dart';
import '../SIDE_MENU/drawer.dart';
import 'package:intl/intl.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  UserOrgData userOrgData = UserOrgData();
  String formatDateForUI(DateTime date) {
    return DateFormat('dd MMMM yyyy')
        .format(date); // This will display as "05 November 2024"
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Task>> futureTasks =
      Future.value([]); // Initialize with an empty list
  late Future<List<UpcomingTask>> futureUpcomingTasks =
      Future.value([]); // Initialize with an empty list
  late Future<List<ExecutedBot>> futureCompletedTasks =
      Future.value([]); // Initialize with an empty list

  late Future<List<Organization>> futureProjects;

  OrganizationService _organizationService = OrganizationService();
  int? selectedProjectId; // To store the selected project ID
  List<Organization> projects = []; // To hold the list of projects

  Future<void> fetchProjects() async {
    try {
      final fetchedProjects = await _organizationService.fetchOrganizations();
      setState(() {
        futureProjects = Future.value(fetchedProjects); // Update future
        projects = fetchedProjects; // Update the local projects list
      });
    } catch (error) {
      print('Error fetching projects: $error');
      // setState(() {
      //   futureProjects = Future.error(error); // Handle errors in future
      // });
    }
  }

  String? firstName;
  String? lastName;

  @override
  void initState() {
    super.initState();
    futureProjects = _organizationService.fetchOrganizations();
    fetchProjects(); // Fetch projects and update state
    refreshTasks(); // Initial task fetch can be empty until a project is selected
    _fetchUserDetails(); // Fetch user details
  }

  void _fetchUserDetails() async {
    // Fetch first name and last name from secure storage
    String? fetchedFirstName = await userOrgData.getFirstName();
    String? fetchedLastName = await userOrgData.getLastName();

    // Check if both first name and last name are fetched
    if (fetchedFirstName != null && fetchedLastName != null) {
      setState(() {
        firstName = fetchedFirstName;
        lastName = fetchedLastName;
      });
    } else {
      // Handle case when first name or last name is missing
      print('First Name or Last Name is null');
    }
  }

  Future<void> refreshTasks() async {
    await fetchProjects(); // Re-fetch projects

    if (selectedProjectId != null) {
      futureTasks = TaskService().fetchTasks(projectId: selectedProjectId!);
      futureUpcomingTasks = UpcomingTaskService()
          .fetchUpcomingTasks(projectId: selectedProjectId!);
      futureCompletedTasks = CompletedTaskService()
          .fetchCompletedTasks(projectId: selectedProjectId!);
    } else {
      // Handle the case when no project is selected
      futureTasks = Future.value([]); // No tasks to show
      futureUpcomingTasks = Future.value([]); // No upcoming tasks to show
      futureCompletedTasks = Future.value([]); // No completed tasks to show
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 70, // Reduce toolbar height for icons only
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: () {
                setState(() {
                  refreshTasks();
                });
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(200), // Adjust height for dropdown
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      const SizedBox(height: 15),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            const AssetImage('assets/images/my_picture.png'),
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, ${firstName ?? ''}",
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Employee id",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // TabBar for task categories
                Container(
                  width: 342,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0x1E787880),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.white,
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
                    indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical:
                            2), // Adjust this value to make the indicator smaller
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: const Color(0xFF61A3FA),
                    unselectedLabelColor: const Color(0xFF8E8E93),
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.08,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.08,
                    ),
                    tabs: const [
                      Tab(text: 'Ongoing'),
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Completed'),
                    ],
                    splashFactory: NoSplash.splashFactory,
                    labelPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 20),

                // Project Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FutureBuilder<List<Organization>>(
                    future: futureProjects,
                    builder: (context, snapshot) {
                      print(" project :${snapshot.data}");
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No projects available');
                      } else {
                        projects = snapshot.data!;
                        return DropdownButton<int>(
                          isExpanded: true,
                          value: selectedProjectId,
                          hint: const Text('Select Project'),
                          items: projects
                              .map((project) => DropdownMenuItem<int>(
                                    value: project.projectId,
                                    child: Text(project.projectName ??
                                        'Unnamed Project'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedProjectId = value;
                              refreshTasks(); // Refresh tasks based on selected project
                            });
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: CustomDrawer(),
        body: TabBarView(
          children: [
            FutureBuilder<List<Task>>(
              future: futureTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No ongoing tasks'));
                } else {
                  return TaskListView(tasks: snapshot.data!);
                }
              },
            ),
            FutureBuilder<List<UpcomingTask>>(
              future: futureUpcomingTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No upcoming tasks'));
                } else {
                  return UpcomingTaskListView(upcomingTasks: snapshot.data!);
                }
              },
            ),
            FutureBuilder<List<ExecutedBot>>(
              future: futureCompletedTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No completed tasks'));
                } else {
                  return CompletedTaskListView(completedTasks: snapshot.data!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Ongoing page

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onTaskComplete; // callback for task completion

  const TaskCard({Key? key, required this.task, required this.onTaskComplete})
      : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  UserOrgData userOrgData = UserOrgData();
  bool isExpanded = false;
  bool accepted = false;
  String status = "";
  String userName = "UserName";
  TextEditingController remarksController = TextEditingController();
  String? firstName;
  String? lastName;

  String formatDateForUI(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  String formatTime(String time) {
    final hourMinute = time.split(':');
    int hour = int.parse(hourMinute[0]);
    String minute = hourMinute[1];
    String period = hour >= 12 ? 'PM' : 'AM';

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    return '$hour:$minute $period';
  }

  void _fetchUserDetails() async {
    // Fetch first name and last name from secure storage
    String? fetchedFirstName = await userOrgData.getFirstName();
    String? fetchedLastName = await userOrgData.getLastName();

    // Check if both first name and last name are fetched
    if (fetchedFirstName != null && fetchedLastName != null) {
      setState(() {
        firstName = fetchedFirstName;
        lastName = fetchedLastName;
      });
    } else {
      // Handle case when first name or last name is missing
      print('First Name or Last Name is null');
    }
  }

  Future<void> acceptTask(bool accepted) async {
    final UserOrgData _userOrgData = UserOrgData();
    int? userId = await _userOrgData.getUserId();

    // Creating an instance of the postaccept class and calling postProcessData
    final postAcceptInstance = postAccept();
    await postAcceptInstance.postProcessData(
      processId: widget.task.processId,
      startTime: widget.task.startTime,
      endTime: widget.task.endTime,
      notificationTime:
          widget.task.notificationTime ?? 'default notification time',
      date: widget.task.date,
      userId: userId!,
      accepted: accepted,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // page for ongoing bots
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0), // Add 10px of space above each item
      child: Container(
        width: 358,
        height: isExpanded ? (accepted ? 200 : 130) : 75,
        decoration: ShapeDecoration(
          color: const Color(0xFFF5F8FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x13000000),
              blurRadius: 5,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 15,
              top: 19,
              child: Text(
                widget.task.processName,
                style: const TextStyle(
                  color: Color(0xFF212529),
                  fontSize: 16,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              left: 15,
              top: 41,
              child: Text(
                '${formatDateForUI(DateTime.parse(widget.task.date))} | ${formatTime(widget.task.startTime)}',
                style: const TextStyle(
                  color: Color(0xFF6C757D),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Positioned(
              left: 323,
              top: 9,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: const Color(0xFF6C757D),
                ),
              ),
            ),
            if (isExpanded) ...[
              Positioned(
                left: 15,
                top: 72,
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time, // Clock icon
                      color: Color(0xFF6C757D),
                      size: 14,
                    ),
                    const SizedBox(width: 5), // Space between icon and text
                    Text(
                      'Deadline: ${formatDateForUI(DateTime.parse(widget.task.date))} | ${formatTime(widget.task.endTime)}',
                      style: const TextStyle(
                        color: Color(0xFF6C757D),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              if (!accepted) ...[
                Positioned(
                  left: 294,
                  top: 78,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        accepted = true; //
                      });
                      acceptTask(accepted);
                    },
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                        color: Color(0xFF61A3FA),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              if (accepted) ...[
                Positioned(
                  left: 30,
                  top: 95,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Accepted by ${firstName ?? ''}',
                      style: const TextStyle(
                        color: Color(0xFF61A3FA),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 20), // Space between accepted message and buttons
                Positioned(
                  left: 310,
                  top: 116,
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          if (remarksController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Remarks cannot be empty'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            int? id = Global.acceptedId;
                            String remarks = remarksController.text;

                            if (id != null) {
                              statusService service = statusService();

                              try {
                                await service.updateTask(
                                    id, "COMPLETED", remarks);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Task marked as completed'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                widget
                                    .onTaskComplete(); // Remove task from the list
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error: Task ID is null'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () async {
                          if (remarksController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Remarks cannot be empty'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            int id = Global.acceptedId!;
                            String remarks = remarksController.text;

                            statusService service = statusService();

                            try {
                              await service.updateTask(id, "FAILED", remarks);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Task marked as FAILED'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              widget
                                  .onTaskComplete(); // Remove task from the list
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 135,
                  child: Container(
                    width: 300,
                    child: TextField(
                      controller: remarksController,
                      decoration: const InputDecoration(
                        labelText: 'Remarks',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(
                            () {}); // Update state to enable/disable buttons
                      },
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ), // End of main Container
    ); // End of Padding widget
  }
}

// page for upcoming processes
class TaskListView extends StatefulWidget {
  final List<Task> tasks;

  const TaskListView({Key? key, required this.tasks}) : super(key: key);

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  void removeTask(Task task) {
    setState(() {
      widget.tasks.remove(task); // removing the task from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(
          task: widget.tasks[index],
          onTaskComplete: () => removeTask(widget.tasks[index]),
        );
      },
    );
  }
}

// page for upcoming tasks

class UpcomingTaskListView extends StatelessWidget {
  final List<UpcomingTask> upcomingTasks;

  const UpcomingTaskListView({Key? key, required this.upcomingTasks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: upcomingTasks.length,
      itemBuilder: (context, index) {
        final task = upcomingTasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: const Color.fromARGB(255, 229, 234, 249),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.processName,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                    '${formatDateForUI(DateTime.parse(task.date))} | ${formatTime(task.startTime)} - ${formatTime(task.endTime)}'),
                // Text(' | ${formatTime(task.endTime)}'),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDateForUI(DateTime date) {
    return DateFormat('dd MMMM yyyy')
        .format(date); // This will display as "05 November 2024"
  }

  // Function to format time from 24-hour to 12-hour format
  String formatTime(String time) {
    final hourMinute = time.split(':');
    int hour = int.parse(hourMinute[0]);
    String minute = hourMinute[1];
    String period = hour >= 12 ? 'PM' : 'AM';

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12; // handle midnight case
    }

    return '$hour:$minute $period';
  }
}

class CompletedTaskListView extends StatelessWidget {
  final List<ExecutedBot> completedTasks;

  const CompletedTaskListView({super.key, required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    // Filter tasks based on status
    final filteredTasks = completedTasks.where((task) {
      return task.status == "COMPLETED" ||
          task.status == "FAILED" ||
          task.status == "NOT ACCEPTED";
    }).toList();

    final reversedTasks =
        filteredTasks.reversed.toList(); // Reverse for display

    return ListView.builder(
      itemCount: reversedTasks.length,
      itemBuilder: (context, index) {
        final task = reversedTasks[index];
        final cardColor = task.status == "COMPLETED"
            ? const Color.fromARGB(255, 167, 218, 169) // Green shade
            : const Color.fromARGB(255, 236, 161, 161); // Red shade for FAILED or NOT ACCEPTED

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      '${task.processName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (task.date != null && task.startTime != null)
                      Text(
                          '${formatDate(task.date!)} | ${formatTime(task.startTime!)}'),
                    if (task.date != null && task.endTime != null)
                      Text(
                          'To: ${formatDate(task.date!)} | ${formatTime(task.endTime!)}'),
                    if (task.status != null) Text('Status: ${task.status}'),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  iconSize: 35,
                  icon: const Icon(Icons.info_rounded, color: Colors.black),
                  onPressed: () {
                    FlashMessage.show(context, task.remarks);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatDate(String? dateTime) {
    if (dateTime == null) {
      return "No date available";
    }
    try {
      DateTime dt = DateTime.parse(dateTime);
      return "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}";
    } catch (e) {
      debugPrint("Error formatting date: $e");
      return dateTime;
    }
  }

  String formatTime(String? time) {
    if (time == null) {
      return "No time available";
    }
    try {
      final hourMinute = time.split(':');
      int hour = int.parse(hourMinute[0]);
      String minute = hourMinute[1];
      String period = hour >= 12 ? 'PM' : 'AM';

      if (hour > 12) {
        hour -= 12;
      } else if (hour == 0) {
        hour = 12;
      }

      return '$hour:${minute.padLeft(2, '0')} $period';
    } catch (e) {
      debugPrint("Error formatting time: $e");
      return time;
    }
  }
}
