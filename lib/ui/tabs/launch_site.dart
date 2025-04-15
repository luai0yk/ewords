import 'package:url_launcher/url_launcher.dart';

class LaunchSite {
  static Future<void> launch({
    required String url,
    required void Function(String url) onError,
  }) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      onError(url);
    }
  }
}
