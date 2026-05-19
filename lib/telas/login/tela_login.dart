import 'package:fluire/rotas.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF0F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 420,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 40,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EDE0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.waves,
                    color: Color(0xFFBFA07A),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),

                // Título
                const Text(
                  'Welcome to Fluirê',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                ),
                const SizedBox(height: 32),

                // Botão Google
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://www.google.com/favicon.ico',
                        width: 20,
                        height: 20,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.g_mobiledata,
                          size: 22,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF222222),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Divisor OR
                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFAAAAAA),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFE0E0E0))),
                  ],
                ),
                const SizedBox(height: 24),

                // Label Email
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Campo Email
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'you@example.com',
                    hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
                    prefixIcon: const Icon(
                      Icons.mail_outline,
                      color: Color(0xFFBBBBBB),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF222222),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Label Password
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Campo Password
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFFBBBBBB),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF222222),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botão Sign In
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF111111),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Footer links
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        Rotas.cadastro,
                      ), // <-- navegação
                      child: RichText(
                        text: const TextSpan(
                          text: 'Need an account? ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF888888),
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111111),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
