import 'package:flutter/material.dart';
import 'package:shopping_list_app/widget/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
    title: 'Flutter Groceries',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF80CBC4), // Calm teal (Material You vibe)
    brightness: Brightness.dark,
    surface: const Color(0xFF1F1F1F),   // Soft dark surface
  ),
  scaffoldBackgroundColor: const Color(0xFF121212), // true dark
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1C1C1E),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.white70,
    ),
  ),
  cardColor: const Color(0xFF232323),
  iconTheme: const IconThemeData(color: Colors.white70),
),
      home: const GroceryList(),
    );
  }
}