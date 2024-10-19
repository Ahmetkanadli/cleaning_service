import 'package:clean_app/services/database_operations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PastServices extends StatefulWidget {
  const PastServices({super.key});

  @override
  State<PastServices> createState() => _PastServicesState();
}

class _PastServicesState extends State<PastServices> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  void _showServiceDetails(BuildContext context, Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hizmet Detayı",
            style: GoogleFonts.interTight(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Şehir: ${service['city']}",
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                ),
              ),
              Text("İlçe: ${service['district']}",
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                ),
              ),
              Text("Adres: ${service['address']}",
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                ),
              ),
              Text("Telefon: ${service['phone']}",
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                ),
              ),
              Text("Ücret: ${service['fee']}",
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                ),
              ),
              Text("Temizlik Hizmeti: ${service['cleaningPlace']}",
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                ),
              ),
              service['numberOfRoomsOrArea'] == 'Ofis Temizliği' ?
              Text("Temizlenecek ALan ${service['numberOfRoomsOrArea']}",
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                ),
              ) :
              Text("Oda Sayısı: ${service['numberOfRoomsOrArea']}",
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                ),
              ),
              Text("Tarih: ${DateFormat('dd/MM/yyyy HH:mm').format((service['timestamp'] as Timestamp).toDate())}",
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                ),
              ),
              Text("Hizmet Durumu: ${service['status']}",
                style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Kapat",
                style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        backgroundColor: const Color(0xFFD1461E).withOpacity(0.9),
        title: Text(
          'Geçmiş Hizmetler',
          style: GoogleFonts.interTight(
            fontSize: 22.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DataBaseOperations().getPastServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No past services found.'));
          } else {
            List<Map<String, dynamic>> pastServices = snapshot.data!;
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: pastServices.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> service = pastServices[index];
                DateTime timestamp = (service['timestamp'] as Timestamp).toDate();
                String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
                return Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Card(
                    elevation: 10,
                    color: Colors.white,
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(service['cleaningPlace'],
                            style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          const Spacer(),
                          Text("Ücret: ${service['fee'].toString()}",
                            style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            ),
                          )
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Şehir: ${service['city']}",
                            style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Text("İlçe: ${service['district']}",
                            style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Text("Adres: ${service['address']}",
                            style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Text("Telefon: ${service['phone']}",
                            style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Text("Oluşturulma tarihi: $formattedDate",
                            style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                          Text("Hizmet Durumu: ${service['status']}",
                            style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _showServiceDetails(context, service),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}