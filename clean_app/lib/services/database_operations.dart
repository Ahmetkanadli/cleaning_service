import 'package:clean_app/models/product.dart';
import 'package:clean_app/models/service_model.dart';
import 'package:clean_app/services/notificationService/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseOperations{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Map<String, dynamic>> fetchAdminPanelData() async {
    try {
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      int customerCount = usersSnapshot.size;

      int doneOrders = 0;
      int notDoneOrders = 0;
      int onTheWayOrders = 0;
      double monthlyRevenue = 0;
      double yearlyRevenue = 0;

      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime startOfYear = DateTime(now.year, 1, 1);

      for (var userDoc in usersSnapshot.docs) {
        QuerySnapshot servicesSnapshot = await userDoc.reference
            .collection('past_services')
            .get();

        for (var serviceDoc in servicesSnapshot.docs) {
          Map<String, dynamic>? serviceData = serviceDoc.data() as Map<String, dynamic>?;

          if (serviceData != null) {
            Timestamp? timestamp = serviceData['timestamp'] as Timestamp?;
            if (timestamp != null) {
              DateTime dateTime = timestamp.toDate();
              double fee = serviceData['fee'];

              if (serviceData['status'] == 'Tamamlandı') {
                doneOrders++;
              } else if (serviceData['status'] == 'Yapılmadı') {
                notDoneOrders++;
              } else if (serviceData['status'] == 'Ekip yolda') {
                onTheWayOrders++;
              }

              if (dateTime.isAfter(startOfMonth)) {
                monthlyRevenue += fee;
              }

              if (dateTime.isAfter(startOfYear)) {
                yearlyRevenue += fee;
              }
            }
          }
        }
      }

      return {
        'customerCount': customerCount,
        'doneOrders': doneOrders,
        'notDoneOrders': notDoneOrders,
        'onTheWayOrders': onTheWayOrders,
        'monthlyRevenue': monthlyRevenue,
        'yearlyRevenue': yearlyRevenue,
      };
    } catch (e) {
      print("Error fetching admin panel data: $e");
      return {};
    }
  }

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

  Future<void> updateUserProfile(String userId, String name, {String? newPassword}) async {
    try {
      Map<String, dynamic> updateData = {'name': name};
      
      await _firestore.collection('users').doc(userId).update(updateData);
      
      if (newPassword != null && newPassword.isNotEmpty) {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updatePassword(newPassword);
        }
      }
      
      print("Kullanıcı profili başarıyla güncellendi.");
    } catch (e) {
      print("Kullanıcı profili güncellenirken hata oluştu: $e");
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
            
            if (newStatus == 'Ekip yolda') {
              // Bildirim gönderme işlemi
              NotificationService notificationService = NotificationService();
              DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
              String? fcmToken = userSnapshot.get('fcmToken');
              if (fcmToken != null) {
                await notificationService.sendNotification(
                  to: 'admin',
                  title: 'Sipariş Durumu Güncellendi',
                  body: 'Ekibimiz yola çıktı! Yakında hizmet noktanızda olacağız.',
                  fcmToken: fcmToken,
                );
              } else {
                print("Kullanıcının FCM token'ı bulunamadı.");
              }
            }
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
  Future<int> fetchCustomerCount() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      return usersSnapshot.size;
    } catch (e) {
      print("Error fetching customer count: $e");
      return 0;
    }
  }
}