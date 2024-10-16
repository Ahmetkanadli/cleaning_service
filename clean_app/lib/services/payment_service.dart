import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';

class PaymentService {
  late final String merchantId;
  late final String merchantKey;
  late final String merchantSalt;

  PaymentService() {
    _initializeRemoteConfig();
  }

  Future<void> _initializeRemoteConfig() async {
    await Firebase.initializeApp();
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.fetchAndActivate();

    merchantId = remoteConfig.getString('merchant_id');
    merchantKey = remoteConfig.getString('merchant_key');
    merchantSalt = remoteConfig.getString('merchant_salt');
  }

  Future<String?> startPayment({
    required double amount,
    required String email,
    required String name,
    required String address,
    required String phone,
  }) async {
    String merchantOid = DateTime.now().millisecondsSinceEpoch.toString();
    int paymentAmount = (amount * 100).toInt();

    String userBasket = base64Encode(utf8.encode(jsonEncode([
      ["Örnek ürün", amount.toString(), "1"]
    ])));

    String merchantOkUrl = "https://www.siteniz.com/odeme_basarili.php";
    String merchantFailUrl = "https://www.siteniz.com/odeme_hata.php";
    String userIp = "192.168.1.1"; // Replace with actual IP address

    String hashStr = merchantId +
        userIp +
        merchantOid +
        email +
        paymentAmount.toString() +
        userBasket +
        "0" + // no_installment
        "0" + // max_installment
        "TL" + // currency
        "1"; // test_mode

    var bytes = utf8.encode(hashStr + merchantSalt);
    var hmacSha256 = Hmac(sha256, utf8.encode(merchantKey));
    var digest = hmacSha256.convert(bytes);

    String paytrToken = base64Encode(digest.bytes);

    Map<String, dynamic> data = {
      "merchant_id": merchantId,
      "user_ip": userIp,
      "merchant_oid": merchantOid,
      "email": email,
      "payment_amount": paymentAmount.toString(),
      "paytr_token": paytrToken,
      "user_basket": userBasket,
      "debug_on": "1",
      "no_installment": "0",
      "max_installment": "0",
      "user_name": name,
      "user_address": address,
      "user_phone": phone,
      "merchant_ok_url": merchantOkUrl,
      "merchant_fail_url": merchantFailUrl,
      "timeout_limit": "30",
      "currency": "TL",
      "test_mode": "1"
    };

    var url = Uri.parse('https://www.paytr.com/odeme/api/get-token');
    var response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      if (responseBody['status'] == 'success') {
        return responseBody['token'];
      } else {
        throw Exception('Token alınamadı: ${responseBody['reason']}');
      }
    } else {
      throw Exception('Ödeme işlemi başarısız oldu.');
    }
  }
}