
import 'package:clean_app/view/adminView/admin_view.dart';
import 'package:clean_app/view/login/sign_up.dart';
import 'package:clean_app/view/userView/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signup({
  required String name,
  required String email,
  required String password,
  required BuildContext context,
}) async {
  String errorMessage = '';

  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential != null) {
      await credential.user?.sendEmailVerification();

      // Firestore'a kullanıcı belgesi ekleme
      String docID = credential.user?.uid ?? '';
      await _firestore.collection('users').doc(docID).set({
        'name': name,
        'email': email,
        'docID': docID, // Add docID to the Firestore document
        'createdAt': FieldValue.serverTimestamp(),
        "isAdmin": false,
      });

      _showErrorDialog(context, "Bilgi", "Kayıt başarılı, doğrulama e-postası gönderildi.", () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const CongratulationPage()),
        );
      });
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      errorMessage = "Şifre çok zayıf.";
    } else if (e.code == 'email-already-in-use') {
      errorMessage = "Bu e-posta adresi zaten kullanımda.";
    } else if (e.code == 'invalid-email') {
      errorMessage = "Geçersiz e-posta adresi.";
    } else if (e.code == 'network-request-failed') {
      errorMessage = 'Bağlantı hatası. Lütfen internet bağlantınızı kontrol edin.';
    } else {
      print("hata : ${e.code}");
      errorMessage = "Kayıt sırasında bir hata oluştu: ${e.message}";
    }
  } catch (e) {
    print("hata : ${e.toString()}");
    errorMessage = "Bilinmeyen bir hata oluştu.";
  }

  if (errorMessage != '') {
    _showErrorDialog(context, "Hata", errorMessage, () {
      Navigator.of(context).pop();
    });
  }
}

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential _user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_user.user!.uid.isNotEmpty) {
        if (_user.user!.emailVerified == true) {

          // Kullanıcı ID'sini cihazda saklama
          var box = Hive.box('userBox');
          box.put('userId', _user.user!.uid);

          // Kullanıcı adını cihazda saklama
          box.put('userEmail', email);

          // Kullanıcı adını cihazda saklama
          DocumentSnapshot userDoc = await _firestore.collection('users').doc(_user.user!.uid).get();
          String userName = userDoc['name'];
          bool isAdmin = userDoc['isAdmin'];
          box.put('userName', userName);
          box.put('isAdmin', isAdmin);
          print("isAdmin : ${box.get('isAdmin')}");

          if(isAdmin == true){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const AdminView()),
            );
          }
          else{
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
            );
          }
        } else {
          await _user.user!.sendEmailVerification();
          _showErrorDialog(context, "Bilgi", 'E-posta doğrulaması gerekiyor. Lütfen e-postanızı kontrol edin.', () {
            Navigator.of(context).pop();
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'Kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password') {
        message = 'Yanlış şifre.';
      }else if(e.code == 'invalid-email'){
        message = 'Geçersiz e-posta adresi.';
      }else if(e.code == 'invalid-credential'){
        message = 'e-posta adresi veya şifre hatalı.';
      } else {
        print("hata : ${e.code}");
        message = 'Giriş sırasında bir hata oluştu.';
      }
      print("hata : ${e.code}");
      _showErrorDialog(context, "Hata", message, () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      _showErrorDialog(context, "Hata", 'Bilinmeyen bir hata oluştu.', () {
        Navigator.of(context).pop();
      });
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        _showErrorDialog(context, "Hata", 'Google ile giriş iptal edildi.', () {
          Navigator.of(context).pop();
        });
        return;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      _showErrorDialog(context, "Hata", 'Google ile giriş sırasında bir hata oluştu.', () {
        Navigator.of(context).pop();
      });
    }
  }

  Future<void> sendPasswordResetLink(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showErrorDialog(context, "Bilgi", 'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.', () {
        Navigator.of(context).pop();
      });
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'Kullanıcı bulunamadı.';
      } else {
        message = 'Şifre sıfırlama sırasında bir hata oluştu.';
      }
      _showErrorDialog(context, "Hata", message, () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      _showErrorDialog(context, "Hata", 'Bilinmeyen bir hata oluştu.', () {
        Navigator.of(context).pop();
      });
    }
  }


  void _showErrorDialog(BuildContext context, String title, String message, Function onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () => onPressed(),
            ),
          ],
        );
      },
    );
  }
}