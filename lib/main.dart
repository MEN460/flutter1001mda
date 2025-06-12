// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mechanic_discovery_app/screens/map_screen.dart';
import 'package:mechanic_discovery_app/screens/profile/profile_screen.dart';
import 'package:mechanic_discovery_app/screens/profile/mechanic_profile_screen.dart';
import 'package:provider/provider.dart';

import 'package:mechanic_discovery_app/providers/auth_provider.dart';
import 'package:mechanic_discovery_app/providers/location_provider.dart';
import 'package:mechanic_discovery_app/providers/service_provider.dart';
import 'package:mechanic_discovery_app/providers/mechanic_stats_provider.dart';

import 'package:mechanic_discovery_app/screens/auth/login_screen.dart';
import 'package:mechanic_discovery_app/screens/auth/register_screen.dart';
import 'package:mechanic_discovery_app/screens/home/mechanic_home.dart';
import 'package:mechanic_discovery_app/screens/home/owner_home.dart';
import 'package:mechanic_discovery_app/screens/location/update_location.dart';
import 'package:mechanic_discovery_app/screens/service/nearby_mechanics.dart';
import 'package:mechanic_discovery_app/screens/service/nearby_requests.dart';
import 'package:mechanic_discovery_app/screens/service/request_service.dart';

import 'package:mechanic_discovery_app/services/api_service.dart';
import 'package:mechanic_discovery_app/services/auth_service.dart';
import 'package:mechanic_discovery_app/services/location_service.dart';
import 'package:mechanic_discovery_app/services/storage_service.dart';

import 'package:mechanic_discovery_app/models/user_model.dart'; // Import UserModel

import 'theme/app_theme.dart'; // ← import your theme here

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Debug .env file location
  final envFile = File('.env');
  print("Absolute path: ${envFile.absolute.path}");
  print("File exists: ${await envFile.exists()}");

  // Load .env with error handling
  try {
    await dotenv.load(fileName: ".env");
    print("API_URL: ${dotenv.env['API_URL'] ?? 'NOT FOUND'}");
  } catch (e) {
    print("Error loading .env: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MechanicStatsProvider()),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(LocationService()),
        ),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        // ...other providers...
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mechanic Discovery',
      theme: AppTheme.lightTheme, // ← applied light theme here
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) {
          final authProvider = context.read<AuthProvider>();
          return authProvider.isMechanic
              ? const MechanicHomeScreen()
              : const OwnerHomeScreen();
        },
        '/profile': (context) => const ProfileScreen(),
        '/map': (context) => const MapScreen(),
        '/update-location': (context) => const UpdateLocationScreen(),
        '/request-service': (context) => const RequestServiceScreen(),
        '/nearby-mechanics': (context) => const NearbyMechanicsScreen(),
        '/nearby-requests': (context) => const NearbyRequestsScreen(),
        '/service-requests': (context) => const RequestServiceScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/mechanic-profile') {
          final mechanic = settings.arguments as UserModel;
          return MaterialPageRoute(
            builder: (context) => MechanicProfileScreen(mechanic: mechanic),
          );
        }
        return null;
      },
    );
  }
}
