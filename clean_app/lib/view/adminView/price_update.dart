import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

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
        products = querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
        products.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
        isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updatePrice(String docId, String newPrice) async {
    try {
      await _firestore.collection('products').doc(docId).update({'price': newPrice});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Price updated successfully')),
      );
    } catch (e) {
      print('Error updating price: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating price')),
      );
    }
    setState(() {

    });
  }

  Future<void> _addPrice(String roomCount, String productArea, String price) async {
    var uuid = Uuid();
    String uniqueId = uuid.v4();
    try {
      await _firestore.collection('products').add({
        if (roomCount != '') 'room_count': roomCount,
        if (productArea != '') 'product_area': productArea,
        'price': price,
        'id': uniqueId
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Price added successfully')),
      );
      _loadProducts(); // Refresh the product list
    } catch (e) {
      print('Error adding price: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding price')),
      );
    }
  }

  Future<void> _deletePrice(String docId) async {
    try {
      await _firestore.collection('products').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Price deleted successfully')),
      );
      _loadProducts(); // Refresh the product list
    } catch (e) {
      print('Error deleting price: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting price')),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
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
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            if (products.any((product) => product['room_count'] != null))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Color(0xFFD1461E),
                      child: Container(
                        width: double.infinity,
                        height: 30.h,
                        child: Text(
                          'Ev Temizliği Fiyatları',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...products
                      .where((product) => product['room_count'] != null)
                      .map((product) => _buildProductCard(product))
                      .toList(),
                ],
              ),
            if (products.any((product) => product['product_area'] != null))
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: const Color(0xFFD1461E),
                      child: Container(
                        width: double.infinity,
                        height: 30.h,
                        child: Text(
                          'Ofis Temizliği Fiyatları',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                  ...products
                      .where((product) => product['product_area'] != null)
                      .map((product) => _buildProductCard(product))
                      .toList(),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(),
        label: Row(
          children: [
            Text(
              'Yeni Fiyat Ekle',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.add_circle_outline_rounded, color: Colors.white),
          ],
        ),
        backgroundColor: Color(0xFFD1461E),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      color: Colors.white,
      elevation: 10,
      child: ListTile(
        title: Text(
          product['room_count'] != null
              ? 'Temizlik Saati ${product['room_count']}'
              : 'Temizlik Saati ${product['product_area']}',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Ücret :${product['price'] ?? '0'} TL',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => _showUpdateDialog(product),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deletePrice(product['id']),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(Map<String, dynamic> product) {
    TextEditingController priceController = TextEditingController(text: product['price']?.toString() ?? '0');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Price'),
          content: TextField(
            controller: priceController,
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            decoration: InputDecoration(labelText: 'New Price'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                String newPrice = priceController.text;
                _updatePrice(product['id'], newPrice);
                Navigator.of(context).pop();
                setState(() {
                });
              },
            ),
          ],
        );
      },
    );
  }


  void _showAddDialog() {
    TextEditingController roomCountController = TextEditingController();
    TextEditingController productAreaController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    String? cleaningType;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Teklif Ekle'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Temizlik Türü'),
                    items: [
                      DropdownMenuItem(value: 'Ev Temizliği', child: Text('Ev Temizliği')),
                      DropdownMenuItem(value: 'Ofis Temizliği', child: Text('Ofis Temizliği')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        cleaningType = value;
                        roomCountController.clear();
                        productAreaController.clear();
                      });
                    },
                  ),
                  if (cleaningType == 'Ev Temizliği')
                    TextField(
                      controller: roomCountController,
                      decoration: InputDecoration(labelText: 'Temizlik Süresi (saat)'),
                    ),
                  if (cleaningType == 'Ofis Temizliği')
                    TextField(
                      controller: productAreaController,
                      decoration: InputDecoration(labelText: 'Temizlik Süresi (saat)'),
                    ),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: 'Ücret'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    String? roomCount = roomCountController.text.isNotEmpty ? roomCountController.text : null;
                    String? productArea = productAreaController.text.isNotEmpty ? productAreaController.text : null;
                    String price = priceController.text;

                    if ((roomCount != null || productArea != null) && price.isNotEmpty) {
                      _addPrice(roomCount ?? '', productArea ?? '', price);
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lütfen gerekli tüm alanları doldurun')),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}