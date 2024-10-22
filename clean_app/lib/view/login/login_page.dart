
import 'package:clean_app/services/auth_services.dart';
import 'package:clean_app/view/login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'reset_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /*
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
                         */
                      ],
                    ),
                    SizedBox(height: 40.h,),
                    Center(
                      child: Lottie.asset(
                        'assets/animations/login_animation.json',
                        height: 200,
                        width: 200,
                      ),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Text("Hoşgeldiniz 👋",
                        style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: const Color.fromARGB(255, 18, 18, 18))),
                    const SizedBox(
                      height: 7,
                    ),
                    Text("Hesabınıza giriş yapın",
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
                    Text(
                      "Şifre",
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
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromARGB(255, 250, 250, 250))),
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
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordPage()));
                            },
                            child: Text("Şifrenizi mi unuttunuz?",
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: const Color.fromARGB(255, 84, 64, 140),
                                )))),
                    const SizedBox(height: 15),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await AuthService().signin(
                          context: context,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD1461E),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48),
                        ),
                      ),
                      child: Text(
                        "Giriş Yap",
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Hesabınız yok mu?",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: const Color.fromARGB(255, 166, 166, 166),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpPage()));
                            //kayıt ol sayfası
                          },
                          child: Text("Kayıt ol",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color(0xFFD1461E)
                              ))),
                    ]),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text("Ya da",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: const Color(0xFFBEBEBE))),
                        ),
                        const Expanded(
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        AuthService().signInWithGoogle(context);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(
                          color: Color(0xFFD1461E),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/images/google.png',
                        height: 16,
                        width: 16,
                      ),
                      label: Text('Google ile giriş yap',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: const Color.fromARGB(255, 18, 18, 18))),
                    ),
                    SizedBox(height: 20.h,)
                  ]
                  )
              ),
    )));
  }
}
