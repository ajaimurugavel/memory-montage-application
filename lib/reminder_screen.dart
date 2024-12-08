import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReminderScreen(),
    );
  }
}

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  List<Task> tasks = [];

  TextEditingController taskController = TextEditingController();
  TextEditingController passcodeController = TextEditingController();

  final String correctPasscode = "1234";
  final String editTaskPasscode = "5678"; // Set your 4-digit passcode for editing tasks

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkTasks();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _checkTasks() {
    final now = DateTime.now();
    print('Current time: $now');
    for (var task in tasks) {
      print('Task time: ${task.date} ${task.time}');
      if (!task.completed &&
          task.date.year == now.year &&
          task.date.month == now.month &&
          task.date.day == now.day &&
          task.time.hour == now.hour &&
          task.time.minute == now.minute) {
        _showTaskReminder(task);
      }
    }
  }

  void _showTaskReminder(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Complete Task'),
          content: Text(task.task),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  task.completed = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Complete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        backgroundColor: Colors.teal, // Set app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date and Time:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: Colors.teal, // Set date picker color
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Set button color
                  ),
                  child: const Text(
                    'Select Date',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );

                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Set button color
                  ),
                  child: const Text(
                    'Select Time',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Add Tasks:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter task',
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.withOpacity(0.5), width: 2.0),
                      ),
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.teal),
                    onSubmitted: (task) {
                      if (task.isNotEmpty) {
                        setState(() {
                          tasks.add(Task(task, selectedDate, selectedTime, false));
                          taskController.clear();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Create a task
                    if (taskController.text.isNotEmpty) {
                      setState(() {
                        tasks.add(Task(taskController.text, selectedDate, selectedTime, false));
                        taskController.clear();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Set button color
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Tasks:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.teal.withOpacity(0.1), // Set list background color
                ),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(tasks[index].task),
                      onDismissed: (direction) {
                        // Remove the task when swiped
                        setState(() {
                          tasks.removeAt(index);
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          // Open the edit task dialog
                          _editTaskWithPasscodeDialog(tasks[index], index);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          margin: const EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tasks[index].task,
                                style: const TextStyle(fontSize: 16, color: Colors.teal),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Date: ${tasks[index].date}',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                'Time: ${tasks[index].time.format(context)}',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (!tasks[index].completed)
                                    ElevatedButton(
                                      onPressed: () {
                                        // Set task as completed
                                        setState(() {
                                          tasks[index].completed = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green, // Set button color to green
                                      ),
                                      child: const Text(
                                        'Complete',
                                        style: TextStyle(fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                  const SizedBox(width: 8.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Open the edit task dialog with passcode verification
                                      _editTaskWithPasscodeDialog(tasks[index], index);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, // Set button color to blue
                                    ),
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Enter passcode to clear all tasks
                _clearTasksDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Set button color to red
              ),
              child: const Text(
                'ClearAll Tasks',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearTasksDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Passcode'),
          content: TextField(
            controller: passcodeController,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: const InputDecoration(
              hintText: 'Enter 4-digit passcode',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Check the entered passcode for clearing all tasks
                if (passcodeController.text == correctPasscode) {
                  // Clear all tasks
                  setState(() {
                    tasks.clear();
                  });
                  Navigator.of(context).pop();
                } else {
                  // Show an error message for incorrect passcode
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Incorrect passcode. Please try again.'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _editTaskWithPasscodeDialog(Task task, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Passcode to Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show a warning if the task has not been completed
              if (!task.completed)
                const Text(
                  'This task has not been completed yet!',
                  style: TextStyle(color: Colors.red),
                ),
              TextField(
                controller: passcodeController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  hintText: 'Enter 4-digit passcode',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Check the entered passcode for editing the task
                if (passcodeController.text == editTaskPasscode) {
                  // Open the edit task dialog
                  Navigator.of(context).pop(); // Close the passcode dialog
                  _editTaskDialog(task, index);
                } else {
                  // Show an error message for incorrect passcode
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Incorrect passcode. Please try again.'),
                    ),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _editTaskDialog(Task task, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            children: [
              TextField(
                controller: taskController,
                decoration: const InputDecoration(
                  hintText: 'Enter task',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: task.date,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: Colors.teal, // Set date picker color
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Set button color
                    ),
                    child: const Text(
                      'Select Date',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: task.time,
                      );

                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Set button color
                    ),
                    child: const Text(
                      'Select Time',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the task with the edited information
                setState(() {
                  tasks[index] = Task(
                    taskController.text,
                    selectedDate,
                    selectedTime,
                    tasks[index].completed,
                  );
                });

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class Task {
  final String task;
  final DateTime date;
  final TimeOfDay time;
  bool completed;

  Task(this.task, this.date, this.time, this.completed);
}
