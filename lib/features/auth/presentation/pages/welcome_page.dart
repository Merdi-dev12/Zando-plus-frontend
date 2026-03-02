import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Spacer(),
              // --- TA LOTTIE FILE ICI ---
              Lottie.asset(
                'assets/animations/register.json', 
                height: 300,
                repeat: true,
              ),
              const SizedBox(height: 40),
              const Text(
                "Find All You Need Online,\nExplore & Easy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const Spacer(),
              // --- BOUTONS ---
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      label: "Sign Up",
                      color: AppColors.primary,
                      textColor: Colors.white,
                      onTap: () => context.push('/auth/signup'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildButton(
                      label: "Sign In",
                      color: Colors.grey.shade100,
                      textColor: Colors.black,
                      onTap: () => context.push('/auth/signin'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
