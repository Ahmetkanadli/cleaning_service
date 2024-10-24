import 'dart:ffi';

import 'package:clean_app/view/adminView/adminPanel/customer_list.dart';
import 'package:clean_app/view/adminView/admin_view.dart';
import 'package:clean_app/view/adminView/price_update.dart';
import 'package:clean_app/view/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clean_app/view/adminView/orders_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clean_app/services/database_operations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final DataBaseOperations _dbOperations = DataBaseOperations();
  int _customerCount = 0;
  List<Map<String, dynamic>> _allServices = [];
  List<Map<String, dynamic>> _allCustomers = [];
  Map<String, dynamic> _adminData = {
    'customerCount': 0,
    'doneOrders': 0,
    'notDoneOrders': 0,
    'onTheWayOrders': 0,
    'monthlyRevenue': 0.0,
    'yearlyRevenue': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _fetchAdminData();
    _fetchCustomerCount();
    _fetchAllCustomers();
  }

  Future<void> _fetchAdminData() async {
    List<Map<String, dynamic>> services = await DataBaseOperations().getAllUsersPastServices();
    _calculateAdminData(services);
  }

  Future<void> _fetchCustomerCount() async {
    int customerCount = await DataBaseOperations().fetchCustomerCount();
    setState(() {
      _customerCount = customerCount;
    });
  }
  Future<void> _fetchAllCustomers() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    List<Map<String, dynamic>> customers = usersSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((customer) => customer['isAdmin'] != true)
        .toList();
    setState(() {
      _allCustomers = customers;
    });
  }

  void _calculateAdminData(List<Map<String, dynamic>> services) {
    int doneOrders = 0;
    int notDoneOrders = 0;
    int onTheWayOrders = 0;
    double monthlyRevenue = 0.0;
    double yearlyRevenue = 0.0;

    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    DateTime startOfYear = DateTime(now.year, 1, 1);

    Set<String> uniqueCustomers = {};

    for (var service in services) {
      DateTime dateTime = (service['timestamp'] as Timestamp).toDate();
      double fee = (service['fee'] as num).toDouble(); // Ensure fee is a double

      if (service['userDocID'] != null) {
        uniqueCustomers.add(service['userDocID']); // Add unique customer IDs
      }

      if (service['status'] == 'Tamamlandı') {
        doneOrders++;
      } else if (service['status'] == 'Yapılmadı') {
        notDoneOrders++;
      } else if (service['status'] == 'Ekip yolda') {
        onTheWayOrders++;
      }

      if (dateTime.isAfter(startOfMonth)) {
        monthlyRevenue += fee;
      }

      if (dateTime.isAfter(startOfYear)) {
        yearlyRevenue += fee;
      }
    }

    setState(() {
      _allServices = services;
      _adminData = {
        'customerCount': uniqueCustomers.length, // Use unique customer count
        'doneOrders': doneOrders,
        'notDoneOrders': notDoneOrders,
        'onTheWayOrders': onTheWayOrders,
        'monthlyRevenue': monthlyRevenue,
        'yearlyRevenue': yearlyRevenue,
      };
    });
  }

  void _showCustomers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomersList(customers: _allCustomers),
      ),
    );
  }


  void _showOrders(String status) {
    List<Map<String, dynamic>> filteredServices = _allServices.where((service) => service['status'] == status).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrdersList(services: filteredServices, status: status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Ana Ekran',
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
                  const Icon(Icons.price_change, color: Color(0xFFD1461E), size: 30,),
                  SizedBox(width: 10.w),
                  Text(
                    'Fiyat Güncelleme',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PriceUpdateScreen()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(Icons.shopping_cart, color: Color(0xFFD1461E), size: 30,),
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
                // Siparişleri görüntüleme işlemleri burada yapılabilir
                Navigator.push(context, (MaterialPageRoute(builder: (context) => OrdersList(services: _allServices, status: 'Tümü'))));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Icon(Icons.exit_to_app, color: Color(0xFFD1461E), size: 30,),
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
        title: Text('Yönetim Paneli',
          style: GoogleFonts.interTight(
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
        child: _adminData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //_showOrders('Yapılmadı');
                          },
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Container(
                              width: 150.w,
                              height: 210.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Lottie.asset(
                                    'assets/animations/gain.json',
                                    height: 140.h,
                                    width: 140.w,
                                    repeat: false,
                                  ),

                                  Text(
                                    "Aylık Kazanç",
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${_adminData['monthlyRevenue']}TL",
                                    style: GoogleFonts.inter(
                                      fontSize: 20.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        GestureDetector(
                          onTap: () {
                            //_showOrders('Tamamlandı');
                          },
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Container(
                              width: 150.w,
                              height: 210.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Lottie.asset(
                                    'assets/animations/gain.json',
                                    height: 140.h,
                                    width: 140.w,
                                    repeat: false,
                                  ),
                                  Text(
                                    "Yıllık Kazanç",
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${_adminData['yearlyRevenue']}TL",
                                    style: GoogleFonts.inter(
                                      fontSize: 20.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
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
                    GestureDetector(
                      onTap: () {
                        //_showOrders('Tamamlandı');
                        // müşterilerin Listesini Gösterecek
                        _showCustomers();
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 130.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Lottie.asset(
                                'assets/animations/customer.json',
                                height: 120.h,
                                width: 120.w,
                              ),
                              Text(
                                "Toplam Müşteri ",
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "$_customerCount",
                                style: GoogleFonts.inter(
                                  fontSize: 22.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showOrders('Yapılmadı');
                          },
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Container(
                              width: 150.w,
                              height: 210.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Lottie.asset(
                                    'assets/animations/not_done.json',
                                    height: 150.h,
                                    width: 140.w,
                                    repeat: false,
                                  ),
                                  Text(
                                    "Yapılmayanlar",
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${_adminData['notDoneOrders']}",
                                    style: GoogleFonts.inter(
                                      fontSize: 22.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        GestureDetector(
                          onTap: () {
                            _showOrders('Tamamlandı');
                          },
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Container(
                              width: 150.w,
                              height: 210.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,

                                children: [
                                  Lottie.asset(
                                    'assets/animations/done.json',
                                    height: 150.h,
                                    width: 150.w,
                                    repeat: false,
                                  ),
                                  Text(
                                    "Yapılanlar",
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "${_adminData['doneOrders']}",
                                    style: GoogleFonts.inter(
                                      fontSize: 22.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
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
                    GestureDetector(
                      onTap: () {
                        _showOrders('Ekip yolda');
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 130.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 10.w),
                              Lottie.asset(
                                'assets/animations/on_way.json',
                                height: 130.h,
                                width: 130.w,
                                repeat: false,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "Ekip Yolda: ",
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                " ${_adminData['onTheWayOrders']}",
                                style: GoogleFonts.inter(
                                  fontSize: 22.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminView()));
                      },
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 130.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 10.w),
                              Image.asset(
                                'assets/images/yorganci.jpeg',
                                height: 100.h,
                                width: 130.w,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "Hizmet Dökümü",
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
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
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}