import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jangoldi_jharna_academy/providers/auth_provider.dart';
import 'package:jangoldi_jharna_academy/screens/dashboard/dashboard_screen.dart';

class StudentLoginScreen extends ConsumerStatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  ConsumerState<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends ConsumerState<StudentLoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    await ref.read(authProvider.notifier).login(username, password);

    final loginState = ref.read(authProvider);
    if (loginState is AsyncData && loginState.value != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else if (loginState is AsyncError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loginState.error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.teal,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Column(
              children: [
                Image.asset(
                  'assets/edusoft.png',
                  height: 158,
                  width: 158,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
              ],
            ),
            SizedBox(height: 40),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Hi Student',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Sign in to continue',
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                  ),
                  Center(
                    child: TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  const SizedBox(height: 24),
                  Center(
                    child: loginState.isLoading
                        ? const CircularProgressIndicator()
                        : Center(
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text(
                          'Login',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
