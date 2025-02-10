// Telegram Sharing Service
import 'package:ewords/services/share_service.dart';

// Telegram Sharing
class TelegramShareService {
  static Future<void> share({
    required String text,
    required Function(String msg) onError,
  }) async {
    final Uri url = Uri.parse(
      'https://t.me/share/url?url=${Uri.encodeComponent(text)}',
    );
    ShareService.share(
        text: text, url: url, platformName: 'Telegram', onError: onError);
  }
}
