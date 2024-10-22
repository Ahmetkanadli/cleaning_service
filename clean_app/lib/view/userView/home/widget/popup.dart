// lib/popup.dart
import 'package:clean_app/models/product.dart';
import 'package:clean_app/models/service_model.dart';
import 'package:clean_app/services/auth_services.dart';
import 'package:clean_app/services/database_operations.dart';
import 'package:clean_app/services/payment_service.dart';
import 'package:clean_app/view/userView/payment_screen/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MultiPagePopup extends StatefulWidget {
  const MultiPagePopup({super.key, required this.pageName});

  final String pageName;

  @override
  _MultiPagePopupState createState() => _MultiPagePopupState();
}

class _MultiPagePopupState extends State<MultiPagePopup> {
  String? _selectedRoom;
  String? _selectedCleaningTime;
  String? _selectedCity;
  String? _selectedDistrict;
  String _address = '';
  String _phoneNumber = '';
  int _minimumFee = 0;
  final PageController _pageController = PageController();

  final List<String> _istanbulDistricts = [
    "Adalar",
    "Arnavutköy",
    "Ataşehir",
    "Avcılar",
    "Bağcılar",
    "Bahçelievler",
    "Bakırköy",
    "Başakşehir",
    "Bayrampaşa",
    "Beşiktaş",
    "Beykoz",
    "Beylikdüzü",
    "Beyoğlu",
    "Büyükçekmece",
    "Çatalca",
    "Çekmeköy",
    "Esenler",
    "Esenyurt",
    "Eyüpsultan",
    "Fatih",
    "Gaziosmanpaşa",
    "Güngören",
    "Kadıköy",
    "Kağıthane",
    "Kartal",
    "Küçükçekmece",
    "Maltepe",
    "Pendik",
    "Sancaktepe",
    "Sarıyer",
    "Silivri",
    "Sultanbeyli",
    "Sultangazi",
    "Şile",
    "Şişli",
    "Tuzla",
    "Ümraniye",
    "Üsküdar",
    "Zeytinburnu"
  ];

