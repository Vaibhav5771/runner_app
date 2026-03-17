import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/pages/home_screen.dart';


class AppRoutes {
  static const String splash = "/";
  static const String login = "/login";
  static const String register = '/register';
  static const String home = "/home";

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
  };
}