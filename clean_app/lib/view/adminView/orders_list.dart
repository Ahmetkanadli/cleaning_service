import 'package:clean_app/services/database_operations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersList extends StatefulWidget {
  final List<Map<String, dynamic>> services;
  final String status;

  OrdersList({required this.services, required this.status}) {
    // Sort services by timestamp in descending order
    services.sort((a, b) {
      DateTime dateA = (a['timestamp'] as Timestamp).toDate();
      DateTime dateB = (b['timestamp'] as Timestamp).toDate();
      return dateB.compareTo(dateA);
    });
  }

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {

  List<Map<String, dynamic>> allPastServices = [];
  List<Map<String, dynamic>> filteredServices = [];

  final DataBaseOperations _dbOperations = DataBaseOperations();

  void _showServiceDetails(BuildContext context, Map<String, dynamic> service, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hizmet Detayı",
                    style: GoogleFonts.interTight(
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: Container(
                width: 300.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sipariş No: ${service['merchantOid']}",
                      style: GoogleFonts.interTight(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text("Müşteri: ${service['userName']}",
                      style: GoogleFonts.interTight(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text("Şehir: ${service['city']}",
                      style: GoogleFonts.interTight(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text("İlçe: ${service['district']}",
                      style: GoogleFonts.interTight(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text("Adres: ${service['address']}",
                      style: GoogleFonts.interTight(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text("Telefon: ${service['phone']}",
                      style: GoogleFonts.interTight(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text("Ücret: ${service['fee']} TL",
                      style: GoogleFonts.interTight(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text("Tarih: ${DateFormat('dd/MM/yyyy HH:mm').format((service['timestamp'] as Timestamp).toDate())}",
                      style: GoogleFonts.interTight(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text("Durum: ${service['status']}",
                      style: GoogleFonts.interTight(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text("Durum:",
                      style: GoogleFonts.interTight(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    DropdownButton<String>(
                      value: service['status'],
                      items: <String>['Tamamlandı', 'Ekip yolda', 'Yapılmadı', 'İptal Edildi']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _updateServiceStatus(service['userDocID'], service['merchantOid'], newValue);
                          setState(() {
                            service['status'] = newValue;
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    launchUrl(Uri.parse("tel:${service['phone']}"));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.phone_in_talk,
                        color: const Color(0xFFD1461E),
                        size: 30,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Müşteri İle İletişime Geç",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFD1461E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateServiceStatus(String userId, String merchantOid, String newStatus) async {
    try {
      await _dbOperations.updateServiceStatus(userId, merchantOid, newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sipariş durumu güncellendi')),
      );
      await _fetchServices();
    } catch (e) {
      print('Sipariş durumu güncellenirken hata oluştu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sipariş durumu güncellenirken bir hata oluştu')),
      );
    }
  }
  Future<void> _fetchServices() async {
    List<Map<String, dynamic>> services = await _dbOperations.getAllUsersPastServices();
    setState(() {
      allPastServices = services;
      filteredServices = services;
    });
  }

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
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFFD1461E).withOpacity(0.9),
        title: Text('${widget.status} Listesi',
        style: GoogleFonts.interTight(
          fontSize: 22.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.services.length,
        itemBuilder: (context, index) {
          var service = widget.services[index];
          DateTime timestamp = (service['timestamp'] as Timestamp).toDate();
          String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white,
              elevation: 10,
              child: ListTile(
                title:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(service['userName'],
                              style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: Color(0xFFD1461E).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(service['cleaningPlace'],
                                style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        //Spacer(),

                        Text("Sipariş No: ${service['merchantOid']}",
                          style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ],
                    ),
                    /*
                    Text("Ücret: ${service['fee'].toString()}",
                      style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400
                      ),
                    )
                     */

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
                    Text("Temizlik Süresi: ${service['numberOfRoomsOrArea']}",
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
                onTap: () => _showServiceDetails(context, service, index),
              ),
            ),
          );
        },
      ),
    );
  }
}