import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultiPagePopup extends StatefulWidget {
  const MultiPagePopup({super.key, required this.pageName});

  final String pageName;

  @override
  _MultiPagePopupState createState() => _MultiPagePopupState();
}

class _MultiPagePopupState extends State<MultiPagePopup> {
  int _selectedRoomIndex = -1;
  int _selectedCleaningIndex = -1;
  String? _selectedCity;
  String? _selectedDistrict;
  String _address = '';
  String _phoneNumber = '';
  int _minimumFee = 0;
  final PageController _pageController = PageController();

  final List<String> _istanbulDistricts = [
    "Adalar", "Arnavutköy", "Ataşehir", "Avcılar", "Bağcılar", "Bahçelievler", "Bakırköy", "Başakşehir", "Bayrampaşa", "Beşiktaş", "Beykoz", "Beylikdüzü", "Beyoğlu", "Büyükçekmece", "Çatalca", "Çekmeköy", "Esenler", "Esenyurt", "Eyüpsultan", "Fatih", "Gaziosmanpaşa", "Güngören", "Kadıköy", "Kağıthane", "Kartal", "Küçükçekmece", "Maltepe", "Pendik", "Sancaktepe", "Sarıyer", "Silivri", "Sultanbeyli", "Sultangazi", "Şile", "Şişli", "Tuzla", "Ümraniye", "Üsküdar", "Zeytinburnu"
  ];

  final List<String> _kocaeliDistricts = [
    "İzmit", "Derince", "Körfez", "Gebze", "Gölcük", "Karamürsel", "Kandıra", "Başiskele", "Kartepe", "Çayırova", "Darıca", "Dilovası"
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.infinity,
        height: _pageController.hasClients && _pageController.page == 2 ? 450.h : 400.h,
        padding: const EdgeInsets.all(16.0),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Disable swipe gesture
          children: [
            _buildPage(widget.pageName == "Ev Temizliği" ?_buildFirstPage() : _buildFirstPageOfis()),
            _buildPage(_buildSecondPage()),
            _buildPage(_buildThirdPage()),
            _buildPage(_buildFourthPage()),
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
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_pageController.page!.toInt() > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Text(
            "Min. Ücret: $_minimumFee TL",
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: content,
        ),
      ],
    );
  }


  Widget _buildFirstPageOfis() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Ofis Kaç m²", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        _buildOptionButton("50 m²", 0, _selectedRoomIndex, (index) {
          setState(() {
            _selectedRoomIndex = index;
            _minimumFee = 800;
          });
        }),
        _buildOptionButton("100 m²", 1, _selectedRoomIndex, (index) {
          setState(() {
            _selectedRoomIndex = index;
            _minimumFee = 1700;
          });
        }),
        _buildOptionButton("150 m²", 2, _selectedRoomIndex, (index) {
          setState(() {
            _selectedRoomIndex = index;
            _minimumFee = 1700;
          });
        }),
        _buildOptionButton("150 üstü", 3, _selectedRoomIndex, (index) {
          setState(() {
            _selectedRoomIndex = index;
            _minimumFee = 1700;
          });
        }),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            if (_selectedRoomIndex != -1) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
          child: const Text("Devam"),
        ),
      ],
    );
  }

  Widget _buildFirstPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Evin Oda sayısı kaç", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        _buildOptionButton("1+0", 0, _selectedRoomIndex, (index) {
          setState(() {
            _selectedRoomIndex = index;
            _minimumFee = 800;
          });
        }),
        _buildOptionButton("1+1", 1, _selectedRoomIndex, (index) {
          setState(() {
            _selectedRoomIndex = index;
            _minimumFee = 1700;
          });
        }),
        _buildOptionButton("2+1", 2, _selectedRoomIndex, (index) {
          setState(() {
            _selectedRoomIndex = index;
            _minimumFee = 1700;
          });
        }),
        _buildOptionButton("3+1", 3, _selectedRoomIndex, (index) {
          setState(() {
            _selectedRoomIndex = index;
            _minimumFee = 1700;
          });
        }),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            if (_selectedRoomIndex != -1) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
          child: const Text("Devam"),
        ),
      ],
    );
  }

  Widget _buildSecondPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Kaç saat temizlik yapılacak", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        _buildOptionButton("3 saat", 0, _selectedCleaningIndex, (index) {
          setState(() {
            _selectedCleaningIndex = index;
            _minimumFee = (_selectedRoomIndex == 0 ? 800 : 1700) + 350;
          });
        }),
        _buildOptionButton("4 saat", 1, _selectedCleaningIndex, (index) {
          setState(() {
            _selectedCleaningIndex = index;
            _minimumFee = (_selectedRoomIndex == 0 ? 800 : 1700) + 450;
          });
        }),
        _buildOptionButton("5 saat", 2, _selectedCleaningIndex, (index) {
          setState(() {
            _selectedCleaningIndex = index;
            _minimumFee = (_selectedRoomIndex == 0 ? 800 : 1700) + 700;
          });
        }),
        _buildOptionButton("6 saat ve üzeri", 3, _selectedCleaningIndex, (index) {
          setState(() {
            _selectedCleaningIndex = index;
            _minimumFee = (_selectedRoomIndex == 0 ? 800 : 1700) + 800;
          });
        }),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            if (_selectedCleaningIndex != -1) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
          child: const Text("Devam"),
        ),
      ],
    );
  }

  Widget _buildThirdPage() {
    return SingleChildScrollView(
      child: Container(
        height: 450.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Şehir seçiniz", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            _buildOptionButton("İstanbul", 0, _selectedCity == "İstanbul" ? 0 : -1, (index) {
              setState(() {
                _selectedCity = "İstanbul";
                _selectedDistrict = null;
              });
            }),
            _buildOptionButton("Kocaeli", 1, _selectedCity == "Kocaeli" ? 1 : -1, (index) {
              setState(() {
                _selectedCity = "Kocaeli";
                _selectedDistrict = null;
              });
            }),
            const SizedBox(height: 20),
            if (_selectedCity != null) ...[
              const Text("İlçe seçiniz", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedDistrict,
                menuMaxHeight: 100.h,
                items: (_selectedCity == "İstanbul" ? _istanbulDistricts : _kocaeliDistricts)
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
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: "Adres",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _address = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: "Telefon",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _phoneNumber = value;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_selectedCity != null && _selectedDistrict != null && _address.isNotEmpty && _phoneNumber.isNotEmpty) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: const Text("Devam"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFourthPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50.h),
          const Text("Seçtiğiniz Bilgiler", style: TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Text("Şehir: $_selectedCity", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text("İlçe: $_selectedDistrict", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text("Adres: $_address", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text("Telefon: $_phoneNumber", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text("Min. Ödeme Tutarı: $_minimumFee TL", style: const TextStyle(fontSize: 18)),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              // Navigate to the payment page
              Navigator.of(context).pop();
              // Add your payment page navigation logic here
            },
            child: const Text("Ödeme Sayfasına Git"),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String text, int index, int selectedIndex, Function(int) onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: selectedIndex == index ? Colors.green : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selectedIndex == index ? Colors.white : Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}