// lib/view/userView/payment_screen/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clean_app/services/payment_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPopup extends StatefulWidget {
  final int amount;

  const PaymentPopup({super.key, required this.amount});

  @override
  _PaymentPopupState createState() => _PaymentPopupState();
}

class _PaymentPopupState extends State<PaymentPopup> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phoneNumber = '';
  String _address = '';
  String _email = '';
  bool _loading = false;

  Future<void> _startPayment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _loading = true;
      });

      try {
        String? token = await PaymentService().startPayment(
          amount: widget.amount.toDouble(),
          email: _email,
          name: _name,
          address: _address,
          phone: _phoneNumber,
        );

        if (token != null) {
          String paymentUrl = "https://www.paytr.com/odeme/guvenli/$token";
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(paymentUrl: paymentUrl),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ödenecek Miktar: ${widget.amount} TL',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'İsim',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen isminizi giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Telefon Numarası',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen telefon numaranızı giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phoneNumber = value!;
                },
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Adres',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen adresinizi giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                },
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen e-mail adresinizi giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              SizedBox(height: 20.h),
              Center(
                child: _loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFD1461E).withOpacity(0.9)),
                  ),
                  onPressed: _startPayment,
                  child: Text(
                    'Ödeme Yap',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final String paymentUrl;

  PaymentScreen({required this.paymentUrl});

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
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ödeme Sayfası'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}