import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/core/styles/theme.dart';
import 'package:pills_reminder/features/main_screen/presentation/screens/main_screen/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: MainScreen(),
    );
  }
}
