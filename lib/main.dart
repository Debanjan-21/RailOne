import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/rail_colors.dart';
import 'screens/station_selection_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: RailColors.primaryNavy,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const RailOneApp());
}

class RailOneApp extends StatelessWidget {
  const RailOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RailOne - Indian Railways',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: RailColors.primaryNavy,
        scaffoldBackgroundColor: RailColors.bgSurface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RailColors.primaryNavy,
          primary: RailColors.primaryNavy,
          secondary: RailColors.saffronOrange,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: RailColors.primaryNavy,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const StationSelectionScreen(),
    );
  }
}
