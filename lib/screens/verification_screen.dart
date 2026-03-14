import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppTheme.textSoft,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Verify OTP',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                const Text.rich(
                  TextSpan(
                    text: 'We\'ve sent a 6-digit verification code to ',
                    style: TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text: '+91 98765 43210',
                        style: TextStyle(
                          color: AppTheme.text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text:
                            '. Please enter it below to secure your account.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 42),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 52,
                      height: 72,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: index < 2
                              ? AppTheme.primaryDeep
                              : AppTheme.border,
                        ),
                      ),
                      child: Text(
                        index == 0
                            ? '7'
                            : index == 1
                            ? '4'
                            : '',
                        style: const TextStyle(
                          color: AppTheme.text,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 38),
                Center(
                  child: RichText(
                    text: const TextSpan(
                      text: 'Didn\'t receive code? ',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: 'Resend Code',
                          style: TextStyle(
                            color: AppTheme.primaryDeep,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Center(
                  child: Text(
                    'CHANGE PHONE NUMBER',
                    style: TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Spacer(),
                const Center(
                  child: Text(
                    'CRICPULSE',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppTheme.heroGradient,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.28),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text('VERIFY & PROCEED'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
