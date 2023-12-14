import 'package:flutter/material.dart';
import 'package:movie_night/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.light(
          primary: Colors.blue.shade700,
          onPrimary: Colors.white,
          secondary: Colors.black,
          background: Colors.blue.shade100,
          onBackground: Colors.black,
          brightness: Brightness.light,
        ),
        fontFamily: 'Afacad',
        textTheme: TextTheme(
          displayMedium: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
          displayLarge: const TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black),
          displaySmall: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 22.0, color: Colors.blue.shade500),
          headlineLarge: const TextStyle(fontSize: 22.0, color: Colors.black),
          labelLarge: const TextStyle(fontSize: 22.0, color: Colors.white)
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
        useMaterial3: true,
      ),

      home: const WelcomeScreen(),
      
    );
  }
}