import 'package:flutter/material.dart';
import '../components/feature_card.dart';
import '../components/custom_button.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top gradient section
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.42, // ← slightly taller looks better on most phones
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF00C850),
                    Color(0xFFFFFFFF),
                  ],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Image.asset(
                    'assets/images/Logo.png',
                    height: 160,           // ← little bigger logo usually looks nicer
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32), // ← more breathing room

            const FeatureCard(
              iconPath: "assets/icons/queue.svg",
              title: "Skip the Queue",
              subtitle: "No more standing in long Govt. office lines",
              iconBgColor: Color(0xFFE6F6EA),
              iconColor: Color(0xFF22C55E),
            ),
            const FeatureCard(
              iconPath: "assets/icons/agent.svg",
              title: "Trusted Local Agents",
              subtitle: "Connect with verified agents near you", // ← improved text suggestion
              iconBgColor: Color(0xFFE3F6FA),
              iconColor: Color(0xFF06B6D4),
            ),
            const FeatureCard(
              iconPath: "assets/icons/secure.svg",
              title: "Safe & Secure",
              subtitle: "Escrow payments + document encryption",
              iconBgColor: Color(0xFFF1E9FF),
              iconColor: Color(0xFF7C3AED),
            ),
            const FeatureCard(
              iconPath: "assets/icons/history.svg",
              title: "Real-Time Updates",
              subtitle: "Live tracking of your application/task",
              iconBgColor: Color(0xFFFBF3D6),
              iconColor: Color(0xFFEAB308),
            ),

            const SizedBox(height: 120), // ← more space so button doesn't feel cramped
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32), // ← better padding on modern phones
          child: CustomButton(
            text: "Get Started",
            onPressed: () async {     // ← add async here
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ),
      ),
    );
  }
}