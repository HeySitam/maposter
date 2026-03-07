import 'package:flutter/material.dart';
import 'package:map_to_poster/core/styles/app_styles.dart';
import 'package:map_to_poster/features/poster/presentation/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    AppStyles.init(context);
    return MaterialApp(
      title: 'Map to Poster',
      debugShowCheckedModeBanner: false,
      theme: AppColors.toThemeData(),
      home: const HomeScreen(),
    );
  }
}
