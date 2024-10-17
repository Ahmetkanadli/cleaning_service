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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ödeme Sayfası'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}