import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'popup.dart'; // Import the updated widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _homeAnimationController;

  @override
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final String pageName_1 = "Ev Temizliği"; // Add this line
  final String pageName_2 = "Ofis Temizliği"; // Add this line

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Hizmet Seçin", style: TextStyle(fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Main Lottie Animation
              Lottie.asset(
                'assets/animations/clean_animation_orange.json',
                width: 300.w,
                repeat: true,
              ),
              SizedBox(height: 70.h),
              // Horizontal Containers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // First Container
                  GestureDetector(
                    key:  Key(pageName_1),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return  MultiPagePopup(pageName: pageName_1,);
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
                        height: 250.h,
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
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                fontWeight: FontWeight.w400

                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Second Container
                  GestureDetector(
                    key:  Key(pageName_2),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return  MultiPagePopup(pageName: pageName_2,);
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
                        height: 250.h,
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
                              repeat: true
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Ofis Temizliği",
                              style: GoogleFonts.openSans(
                                  fontSize: 18.sp,
                                  color: Colors.black,
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
                key:  Key(pageName_1),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return  MultiPagePopup(pageName: pageName_1,);
                    },
                  );
                },
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Container(
                    width: 310.w,
                    height: 150.h,
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
                          repeat: true
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Geçmiş Hizmetler",
                          style: GoogleFonts.openSans(
                              fontSize: 18.sp,
                              color: Colors.black
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
        ),
      ),
    );
  }
}