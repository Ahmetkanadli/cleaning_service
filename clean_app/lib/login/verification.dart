
import 'package:clean_app/login/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationPage extends StatefulWidget {
  final String email; // Email adresi buradan alınacak

  const VerificationPage({super.key, required this.email});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String enteredCode = '';

  // Girilen sayıları yöneten controller
  TextEditingController pinController = TextEditingController();

  void _onKeyTap(String value) {
    setState(() {
      enteredCode += value;
      pinController.text = enteredCode; // TextField güncelle
    });
  }

  void _onBackspace() {
    if (enteredCode.isNotEmpty) {
      setState(() {
        enteredCode = enteredCode.substring(0, enteredCode.length - 1);
        pinController.text = enteredCode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
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
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Email Doğrulama",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: const Color.fromARGB(255, 18, 18, 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Center(
                    child: Text(
                      "Lütfen size gönderdiğimiz maildeki kodu giriniz.",
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: const Color.fromARGB(255, 166, 166, 166),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      widget.email, // Email'i göster
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: const Color.fromARGB(255, 18, 18, 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  PinCodeTextField(
                    appContext: context,
                    controller: pinController,
                    length: 4,
                    onChanged: (value) {
                      setState(() {
                        enteredCode = value;
                      });
                    },
                    keyboardType: TextInputType.none,
                    pinTheme: PinTheme(
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: const Color.fromARGB(255, 250, 250, 250),
                      selectedFillColor:
                          const Color.fromARGB(255, 250, 250, 250),
                      inactiveFillColor:
                          const Color.fromARGB(255, 250, 250, 250),
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.white,
                    enableActiveFill: true,
                    animationType: AnimationType.scale,
                    animationDuration: const Duration(milliseconds: 300),
                  ),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Kodu alamadınız mı?",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color.fromARGB(255, 166, 166, 166),
                        )),
                    TextButton(
                        onPressed: () {},
                        child: Text("Tekrar gönder",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 84, 64, 140),
                            ))),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewPasswordPage()));
                      print("Doğrulama kodu: $enteredCode");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 84, 64, 140),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                    ),
                    child: Text(
                      "İleri",
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: (const Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              color: const Color.fromARGB(255, 84, 64, 140), // Arka plan mor
              child: _buildNumberPad(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildNumberButton('.'),
            _buildNumberButton('0'),
            _buildBackspaceButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => _onKeyTap(number),
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 84, 64, 140),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          number,
          style: const TextStyle(
              fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: _onBackspace,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 84, 64, 140),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.backspace_outlined,
            color: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }
}
