import 'package:clean_app/models/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseOperations{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getUserName() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    return _firestore.collection('users').doc(userId).get().then((value) => value.data()?['name']);
  }

  Future<List<Map<String, dynamic>>> getPastServices() async {

    String? userId = FirebaseAuth.instance.currentUser?.uid;

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('past_services')
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error getting past services: $e");
      return [];
    }
  }

  Future<void> addPastService({
    required String userId,
    required ServiceModel service,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).collection("past_services")
          .add(service.toMap());
    } catch (e) {
      print("Error adding past service: $e");
    }
  }

  // lib/services/database_operations.dart
  Future<List<Map<String, dynamic>>> getAllUsersPastServices() async {
    try {
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      List<Map<String, dynamic>> allPastServices = [];

      for (var userDoc in usersSnapshot.docs) {
        var userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          String userName = userData['name'];
          QuerySnapshot pastServicesSnapshot = await userDoc.reference.collection('past_services').orderBy('timestamp', descending: true).get();
          for (var serviceDoc in pastServicesSnapshot.docs) {
            Map<String, dynamic> serviceData = serviceDoc.data() as Map<String, dynamic>;
            serviceData['userName'] = userName; // Add user name to service data
            allPastServices.add(serviceData);
          }
        }
      }

      return allPastServices;
    } catch (e) {
      print("Error getting all users' past services: $e");
      return [];
    }
  }

}