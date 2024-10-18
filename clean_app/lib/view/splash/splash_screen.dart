
import 'package:clean_app/view/adminView/admin_view.dart';
import 'package:clean_app/view/login/login_page.dart';
import 'package:clean_app/view/userView/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin{
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Future.delayed(const Duration(seconds:2), () {

      var box = Hive.box('userBox');
      String? userId = box.get('userId');
      bool? isAdmin = box.get('isAdmin');

      if (userId != null) {
        if (isAdmin == true) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminView()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });

  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays:SystemUiOverlay.values);
    super.dispose();
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 84, 64, 140),
          ),
          child: Image.asset(
            "assets/splash.png",
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
          )
      ),
    );

  }

}