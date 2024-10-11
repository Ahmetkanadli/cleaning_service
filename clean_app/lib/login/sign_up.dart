
import 'package:clean_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String password = '';
  bool hasEightCharacters = false;
  bool hasNumber = false;
  bool hasLetter = false;
  bool _obscureText = true;
  bool showPasswordRequirements = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void validatePassword(String value) {
    setState(() {
      password = value;
      hasEightCharacters = value.length >= 8;
      hasNumber = value.contains(RegExp(r'[0-9]'));
      hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
      showPasswordRequirements = value.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: Image.asset(
                        'assets/images/back.png',
                        height: 40,
                        width: 40,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  "Kayıt ol",
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: const Color.fromARGB(255, 18, 18, 18),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  "Rüyalarınızı yorumlatmak için kayıt olun",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: const Color.fromARGB(255, 166, 166, 166),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "İsim",
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 18, 18, 18),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 250, 250, 250),
                      ),
                    ),
                    labelText: "İsminiz",
                    labelStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 184, 184, 184),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 250, 250),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Email",
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 18, 18, 18),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 250, 250, 250),
                      ),
                    ),
                    labelText: "Mailiniz",
                    labelStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 184, 184, 184),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 250, 250),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Şifre",
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 18, 18, 18),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  onChanged: (value) => validatePassword(value),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 250, 250, 250),
                      ),
                    ),
                    labelText: "Şifreniz",
                    labelStyle: GoogleFonts.roboto(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 184, 184, 184),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 250, 250),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Transform.scale(
                        scale: 0.75,
                        child: Image.asset(
                          _obscureText
                              ? 'assets/images/visibility.png'
                              : 'assets/images/visibility.png',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (showPasswordRequirements)
                  PasswordRequirements(
                    hasEightCharacters: hasEightCharacters,
                    hasNumber: hasNumber,
                    hasLetter: hasLetter,
                  ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: hasEightCharacters && hasNumber && hasLetter
                      ? () async {
                    AuthService().signup(email: _emailController.text,
                        password: _passwordController.text, context: context);
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 84, 64, 140),
                    disabledBackgroundColor:
                    const Color.fromARGB(255, 84, 64, 140),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                  child: Text(
                    "Kayıt ol",
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hesabınız var mı?",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color.fromARGB(255, 166, 166, 166),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      child: Text(
                        "Giriş Yap",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color.fromARGB(255, 84, 64, 140),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordRequirements extends StatelessWidget {
  final bool hasEightCharacters;
  final bool hasNumber;
  final bool hasLetter;

  const PasswordRequirements({
    super.key,
    required this.hasEightCharacters,
    required this.hasNumber,
    required this.hasLetter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PasswordRequirementItem(
          label: "En az 8 karakter",
          isValid: hasEightCharacters,
        ),
        const SizedBox(
          height: 5,
        ),
        PasswordRequirementItem(
          label: "Bir sayı içermeli",
          isValid: hasNumber,
        ),
        const SizedBox(
          height: 5,
        ),
        PasswordRequirementItem(
          label: "Bir harf içermeli",
          isValid: hasLetter,
        ),
      ],
    );
  }
}

class PasswordRequirementItem extends StatelessWidget {
  final String label;
  final bool isValid;

  const PasswordRequirementItem({
    super.key,
    required this.label,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check : Icons.close,
          color:
          isValid ? const Color.fromARGB(255, 162, 140, 224) : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            color:
            const Color.fromARGB(255, 166, 166, 166), // Sabit metin rengi
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class CongratulationPage extends StatelessWidget {
  const CongratulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/star.png',
            ),
            const SizedBox(height: 15),
            Text(
              "Tebrikler!",
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: const Color(0xFF121212),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                "Hesabınız hazır. Rüyalarınızı anlamlandırma zamanı.",
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFA6A6A6),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                // Push and remove until the login page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 84, 64, 140),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(48),
                ),
              ),
              child: Text(
                "Başlayın",
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
