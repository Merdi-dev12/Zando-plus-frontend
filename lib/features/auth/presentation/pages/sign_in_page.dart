import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  bool _isLoading = false;

  // URLs des icônes officielles en ligne
  final String googleIconUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_\"G\"_logo.svg/1200px-Google_\"G\"_logo.svg.png";
  final String appleIconUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/1667px-Apple_logo_black.svg.png";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "Veuillez remplir tous les champs");
      return;
    }
    if (password.length < 6) {
      setState(() => _errorMessage =
          "Le mot de passe doit contenir au moins 6 caractères");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authProvider.notifier).login(email, password);
      if (mounted) context.go('/');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Email ou mot de passe incorrect";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Lottie.asset('assets/animations/register.json', height: 180),
            const Text("Sign In",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "Connectez-vous pour continuer vos achats",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(_errorMessage!,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ),
            _buildInputField(
                _emailController, "Email Address", Icons.email_outlined, false),
            const SizedBox(height: 15),
            _buildInputField(
                _passwordController, "Password", Icons.lock_outline, true),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text("Forgot Password",
                    style: TextStyle(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text("Sign In",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
            _buildSocialSection(),
            const SizedBox(height: 40),
            _buildSignUpLink(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint,
      IconData icon, bool isPass) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: controller,
        obscureText: isPass,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSocialSection() {
    return Column(
      children: [
        Row(children: [
          Expanded(child: Divider(color: Colors.grey.shade300)),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Or", style: TextStyle(color: Colors.grey))),
          Expanded(child: Divider(color: Colors.grey.shade300)),
        ]),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _socialButton(googleIconUrl),
          const SizedBox(width: 25),
          _socialButton(appleIconUrl),
        ]),
      ],
    );
  }

  Widget _socialButton(String url) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12)),
        child: Image.network(
          url,
          height: 28,
          width: 28,
          // Un loader discret pendant que l'icône se télécharge
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 1));
          },
          errorBuilder: (c, e, s) =>
              const Icon(Icons.account_circle, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("Don't Have An Account? "),
      GestureDetector(
        onTap: () => context.push('/auth/signup'),
        child: const Text("Sign Up",
            style: TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.bold)),
      ),
    ]);
  }
}
