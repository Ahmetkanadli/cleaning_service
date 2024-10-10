
import 'package:clean_app/login/verification.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            const SizedBox(
              height: 1,
            ),
            Text("Şifreyi Yenile",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: const Color.fromARGB(255, 18, 18, 18))),
            const SizedBox(
              height: 7,
            ),
            Text("Emailinizi girin, size bir doğrulama kodu göndereceğiz.",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: const Color.fromARGB(255, 166, 166, 166),
                )),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Email",
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: const Color.fromARGB(255, 18, 18, 18),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 250, 250, 250))),
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
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VerificationPage(
                          email: '',
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 84, 64, 140),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
                child: Text(
                  "Gönder",
                  style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: (const Color.fromARGB(255, 255, 255, 255))),
                )),
          ]),
        ),
      ),
    );
  }
}

class PasswordCongratulationPage extends StatelessWidget {
  const PasswordCongratulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/star.png',
                      width: 255,
                      height: 105,
                    ),
                    const SizedBox(height: 35),
                    Text("Şifreniz değişti!",
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        )),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                          " Şifreniz başarıyla değişti, yeni şifrenizle tekrar giriş yapabilirsiniz.",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 166, 166, 166),
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 84, 64, 140),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48),
                        ),
                      ),
                      child: Text("Giriş Yap",
                          style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color:
                                  (const Color.fromARGB(255, 255, 255, 255)))),
                    ),
                  ],
                ))));
  }
}

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureText = true;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
              const SizedBox(
                height: 20,
              ),
              Text(
                "Yeni Şifre",
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: const Color.fromARGB(255, 18, 18, 18),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                "Hesabınıza giriş yapmak için yeni bir şifre belirleyin",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: const Color.fromARGB(255, 166, 166, 166),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Yeni Şifre",
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
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Şifreyi Onayla",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 18, 18, 18),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 250, 250, 250),
                    ),
                  ),
                  labelText: "Şifrenizi Onaylayın",
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
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Hata mesajı
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Şifre eşleşmesi kontrolü
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    setState(() {
                      _errorMessage = 'Şifreler eşleşmiyor!';
                    });
                  } else {
                    setState(() {
                      _errorMessage = '';
                    });
                    // Şifreler eşleşiyorsa sayfa geçişi
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PasswordCongratulationPage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 84, 64, 140),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
                child: Text(
                  "Gönder",
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
      ),
    );
  }
}
