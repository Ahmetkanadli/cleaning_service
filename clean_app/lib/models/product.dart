import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String? room_count;
  final String? product_area;
  final String price;

  Product({
    required this.id,
    this.product_area,
    this.room_count,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_area': product_area ?? '',
      'room_count': room_count ?? '',
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      product_area: map['product_area'] ?? '',
      room_count: map['room_count'] ?? '',
      price: map['price'],
    );
  }
}