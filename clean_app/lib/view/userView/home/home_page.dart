
import 'package:clean_app/services/database_operations.dart';
import 'package:clean_app/view/userView/pastServices/past_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widget/popup.dart'; // Import the updated widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _homeAnimationController;
  late String userName;

  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _homeAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _controller.forward();
    _homeAnimationController.forward();

    // Retrieve the user's name from Hive asynchronously
    _retrieveUserName();
  }

  Future<void> _retrieveUserName() async {
    var box = Hive.box('userBox');
    userName = box.get('userName', defaultValue: 'Hoşgeldiniz');
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final String pageName_1 = "Ev Temizliği";
  final String pageName_2 = "Ofis Temizliği";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10.r),
          ),
        ),
        backgroundColor: const Color(0xFFD1461E).withOpacity(0.9),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                width: 50.w,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(
                    CupertinoIcons.person,
                    size: 30.w,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Text(
              userName,
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Lottie.asset(
                'assets/animations/clean_animation_orange.json',
                width: 300.w,
                repeat: true,
              ),
              SizedBox(height: 70.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    key: Key(pageName_1),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MultiPagePopup(pageName: pageName_1);
                        },
                      );
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Container(
                        width: 150.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/home_animation.json',
                              height: 150.h,
                              width: 140.w,
                              controller: _homeAnimationController,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Ev Temizliği",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    key: Key(pageName_2),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MultiPagePopup(pageName: pageName_2);
                        },
                      );
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Container(
                        width: 150.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/animations/office_animation.json',
                              height: 150.h,
                              width: 140.w,
                              repeat: true,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Ofis Temizliği",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                key: Key(pageName_1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PastServices()),
                  );
                },
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Container(
                    width: 310.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Lottie.asset(
                          'assets/animations/clock_animation.json',
                          height: 100.h,
                          width: 100.w,
                          repeat: true,
                        ),
                        SizedBox(height: 10.w),
                        Text(
                          "Geçmiş Hizmetler",
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.w),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}