import 'package:clean_app/firebase_options.dart';
import 'package:clean_app/view/adminView/admin_view.dart';
import 'package:clean_app/view/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              scrolledUnderElevation: 0,
              backgroundColor: Colors.white,
              // Set AppBar background color to white
              foregroundColor: Colors.black, // Set AppBar text color to black
            ),
            scaffoldBackgroundColor:
                Colors.white, // Set Scaffold background color to white
          ),
          home: const AdminView(),
        );
      },
    );
  }
}
