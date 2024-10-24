
import 'package:clean_app/services/database_operations.dart';
import 'package:clean_app/services/notificationService/notification_service.dart';
import 'package:clean_app/services/payment_service.dart';
import 'package:clean_app/services/whatsappService/whatsapp_service.dart';
import 'package:clean_app/view/login/login_page.dart';
import 'package:clean_app/view/userView/home/account_page.dart';
import 'package:clean_app/view/userView/pastServices/past_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widget/popup.dart'; // Import the updated widget
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _homeAnimationController;
  late String userName;
  List<Map<String, dynamic>> activeServices = [];
  late String whatsappNumber;
  final remoteConfig = FirebaseRemoteConfig.instance;
  final notificationService = NotificationService();

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

    PaymentService().initializeRemoteConfig();
    initializeWhatsappRemoteConfig();
    // Retrieve the user's name from Hive asynchronously
    _retrieveUserName();
  }

  Future<void> initializeWhatsappRemoteConfig() async {
    try {
      await Firebase.initializeApp();
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      await remoteConfig.fetchAndActivate();
      
        whatsappNumber = remoteConfig.getString('whatsappNo');
        print('WhatsApp numarası: $whatsappNumber');
     
    } catch (e) {
      print('WhatsApp numarası alınırken hata oluştu: $e');
    }
  }


  Future<void> _retrieveUserName() async {
    var box = Hive.box('userBox');
    userName = box.get('userName', defaultValue: 'Hoşgeldiniz');
    activeServices = await DataBaseOperations().getActiveServices(
        FirebaseAuth.instance.currentUser?.uid);
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
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset('assets/pestvet_logo.png', height: 250.h, width: 200.w,),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(Icons.home, color: Color(0xFFD1461E), size: 30,),
                  SizedBox(width: 10.w),
                  Text(
                    'Ana Sayfa',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(Icons.history, color: Color(0xFFD1461E),size: 30,),
                  SizedBox(width: 10.w),
                  Text(
                    'Siparişler',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>PastServices()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(Icons.person, color: Color(0xFFD1461E),size: 30,),
                  SizedBox(width: 10.w),
                  Text(
                    'Profilim',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountPage()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(Icons.exit_to_app, color: Color(0xFFD1461E),size: 30,),
                  SizedBox(width: 10.w),
                  Text(
                    'Çıkış Yap',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Hive.box("userBox").clear();
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
                );
              },
            ),

            ListTile(
              title: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                    child: Image.asset(
                      "assets/images/whatsapp.png",
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'İletişime Geç',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              onTap: (){
                  WhatsappService().launchWhatsApp(whatsappNumber);
                },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10.r),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        backgroundColor: const Color(0xFFD1461E).withOpacity(0.9),
        title: Text(
                "Pestvet Temizlik",
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                ),
              ),
        centerTitle: true,
      ),
      body: LiquidPullToRefresh(
        color: Color(0xFFD1461E),
        animSpeedFactor: 2.0,
        backgroundColor: Colors.white,
        showChildOpacityTransition: false,
        height: 80,
        onRefresh: () async {
          Future.delayed(Duration(milliseconds: 300), () {
            //
            setState(() {});
          });
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                 Container(
                   padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                   decoration: BoxDecoration(
                     color: const Color(0xFFD1461E).withOpacity(0.1),
                     borderRadius: BorderRadius.circular(15.r),
                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           Text(
                             'Hoşgeldin, ',
                             style: GoogleFonts.inter(
                               fontSize: 16.sp,
                               color: Colors.black,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                           Text(
                             '$userName',
                             style: GoogleFonts.inter(
                               fontSize: 17.sp,
                               color: const Color(0xFFD1461E),
                               fontWeight: FontWeight.w700,
                             ),
                           ),
                         ],
                       ),
                       SizedBox(height: 5.h),
                       Text(
                         'İhtiyacınıza uygun hizmeti seçin',
                         style: GoogleFonts.inter(
                           fontSize: 16.sp,
                           color: Colors.black,
                           fontWeight: FontWeight.w400,
                         ),
                       ),
                     ],
                   ),
                 ),
                 SizedBox(height: 20.h),
                Lottie.asset(
                  'assets/animations/clean_animation_orange.json',
                  width: 300.w,
                  repeat: true,
                ),
                SizedBox(height: 20.h),
                if (activeServices.isNotEmpty) ...[
                  SizedBox(height: 20.h),
                  ...activeServices.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> service = entry.value;
                    return Card(
                      color: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD1461E).withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.r),
                                topRight: Radius.circular(15.r),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10.w),
                                CircleAvatar(
                                  backgroundColor: Colors.red, // İkonun arka plan rengi
                                  radius: 15.r, // İkonun boyutu
                                  child: Text(
                                    (index + 1).toString(), // Hizmet sırası
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text("Aktif Hizmetler",
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    )),
                                Spacer(),
                                Text("Durum : ${service['status']}",
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          ),
                          ListTile(
                            titleAlignment: ListTileTitleAlignment.top,
                            title: Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Aktif Hizmet: ${service['cleaningPlace']}",
                                      style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.black)),
                                  Text("Adres: ${service['address']}",
                                      style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.black)),
                                  Text("Telefon: ${service['phone']}",
                                      style: GoogleFonts.inter(fontSize: 16.sp, color: Colors.black)),
                                ],
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    actionsAlignment: MainAxisAlignment.spaceBetween,
                                    backgroundColor: Colors.white,
                                    title: Text("Hizmet Detayları",style: GoogleFonts.interTight(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.sp,
                                      color: Colors.black,
                                    ),),
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Hizmet Türü: ${service['cleaningPlace']}",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text("Adres: ${service['address']}",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text("Telefon: ${service['phone']}",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text("Ödeme: ${service['fee']} TL",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),

                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              WhatsappService().launchWhatsApp(whatsappNumber);
                                            },
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: Image.asset(
                                                    "assets/images/whatsapp.png",
                                                    height: 30,
                                                    width: 30,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  "İletişime Geç",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {

                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Kapat"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
                activeServices != null ? SizedBox(height: 20.h,) :SizedBox(height: 50.h),
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
      ),
    );
  }
}