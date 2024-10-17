import 'package:clean_app/view/userView/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clean_app/services/payment_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:clean_app/services/database_operations.dart';
import 'package:clean_app/models/service_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentUrl;
  final String name;
  final String email;
  final String city;
  final String district;
  final String address;
  final String phone;
  final int fee;
  final int roomIndex;
  final int cleaningIndex;
  final String cleaningPlace;

  PaymentScreen({
    required this.paymentUrl,
    required this.name,
    required this.email,
    required this.city,
    required this.district,
    required this.address,
    required this.phone,
    required this.fee,
    required this.roomIndex,
    required this.cleaningIndex,
    required this.cleaningPlace,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.paymentUrl))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains("https://sabosoftware.com/odeme_basarili.php")) {
              await _handlePaymentSuccess();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  Future<void> _handlePaymentSuccess() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      ServiceModel service = ServiceModel(
        merchantOid: DateTime.now().millisecondsSinceEpoch.toString(),
        city: widget.city,
        district: widget.district,
        address: widget.address,
        phone: widget.phone,
        fee: widget.fee,
        timestamp: DateTime.now(),
        cleaningPlace: widget.cleaningPlace,
        numberOfRoomsOrArea: "${widget.roomIndex + 1}",
        cleaningTime: widget.cleaningIndex + 3,
        status: 'Yapılmadı',
      );

      await DataBaseOperations().addPastService(userId: userId, service: service);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor : Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD1461E).withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10.r),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        title: Text(
          'Ödeme Sayfası',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Alınacak Hizmet", style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w600)),
                      Text("Email: ${widget.email}", style: GoogleFonts.inter(fontSize: 16.sp)),
                      Text("Adres: ${widget.address}", style: GoogleFonts.inter(fontSize: 16.sp)),
                      Text("Telefon: ${widget.phone}", style: GoogleFonts.inter(fontSize: 16.sp)),
                      Text("Ödeme: ${widget.fee} TL", style: GoogleFonts.inter(fontSize: 16.sp)),
                      Text("Hizmet Türü: ${widget.cleaningPlace}", style: GoogleFonts.inter(fontSize: 16.sp)),
                      Text("Temizlik Süresi: ${widget.cleaningIndex + 3} Saat", style: GoogleFonts.inter(fontSize: 16.sp)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
                elevation: 10,
                color: Colors.white,
                child: WebViewWidget(controller: _controller)),
          ),
        ],
      ),
    );
  }
}