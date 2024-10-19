import 'package:clean_app/view/userView/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clean_app/services/database_operations.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _currentPasswordController;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var box = Hive.box('userBox');
    _nameController.text = box.get('userName', defaultValue: '');
    _emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
  }

  Future<void> _updateUserData() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yeni şifre ve onay şifresi eşleşmiyor')),
      );
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Kullanıcıyı yeniden kimlik doğrulaması için zorlayın
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);

        var box = Hive.box('userBox');
        await box.put('userName', _nameController.text);

        if (_newPasswordController.text.isNotEmpty) {
          await user.updatePassword(_newPasswordController.text);
        }
        await DataBaseOperations().updateUserProfile(
          user.uid,
          _nameController.text,
          newPassword: _newPasswordController.text.isNotEmpty ? _newPasswordController.text : null,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil başarıyla güncellendi')),
        );
      }
    } catch (e) {
      print('Hata: $e');
      String errorMessage = 'Profil güncellenirken hata oluştu';
      if (e is FirebaseAuthException) {
        if (e.code == 'wrong-password') {
          errorMessage = 'Mevcut şifre yanlış';
        } else if (e.code == 'requires-recent-login') {
          errorMessage = 'Bu işlem için yeniden giriş yapmanız gerekiyor';
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profilim', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFD1461E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFD1461E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 100.r,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Profilini Düzenle',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  _buildTextField(_nameController, 'İsim', Icons.person),
                  SizedBox(height: 15.h),
                  _buildTextField(_emailController, 'E-posta', Icons.email, enabled: false),
                  SizedBox(height: 15.h),
                  _buildTextField(_currentPasswordController, 'Mevcut Şifre', Icons.lock, isPassword: true),
                  SizedBox(height: 15.h),
                  _buildTextField(_newPasswordController, 'Yeni Şifre', Icons.lock, isPassword: true),
                  SizedBox(height: 15.h),
                  _buildTextField(_confirmPasswordController, 'Şifreni Doğrula', Icons.lock, isPassword: true),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: _updateUserData,
                    child: Text(
                      'Güncelle',
                      style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD1461E),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool enabled = true, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: isPassword,
        style: GoogleFonts.inter(fontSize: 16.sp),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.grey),
          prefixIcon: Icon(icon, color: const Color(0xFFD1461E)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: const Color(0xFFD1461E), width: 2),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }
}
