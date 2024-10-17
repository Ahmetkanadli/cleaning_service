import 'package:clean_app/services/database_operations.dart';
import 'package:clean_app/view/adminView/price_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  late Future<String> userName;
  List<Map<String, dynamic>> allPastServices = [];
  List<Map<String, dynamic>> filteredServices = [];
  String filterType = 'all';
  String selectedFilter = 'Tümü';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DataBaseOperations _dbOperations = DataBaseOperations();

  @override
  void initState() {
    super.initState();
    userName = _dbOperations.getUserName();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    List<Map<String, dynamic>> services = await _dbOperations.getAllUsersPastServices();
    setState(() {
      allPastServices = services;
      filteredServices = services;
    });
  }

  void _filterServices(String type) {
    setState(() {
      filterType = type;
      selectedFilter = _getFilterName(type);
      if (type == 'done') {
        filteredServices = allPastServices.where((service) => service['status'] == 'Tamamlandı').toList();
      } else if (type == 'not_done') {
        filteredServices = allPastServices.where((service) => service['status'] == 'Yapılmadı').toList();
      } else {
        filteredServices = allPastServices;
      }
    });
  }

  String _getFilterName(String type) {
    switch (type) {
      case 'done':
        return 'Yapılanlar';
      case 'not_done':
        return 'Yapılmayanlar';
      case 'date':
        return 'Tarihe Göre';
      default:
        return 'Tümü';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFD1461E),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _filterByDate(pickedDate);
    }
  }

  void _filterByDate(DateTime selectedDate) {
    setState(() {
      filteredServices = allPastServices.where((service) {
        DateTime serviceDate = (service['timestamp'] as Timestamp).toDate();
        return serviceDate.month == selectedDate.month && serviceDate.year == selectedDate.year;
      }).toList();
      selectedFilter = 'Tarihe Göre';
    });
  }

  void _showServiceDetails(BuildContext context, Map<String, dynamic> service, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Hizmet Detayı",
                style: GoogleFonts.interTight(
                  fontSize: 18.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Column(
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
                    items: <String>['Tamamlandı', 'Ekip yolda', 'Yapılmadı']
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
                      }
                    },
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Kapat",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFD1461E),
                    ),
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

  void _showSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Müşteri Adına Göre Ara",
            style: GoogleFonts.interTight(
              fontSize: 18.sp,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Müşteri adı girin",
              hintStyle: GoogleFonts.inter(
                fontSize: 16.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "İptal",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFD1461E),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _filterByCustomerName(searchController.text);
                Navigator.of(context).pop();
              },
              child: Text(
                "Ara",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFD1461E),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _filterByCustomerName(String customerName) {
    setState(() {
      filteredServices = allPastServices.where((service) {
        return service['userName'].toLowerCase().contains(customerName.toLowerCase());
      }).toList();
      selectedFilter = 'Müşteri: $customerName';
    });
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
              title: Text(
                'Fiyat Güncelleme',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PriceUpdateScreen()));
              },
            ),
            ListTile(
              title: Text(
                'Siparişler',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                // Siparişleri görüntüleme işlemleri burada yapılabilir
              },
            ),
            ListTile(
              title: Text(
                'Müşteri Ekle',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                // Müşteri ekleme işlemleri burada yapılabilir
              },
            ),
            ListTile(
              title: Text(
                'Çıkış Yap',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                // Müşteri ekleme işlemleri burada yapılabilir
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
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
        title: Text(
          'Hizmet Geçmişi',
          style: GoogleFonts.interTight(
            fontSize: 22.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  selectedFilter,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                DropdownButton<String>(
                  value: filterType,
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  dropdownColor: const Color(0xFFD1461E),
                  items: <String>['all', 'done', 'not_done', 'date']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        _getFilterName(value),
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      if (newValue == 'date') {
                        _selectDate(context);
                      } else {
                        _filterServices(newValue);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _dbOperations.getAllUsersPastServices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Geçmiş hizmet bulunamadı.'));
                } else {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> service = filteredServices[index];
                      DateTime timestamp = (service['timestamp'] as Timestamp).toDate();
                      String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
                      return Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Card(
                          elevation: 10,
                          color: Colors.white,
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Müşteri: ${service['userName']} ${index}",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Şehir: ${service['city']}",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "İlçe: ${service['district']}",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      "Ücret: ${service['fee']} TL",
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Adres: ${service['address']}",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "Telefon: ${service['phone']}",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "Tarih: $formattedDate",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  "Durum: ${service['status']}",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => _showServiceDetails(context, service, index),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSearchDialog,
        backgroundColor: const Color(0xFFD1461E),
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }
}