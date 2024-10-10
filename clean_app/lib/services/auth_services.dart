import 'package:clean_app/home_page.dart';
import 'package:clean_app/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String errorMessage = '';

    try {

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential != null) {
        await credential.user?.sendEmailVerification();
        _showErrorDialog(context, "Bilgi",
            "Kayıt başarılı, doğrulama e-postası gönderildi.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = "Şifre çok zayıf.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "Bu e-posta adresi zaten kullanımda.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Geçersiz e-posta adresi.";
      } else {
        errorMessage = "Kayıt sırasında bir hata oluştu: ${e.message}";
      }
    } catch (e) {
      errorMessage = "Bilinmeyen bir hata oluştu.";
    }

    if (errorMessage != '') {
      print("error message1 ${errorMessage}");
      _showErrorDialog(context, "Hata", errorMessage);
      return;
    } else {
      print("error message2 ${errorMessage}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage()),
      );
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential _user =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_user.user!.uid.isNotEmpty) {
        if (_user.user!.emailVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const HomePage()),
          );
        } else {
          await _user.user!.sendEmailVerification();
          _showErrorDialog(context, "Bilgi",
              'E-posta doğrulaması gerekiyor. Lütfen e-postanızı kontrol edin.');
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'Kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password') {
        message = 'Yanlış şifre.';
      } else {
        message = 'Giriş sırasında bir hata oluştu.';
      }
      _showErrorDialog(context, "Hata", message);
    } catch (e) {
      _showErrorDialog(context, "Hata", 'Bilinmeyen bir hata oluştu.');
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        _showErrorDialog(context, "Hata", 'Google ile giriş iptal edildi.');
        return;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      _showErrorDialog(
          context, "Hata", 'Google ile giriş sırasında bir hata oluştu.');
    }
  }

  Future<void> sendPasswordResetLink(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showErrorDialog(context, "Bilgi",
          'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'Kullanıcı bulunamadı.';
      } else {
        message = 'Şifre sıfırlama sırasında bir hata oluştu.';
      }
      _showErrorDialog(context, "Hata", message);
    } catch (e) {
      _showErrorDialog(context, "Hata", 'Bilinmeyen bir hata oluştu.');
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
