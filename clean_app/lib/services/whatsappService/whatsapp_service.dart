import 'package:url_launcher/url_launcher.dart';

class WhatsappService {

  void launchWhatsApp(String phone) async {
    const phoneNumber = '+905376827797'; // Replace with the desired phone number
    final Uri url = phone != '' ?
      Uri.parse('https://wa.me/$phone') : Uri.parse('https://wa.me/$phoneNumber');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}