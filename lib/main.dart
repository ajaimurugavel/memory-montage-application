import 'package:flutter/material.dart';
import 'package:memory_montage_lite/game_levels/level3_screen.dart';

import 'game_levels/fun_facts.dart';
import 'game_levels/level1_screen.dart';
import 'game_levels/level2_screen.dart';
import 'games_screen.dart';
import 'home_screen.dart';
import 'memory_box_screen.dart';
import 'reminder_screen.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';
import 'wearable_connection_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SignUpScreen(),
        '/signin': (context) => SignInScreen(),
        '/home': (context) => HomePage(),
        '/games': (context) => GamesScreen(),
        '/memory_box': (context) => MemoryBoxScreen(),
        '/wearable_connection': (context) => WearableConnectionScreen(),
        '/reminders': (context) => ReminderScreen(),
        '/level1': (context) => Level1Screen(),
        '/level2': (context) => Level2Screen(),
        '/level3': (context) => Level3Screen(),
        '/level': (context) => FunFactsScreen()
      },
    );
  }
}
