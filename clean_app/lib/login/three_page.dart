
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: Text(
                    'Atla',
                    style: GoogleFonts.roboto(
                      color: const Color.fromARGB(255, 84, 64, 140),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 320,
                height: 320,
                child: Image.asset(
                  'assets/images/first.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Now reading books will be easier",
                style: GoogleFonts.openSans(
                  color: const Color.fromARGB(255, 18, 18, 18),
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                "Discover new worlds, join a vibrant reading community. Start your reading adventure effortlessly with us.",
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 166, 166, 166),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Color.fromARGB(255, 84, 64, 140),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Color.fromARGB(255, 232, 232, 232),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Color(0xFFE8E8E8),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SecondOnBoardingPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: const Color(0xFF54408C),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    "İleri",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: Text(
                  "Kayıt ol",
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: const Color(0xFF54408C),
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

class SecondOnBoardingPage extends StatelessWidget {
  const SecondOnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: Text(
                    'Atla',
                    style: GoogleFonts.roboto(
                      color: const Color.fromARGB(255, 84, 64, 140),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 320,
                height: 320,
                child: Image.asset(
                  'assets/images/second.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Your Bookish Soulmate Awaits",
                style: GoogleFonts.openSans(
                  color: const Color.fromARGB(255, 18, 18, 18),
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                "Let us be your guide to the perfect read. Discover books tailored to your tastes for a truly rewarding experience.",
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 166, 166, 166),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Color.fromARGB(255, 232, 232, 232),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Color.fromARGB(255, 84, 64, 140),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Color(0xFFE8E8E8),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 350,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ThirdOnBoardingPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: const Color(0xFF54408C),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    "Başla",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: Text(
                  "Kayıt ol",
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: const Color(0xFF54408C),
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

class ThirdOnBoardingPage extends StatelessWidget {
  const ThirdOnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: Text(
                    'Atla',
                    style: GoogleFonts.roboto(
                      color: const Color.fromARGB(255, 84, 64, 140),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 320,
                height: 320,
                child: Image.asset(
                  'assets/images/third.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Start Your Adventure",
                style: GoogleFonts.openSans(
                  color: const Color.fromARGB(255, 18, 18, 18),
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),
              Text(
                "Ready to embark on a quest for inspiration and knowledge? Your adventure begins now. Let's go!",
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 166, 166, 166),
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Color.fromARGB(255, 232, 232, 232),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Color(0xFFE8E8E8),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Color.fromARGB(255, 84, 64, 140),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 350,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: const Color(0xFF54408C),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    "Başla",
                    style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
