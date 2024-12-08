import 'dart:async';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';

import 'games_screen.dart';
import 'memory_box_screen.dart';
import 'reminder_screen.dart';
import 'wearable_connection_screen.dart';

class HomePage extends StatefulWidget {
  static const String settingsPasscode = '1234';

  const HomePage({super.key}); // Set your 4-digit passcode here

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  int _inactiveDuration = 30; // 30 seconds of inactivity before showing popup

  @override
  void initState() {
    super.initState();
    _startTimeout();
  }

  void _startTimeout() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _inactiveDuration--;
      if (_inactiveDuration == 0) {
        _showInactivePopup();
      }
    });
  }

  void _resetTimeout() {
    setState(() {
      _inactiveDuration = 30; // Reset the inactive duration
    });
  }

  void _showInactivePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inactive'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You can:'),
              Text('• Set reminders'),
              Text('• Play games'),
              Text('• Recall memories in the memory box'),
              Text('• Check wearable connectivity'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
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
        title: const Text('Memory Montage', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: () {
              _showSettingsPasscodePrompt(context);
            },
            icon: const Icon(Icons.settings, color: Colors.black),
          ),
        ],
        backgroundColor: Colors.white, // Set app bar background color
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 37, 209, 243), // Light Blue
                  Color.fromARGB(255, 41, 128, 185), // Dark Blue
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50), // Adjust this height as needed
                  const Text(
                    'Memory Montage',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BeautifulFont', // Change to your font family
                      color: Colors.white, // Change text color
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Jog your memory with customizable prompts',
                    style: TextStyle(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'BeautifulFont', // Change to your font family
                      color: Colors.white, // Change text color
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'BeautifulFont', // Change to your font family
                      color: Colors.white, // Change text color
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildOption(context, 'Reminders', Icons.alarm, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReminderScreen()));
                        _resetTimeout(); // Reset the timeout on button action
                      }),
                      buildOption(context, 'Games & Reading', Icons.games, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => GamesScreen()));
                        _resetTimeout(); // Reset the timeout on button action
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildOption(context, 'Memory Box', Icons.memory, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MemoryBoxScreen()));
                        _resetTimeout(); // Reset the timeout on button action
                      }),
                      buildOption(context, 'Wearable Connection', Icons.watch, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WearableConnectionScreen()));
                        _resetTimeout(); // Reset the timeout on button action
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showEmergencyContactConfirmation();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.blueAccent,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Container(
                      width: 200,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 0, 206, 209), // Light Blue
                            Color.fromARGB(255, 17, 86, 249), // Dark Blue
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Emergency Contact',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Set text color
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOption(BuildContext context, String optionTitle, IconData icon, Function() onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 179, 199, 208),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 10),
            Text(
              optionTitle,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Account'),
                onTap: () {
                  // Navigate to the account page
                  Navigator.pushNamed(context, '/account');
                  Navigator.pop(context); // Close the menu
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Sign Out'),
                onTap: () {
                  // Navigate to the login page when signing out
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsPasscodePrompt(BuildContext context) {
    String enteredPasscode = ''; // Variable to store the entered passcode

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Enter 4-Digit Passcode for Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Set text color
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  enteredPasscode = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your passcode',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Validate the passcode (you may need to implement actual passcode checking logic)
                  if (enteredPasscode == HomePage.settingsPasscode) {
                    Navigator.pop(context); // Close the passcode prompt
                    showSettingsMenu(context); // Show the settings menu
                  } else {
                    // Show an error message or handle incorrect passcode
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
          ),
        );
      },
    );
  }

  void _showEmergencyContactConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Emergency Contact'),
          content: const Text('Are you sure you want to call your emergency contact?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _makeEmergencyCall();
                Navigator.of(context).pop();
              },
              child: const Text('Call'),
            ),
          ],
        );
      },
    );
  }

  void _makeEmergencyCall() {
    const String phoneNumber = '+915555555555'; // Replace with your emergency contact number
    AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.DIAL',
      data: 'tel:$phoneNumber',
    );
    intent.launch();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
