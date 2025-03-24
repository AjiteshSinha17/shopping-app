
import 'package:flutter/material.dart';
// import 'package:shopping_app/grocery_items.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/widget/grocery_items.dart';

final theme =  ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
         textTheme: GoogleFonts.latoTextTheme().copyWith(
    bodyLarge: GoogleFonts.lato(
      color: Colors.white, // Customize the color here
    ),
    bodyMedium: GoogleFonts.lato(
      color: Colors.grey[300], // Different color for medium text
    ),
    bodySmall: GoogleFonts.lato(
      color: Colors.grey[400], // Different color for small text
    ),
    headlineLarge: GoogleFonts.lato(
      color: Colors.cyanAccent, // Customize headline color
    ),
  )
        
      );

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme ,
      home:const  ItemsMain() ,
      
      )
    ;
  }
}
