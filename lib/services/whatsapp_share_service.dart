// WhatsApp Sharing Service
import 'package:ewords/services/share_service.dart';

// WhatsApp Sharing
class WhatsAppShareService {
  static Future<void> share({
    required String text,
    required Function(String msg) onError,
  }) async {
    final Uri url = Uri.parse(
      'whatsapp://send?text=${Uri.encodeComponent(text)}',
    );
    ShareService.share(
        text: text, url: url, platformName: 'WhatsApp', onError: onError);
  }
}
