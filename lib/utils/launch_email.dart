import 'package:url_launcher/url_launcher.dart';

class LaunchEmail {
  static Future<void> launch({
    required String email,
    required void Function(String email) onError,
  }) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      onError(email);
    }
  }
}
