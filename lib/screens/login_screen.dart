import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _isLogin = true;

  Future<void> _submitEmail() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        if (_nameController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a login name.')),
          );
          if (mounted) setState(() => _isLoading = false);
          return;
        }
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await cred.user?.updateDisplayName(_nameController.text.trim());
        
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'points': 0,
          'exchanges': 0,
          'lessons': 0,
          'rating': 0.0,
          'teaching_skills': [],
          'learning_skills': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      if (mounted) Navigator.pushReplacementNamed(context, '/home'); // Let AuthWrapper handle it or push manually.
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final cred = await FirebaseAuth.instance.signInWithCredential(credential);
        final doc = await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).get();
        if (!doc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
            'name': cred.user!.displayName ?? 'User',
            'email': cred.user!.email ?? '',
            'points': 0,
            'exchanges': 0,
            'lessons': 0,
            'rating': 0.0,
            'teaching_skills': [],
            'learning_skills': [],
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => _isLoading = true);
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      final cred = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final doc = await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).get();
      if (!doc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
          'name': cred.user!.displayName ?? 'User',
          'email': cred.user!.email ?? '',
          'points': 0,
          'exchanges': 0,
          'lessons': 0,
          'rating': 0.0,
          'teaching_skills': [],
          'learning_skills': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Apple Sign-In failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
              ? [SkillSwapColors.backgroundDark, const Color(0xFF1E293B)]
              : [SkillSwapColors.primary.withOpacity(0.05), Colors.white, SkillSwapColors.secondary.withOpacity(0.05)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildLogoHeader(context),
                const SizedBox(height: 40),
                _buildEmailForm(context),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitEmail,
                        child: Text(
                          _isLogin ? 'Login' : 'Register',
                        ),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin
                        ? 'Don\'t have an account? Register'
                        : 'Already have an account? Login',
                    style: TextStyle(
                      color: isDark ? theme.colorScheme.secondary : SkillSwapColors.primary, 
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: theme.dividerColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('or continue with', style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6))),
                      ),
                      Expanded(child: Divider(color: theme.dividerColor)),
                    ],
                  ),
                ),
                _buildSocialButton(
                  context: context,
                  iconPath: 'assets/google_logo.png',
                  label: 'Google',
                  onPressed: _isLoading ? () {} : _signInWithGoogle,
                ),
                const SizedBox(height: 16),
                _buildSocialButton(
                  context: context,
                  icon: Icons.apple,
                  label: 'Apple',
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  textColor: isDark ? Colors.black : Colors.white,
                  onPressed: _isLoading ? () {} : _signInWithApple,
                ),
                const SizedBox(height: 32),
                Text.rich(
                  TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color),
                    children: [
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
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
        Text(
          'SkillSwap',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: theme.textTheme.headlineLarge?.color),
        ),
        const SizedBox(height: 8),
        Text(
          _isLogin ? 'Welcome back!' : 'Create your account',
          style: TextStyle(fontSize: 16, color: theme.textTheme.bodyMedium?.color),
        ),
      ],
    );
  }

  Widget _buildEmailForm(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Column(
      children: [
        if (!_isLogin) ...[
          _buildTextField(
            context: context,
            controller: _nameController,
            hint: 'Login name',
            icon: Icons.person_outline,
            type: TextInputType.name,
          ),
          const SizedBox(height: 16),
        ],
        _buildTextField(
          context: context,
          controller: _emailController,
          hint: 'Email address',
          icon: Icons.email_outlined,
          type: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          context: context,
          controller: _passwordController,
          hint: 'Password',
          icon: Icons.lock_outline,
          obscure: true,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType type = TextInputType.text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: type,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: theme.colorScheme.primary.withOpacity(0.7)),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    String? iconPath,
    IconData? icon,
    required String label,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    
    final bg = backgroundColor ?? (isDark ? theme.cardColor : Colors.white);
    final text = textColor ?? theme.textTheme.bodyLarge?.color;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
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
                if (icon != null) Icon(icon, color: text, size: 24),
                if (icon == null) 
                  const Icon(Icons.g_mobiledata, color: Colors.blue, size: 32),
                const SizedBox(width: 12),
                Text('Continue with $label', style: TextStyle(color: text, fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
