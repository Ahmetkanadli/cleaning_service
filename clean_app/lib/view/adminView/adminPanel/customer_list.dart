import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomersList extends StatelessWidget {
  final List<Map<String, dynamic>> customers;

  CustomersList({required this.customers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: true,
        title: Text('Müşteri Listesi',
        style: GoogleFonts.interTight(
          fontSize: 22.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        ),
      ),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          var customer = customers[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              elevation: 10,
              child: ListTile(
                title: Text(
                  customer['name'],
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  customer['email'],
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}