  final List<String> _kocaeliDistricts = [
    "İzmit",
    "Derince",
    "Körfez",
    "Gebze",
    "Gölcük",
    "Karamürsel",
    "Kandıra",
    "Başiskele",
    "Kartepe",
    "Çayırova",
    "Darıca",
    "Dilovası"
  ];

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  final TextStyle _textStyle =
      GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w400);

  final TextStyle _headerTextStyle = GoogleFonts.inter(
      fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        width: double.infinity,
        height: _pageController.hasClients && _pageController.page == 2
            ? 450.h
            : 400.h,
        padding: const EdgeInsets.all(16.0),
        child: PageView(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          // Disable swipe gesture
          children: [
            SingleChildScrollView(
              child: _buildPage(widget.pageName == "Ev Temizliği"
                  ? _buildFirstPage()
                  : _buildFirstPageOfis()),
            ),
            //_buildPage(_buildSecondPage()),
            SingleChildScrollView(child: _buildPage(_buildThirdPage())),
            SingleChildScrollView(child: _buildPage(_buildFourthPage())),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Widget content) {
    return Stack(
      children: [
        Positioned(
          top: 8,
          right: 4,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Icon(Icons.close),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: GestureDetector(
            onTap: () {
              if (_pageController.page!.toInt() > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Container(
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 60,
          child: Text(
            "Min. Ücret: $_minimumFee TL",
            style: _textStyle,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: content,
        ),
      ],
    );
  }

  Widget _buildFirstPageOfis() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30.h),
        Text("Temizlik Süresi Seçiniz", style: _headerTextStyle),
        Text("Minumum 4 saat, Maksimum 8 saat seçebilirsiniz",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w400)),
        const SizedBox(height: 20),
        Container(
          height: 210.h,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: DataBaseOperations().fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Hata ile karşılaşıldı: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Hizmet Bulunamadı'));
              } else {
                // Filter out products with empty room_count
                List<Map<String, dynamic>> filteredProducts =
                    snapshot.data!.where((product) {
                  return product['product_area'].isNotEmpty;
                }).toList();

                // Sort products based on the first digit of room_count in descending order
                filteredProducts.sort((a, b) {
                  int roomCountA = int.tryParse(a['product_area'][0]) ?? 0;
                  int roomCountB = int.tryParse(b['product_area'][0]) ?? 0;
                  return roomCountA.compareTo(roomCountB);
                });

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    Product product = Product.fromMap(filteredProducts[index]);
                    return _buildOptionButton(
                      '${product.product_area}' ?? 'Unknown',
                      // Provide a default value
                      product.product_area!,
                      _selectedRoom,
                      (value) {
                        setState(() {
                          _selectedRoom = value;
                          _minimumFee = int.parse(product.price);
                        });
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
        SizedBox(height: 10.h),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(
                Color(0xFFD1461E).withOpacity(0.9)),
          ),
          onPressed: () {
            if (_selectedRoom != null) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
          child: Text(
            "Devam",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
  // İlk olarak oda sayısı olarak tasarlanmıştı fakat revize isteği üzerine
  // saat olarak değiştirildi.
  Widget _buildFirstPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 30.h),
        Text("Temizlik Süresi Seçiniz", style: _headerTextStyle),
        Text("Minumum 4 saat, Maksimum 8 saat seçebilirsiniz",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.w400)),
        const SizedBox(height: 20),
        Container(
          height: 210.h, // Set the desired height
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: DataBaseOperations().fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Hata ile karşılaşıldı: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Hizmet Bulunamadı'));
              } else {
                // Filter out products with empty room_count
                List<Map<String, dynamic>> filteredProducts = snapshot.data!.where((product) {
                  return product['room_count'].isNotEmpty;
                }).toList();

                // Sort products based on the first digit of room_count in descending order
                filteredProducts.sort((a, b) {
                  int roomCountA = int.tryParse(a['room_count'][0]) ?? 0;
                  int roomCountB = int.tryParse(b['room_count'][0]) ?? 0;
                  return roomCountA.compareTo(roomCountB);
                });

                return ListView.builder(
                  shrinkWrap: false,
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    Product product = Product.fromMap(filteredProducts[index]);
                    return _buildOptionButton(
                      product.room_count ?? 'Unknown', // Provide a default value
                      product.room_count!,
                      _selectedRoom,
                          (value) {
                        setState(() {
                          _selectedRoom = value;
                          _minimumFee = int.parse(product.price);
                        });
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
        SizedBox(height: 10.h),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(Color(0xFFD1461E).withOpacity(0.9)),
          ),
          onPressed: () {
            if (_selectedRoom != null) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
          child: Text("Devam",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  Widget _buildSecondPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Kaç saat temizlik yapılacak", style: _headerTextStyle),
        const SizedBox(height: 20),
        _buildOptionButton("3 saat", "3 saat", _selectedCleaningTime, (value) {
          setState(() {
            _selectedCleaningTime = value;
            _minimumFee += 350;
          });
        }),
        _buildOptionButton("4 saat", "4 saat", _selectedCleaningTime, (value) {
          setState(() {
            _selectedCleaningTime = value;
            _minimumFee += 450;
          });
        }),
        _buildOptionButton("5 saat", "5 saat", _selectedCleaningTime, (value) {
          setState(() {
            _selectedCleaningTime = value;
            _minimumFee += 700;
          });
        }),
        _buildOptionButton(
            "6 saat ve üzeri", "6 saat ve üzeri", _selectedCleaningTime,
            (value) {
          setState(() {
            _selectedCleaningTime = value;
            _minimumFee += 800;
          });
        }),
        SizedBox(height: 10.h),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(
                Color(0xFFD1461E).withOpacity(0.9)),
          ),
          onPressed: () {
            if (_selectedCleaningTime != null) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
          child: Text("Devam",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  Widget _buildThirdPage() {
    return SingleChildScrollView(
      child: Container(
        height: 500.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Şehir seçiniz", style: _headerTextStyle),
            const SizedBox(height: 20),
            _buildOptionButton("İstanbul", "İstanbul", _selectedCity, (value) {
              setState(() {
                _selectedCity = value;
                _selectedDistrict = null;
              });
            }),
            _buildOptionButton("Kocaeli", "Kocaeli", _selectedCity, (value) {
              setState(() {
                _selectedCity = value;
                _selectedDistrict = null;
              });
            }),
            const SizedBox(height: 20),
            if (_selectedCity != null) ...[
               Text("İlçe seçiniz", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black)),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Color(0xFFD1461E).withOpacity(0.5), width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDistrict,
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFFD1461E)),
                    iconSize: 24.sp,
                    elevation: 16,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                    dropdownColor: Colors.white,
                    isExpanded: true,
                    hint: Text('İlçe seçiniz', style: GoogleFonts.inter(color: Colors.grey)),
                    items: (_selectedCity == "İstanbul"
                            ? _istanbulDistricts
                            : _kocaeliDistricts)
                        .map((district) => DropdownMenuItem(
                              value: district,
                              child: Text(district),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDistrict = value;
                      });
                    },
                    menuMaxHeight: 200.h,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Adres",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Color(0xFFD1461E).withOpacity(0.5), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Color(0xFFD1461E).withOpacity(0.5), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Color(0xFFD1461E), width: 2),
                ),
                labelStyle: GoogleFonts.inter(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              ),
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 16.sp,
              ),
              onChanged: (value) {
                setState(() {
                  _address = value;
                });
              },
            ),
            SizedBox(height: 20.h),
            TextField(
              decoration: InputDecoration(
                labelText: "Telefon",
                hintText: "05XXXXXXXXX",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Color(0xFFD1461E).withOpacity(0.5), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Color(0xFFD1461E).withOpacity(0.5), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Color(0xFFD1461E), width: 2),
                ),
                labelStyle: GoogleFonts.inter(color: Colors.grey),
                hintStyle: GoogleFonts.inter(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              ),
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 16.sp,
              ),
              maxLength: 11,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                setState(() {
                  _phoneNumber = value;
                });
              },
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                    Color(0xFFD1461E).withOpacity(0.9)),
              ),
              onPressed: () {
                if (_selectedCity != null &&
                    _selectedDistrict != null &&
                    _address.isNotEmpty &&
                    _phoneNumber.length == 11) {
                  FocusScope.of(context).unfocus();
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Lütfen tüm alanları doğru şekilde doldurun')),
                  );
                }
              },
              child: Text("Devam",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  bool _isLoading = false;

  Widget _buildFourthPage() {
    var box = Hive.box('userBox');
    String _name = box.get('userName', defaultValue: '');
    String _email = box.get('userEmail', defaultValue: '');

    return Center(
      child: Container(
        height: 450.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30.h,),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFD1461E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("Ödeme Tutarının Sadece 700 TL'si online olarak alınacak. Geri kalan miktarın elden hizmet veren ekip arkadaşımıza teslim edilmesi gerekmektedir",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    color: Colors.red.shade500,
                  )),
            ),
            SizedBox(height: 10.h),
            Text("Sipariş Bilgileri", style: _headerTextStyle),
            const SizedBox(height: 20),
            Text("Şehir: $_selectedCity", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("İlçe: $_selectedDistrict",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Adres: $_address", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Telefon: $_phoneNumber", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            widget.pageName == "Ev Temizliği"
            // Temizlik türüne göre oda sayısı veya alanı göster
            // revize üzerine saat olarak değiştirildi
            // önceki alan Ev Temizliği
                ? Text("Temizlik Saati: $_selectedRoom saat",
                    style: const TextStyle(
                        fontSize: 18))
            // önceki alan Ofis Temizliği
                : Text("Temizlik Saati: $_selectedRoom saat",
                    style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Ödeme Tutarı: $_minimumFee TL",
                style: const TextStyle(fontSize: 18)),
            SizedBox(height: 10.h),

            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFFD1461E).withOpacity(0.9)),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        String merchantOid =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        String? token = await PaymentService().startPayment(
                          amount: _minimumFee.toDouble(),
                          email: _email,
                          name: _name,
                          address: _address,
                          phone: _phoneNumber,
                          merchantOid: merchantOid,
                        );

                        if (token != null) {
                          String paymentUrl =
                              "https://www.paytr.com/odeme/guvenli/$token";
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                paymentUrl: paymentUrl,
                                name: _name,
                                email: _email,
                                city: _selectedCity!,
                                district: _selectedDistrict!,
                                address: _address,
                                phone: _phoneNumber,
                                fee: _minimumFee,
                                roomCountOrArea: _selectedRoom!,
                                //cleaningIndex: _selectedCleaningTime,
                                cleaningPlace: widget.pageName,
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        print("hata : ${e.toString()}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Ödeme işlemi başarısız oldu: $e')),
                        );
                      }

                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Text("Ödeme Sayfasına Git",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        )),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String text, String value, String? selectedValue,
      Function(String) onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => onTap(value),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: selectedValue == value
                ? const Color(0xFFD1461E).withOpacity(0.9)
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              color: selectedValue == value ? Colors.white : Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
