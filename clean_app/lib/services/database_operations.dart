import 'package:clean_app/models/product.dart';
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
      // Tek belge olan 'servicesList'i alıyoruz
      DocumentSnapshot servicesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('past_services')
          .doc('servicesList')
          .get();

      if (servicesSnapshot.exists) {
        Map<String, dynamic>? data = servicesSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('services')) {
          List<dynamic> pastServices = data['services'];

          // Zaman damgasına göre sıralıyoruz
          pastServices.sort((a, b) {
            DateTime timestampA = (a['timestamp'] as Timestamp).toDate();
            DateTime timestampB = (b['timestamp'] as Timestamp).toDate();
            return timestampB.compareTo(timestampA); // Descending order
          });

          return pastServices.map((service) => service as Map<String, dynamic>).toList();
        }
      }

      // Eğer belge yoksa veya veri boşsa, boş bir liste döner
      return [];
    } catch (e) {
      print("Error getting past services: $e");
      return [];
    }
  }

  Future<void> addPastService({
    required String userId,
    required ServiceModel service,
  }) async {
    DocumentReference userRef = _firestore.collection('users').doc(userId);
    DocumentReference servicesRef = userRef.collection("past_services").doc('servicesList'); // Tek bir belge

    try {
      // Mevcut servislerin listesini alıyoruz
      DocumentSnapshot snapshot = await servicesRef.get();
      List<dynamic> pastServices = [];

      if (snapshot.exists) {
        // Eğer belge varsa, mevcut servislere ek yapacağız
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('services')) {
          pastServices = data['services']; // Servisler listesi
        }
      }

      // Yeni servisi listenin sonuna ekliyoruz
      pastServices.add(service.toMap());

      // Listeyi yeniden Firestore'a yazıyoruz
      await servicesRef.set({'services': pastServices});

      print("Service added successfully.");
    } catch (e) {
      print("Error adding past service: $e");
    }
  }

  Future<void> updatePastService({
    required String userId,
    required int serviceIndex, // Düzenlenecek servisin indeksi
    required ServiceModel updatedService, // Güncellenmiş servis
  }) async {
    DocumentReference servicesRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('past_services')
        .doc('servicesList');

    try {
      // Mevcut servis listesini alıyoruz
      DocumentSnapshot snapshot = await servicesRef.get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('services')) {
          List<dynamic> pastServices = data['services'];

          if (serviceIndex >= 0 && serviceIndex < pastServices.length) {
            // Belirli servisi güncelle
            pastServices[serviceIndex] = updatedService.toMap();

            // Güncellenmiş listeyi yeniden Firestore'a yaz
            await servicesRef.update({'services': pastServices});
            print("Service updated successfully.");
          } else {
            print("Error: Invalid service index.");
          }
        }
      }
    } catch (e) {
      print("Error updating service: $e");
    }
  }

  Future<void> updateServiceStatus(String userId, String merchantOid, String newStatus) async {
    DocumentReference servicesRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('past_services')
        .doc('servicesList');

    try {
      DocumentSnapshot snapshot = await servicesRef.get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('services')) {
          List<dynamic> pastServices = data['services'];

          int index = pastServices.indexWhere((service) => service['merchantOid'] == merchantOid);
          if (index != -1) {
            pastServices[index]['status'] = newStatus;    
            await servicesRef.update({'services': pastServices});
            print("Sipariş durumu başarıyla güncellendi.");
          } else {
            print("Hata: Belirtilen merchantOid ile eşleşen sipariş bulunamadı.");
          }
        }
      }
    } catch (e) {
      print("Sipariş durumu güncellenirken hata oluştu: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsersPastServices() async {
    try {
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      List<Map<String, dynamic>> allPastServices = [];

      // Tüm kullanıcıları döngüyle gez
      for (var userDoc in usersSnapshot.docs) {
        var userData = userDoc.data() as Map<String, dynamic>?;
        if (userData != null) {
          String docID = userDoc.id; // Kullanıcının docID'sini al
          String userName = userData['name'];
          print("DocID: $docID, UserName: $userName");

          // Her kullanıcının past_services koleksiyonundaki 'servicesList' belgesini oku
          DocumentSnapshot servicesSnapshot = await userDoc.reference
              .collection('past_services')
              .doc('servicesList')
              .get();

          if (servicesSnapshot.exists) {
            Map<String, dynamic>? servicesData = servicesSnapshot.data() as Map<String, dynamic>?;

            if (servicesData != null && servicesData.containsKey('services')) {
              List<dynamic> pastServices = servicesData['services'];

              // Her servisi gez ve kullanıcı docID'sini ekleyerek tüm servisler listesine ekle
              for (var service in pastServices) {
                Map<String, dynamic> serviceData = service as Map<String, dynamic>;
                serviceData['userDocID'] = docID; // Kullanıcı docID'sini servise ekle
                serviceData['userName'] = userName; // Kullanıcı adını da ekleyelim
                allPastServices.add(serviceData);
              }
            }
          }
        }
      }
      return allPastServices;
    } catch (e) {
      print("Error getting all users' past services: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      List<Map<String, dynamic>> products = [];

      for (var doc in snapshot.docs) {
        Product product = Product.fromMap(doc.data() as Map<String, dynamic>);
        products.add(product.toMap());
      }
      print("products: $products");
      return products;
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getActiveServices(String? userId) async {
    if (userId == null) return [];

    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('past_services')
          .doc('servicesList')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('services')) {
          List<dynamic> services = data['services'];
          return services.where((service) => service['status'] != 'Tamamlandı').map((service) => service as Map<String, dynamic>).toList();
        }
      }
    } catch (e) {
      print("Error getting active services: $e");
    }
    return [];
  }

}