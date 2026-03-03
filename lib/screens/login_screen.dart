import 'package:flutter/material.dart';
import '../theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SkillSwapColors.primary.withOpacity(0.05),
              Colors.white,
              SkillSwapColors.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(),
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [SkillSwapColors.primary, SkillSwapColors.secondary],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: SkillSwapColors.primary.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'S',
                          style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'SkillSwap',
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: SkillSwapColors.textHeader),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Learn, teach, and grow together',
                      style: TextStyle(fontSize: 16, color: SkillSwapColors.textBody),
                    ),
                  ],
                ),
                const Spacer(),
                _buildSocialButton(
                  iconPath: 'assets/google_logo.png', // Placeholder for actual icon
                  label: 'Continue with Google',
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  icon: Icons.apple,
                  label: 'Continue with Apple',
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('or', style: TextStyle(color: SkillSwapColors.textBody)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mail_outline),
                      SizedBox(width: 12),
                      Text('Continue with Email'),
                      Spacer(),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text.rich(
                  TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: TextStyle(fontSize: 12, color: SkillSwapColors.textBody),
                    children: [
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(color: SkillSwapColors.primary, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: SkillSwapColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    String? iconPath,
    IconData? icon,
    required String label,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.white,
    Color textColor = SkillSwapColors.textHeader,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: backgroundColor == Colors.white ? Border.all(color: Colors.grey.shade200, width: 2) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) Icon(icon, color: textColor, size: 24),
                // For Google, we'd use an Image widget here if we had the asset
                if (icon == null && iconPath != null) 
                  const Icon(Icons.g_mobiledata, color: Colors.blue, size: 32),
                const SizedBox(width: 12),
                Text(label, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
