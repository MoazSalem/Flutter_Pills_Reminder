import 'package:get/get_navigation/src/root/internacionalization.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'appName': 'Pills Reminder',
      'noPills': 'No Pills Scheduled for Reminder',
      'remaining': 'Remaining Pills:',
      'settings': 'Settings',
    },
  };
}
