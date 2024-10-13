// lib/models/service_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String city;
  final String district;
  final String address;
  final String phone;
  final int fee;
  final DateTime timestamp;
  final String cleaningPlace;
  final String numberOfRoomsOrArea;
  final int cleaningTime;
  final String status;

  ServiceModel({
    required this.city,
    required this.district,
    required this.address,
    required this.phone,
    required this.fee,
    required this.timestamp,
    required this.cleaningPlace,
    required this.numberOfRoomsOrArea,
    required this.cleaningTime,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'district': district,
      'address': address,
      'phone': phone,
      'fee': fee,
      'timestamp': timestamp,
      'cleaningPlace': cleaningPlace,
      'numberOfRoomsOrArea': numberOfRoomsOrArea,
      'cleaningTime': cleaningTime,
      'status': status,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      city: map['city'],
      district: map['district'],
      address: map['address'],
      phone: map['phone'],
      fee: map['fee'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      cleaningPlace: map['cleaningPlace'],
      numberOfRoomsOrArea: map['numberOfRoomsOrArea'],
      cleaningTime: map['cleaningTime'],
      status: map['status'], // Add status from map
    );
  }
}