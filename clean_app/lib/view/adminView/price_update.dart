import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PriceUpdateScreen extends StatefulWidget {
  @override
  _PriceUpdateScreenState createState() => _PriceUpdateScreenState();
}

class _PriceUpdateScreenState extends State<PriceUpdateScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('products').get();
      setState(() {
        products = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Ürünler yüklenirken hata oluştu: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updatePrice(String productId, double newPrice) async {
    try {
      await _firestore.collection('products').doc(productId).update({'price': newPrice});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fiyat başarıyla güncellendi')),
      );
    } catch (e) {
      print('Fiyat güncellenirken hata oluştu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fiyat güncellenirken bir hata oluştu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fiyat Güncelleme',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFD1461E),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(
                    product['name'],
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    '${product['price']} TL',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showUpdateDialog(product),
                  ),
                );
              },
            ),
    );
  }

  void _showUpdateDialog(Map<String, dynamic> product) {
    TextEditingController priceController = TextEditingController(text: product['price'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Fiyat Güncelle'),
          content: TextField(
            controller: priceController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Yeni Fiyat'),
          ),
          actions: [
            TextButton(
              child: Text('İptal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Güncelle'),
              onPressed: () {
                double newPrice = double.tryParse(priceController.text) ?? 0.0;
                _updatePrice(product['id'], newPrice);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
