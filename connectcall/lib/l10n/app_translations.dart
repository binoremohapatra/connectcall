class AppTranslations {
  static const Map<String, Map<String, String>> strings = {
    'en': {
      'language': 'English (US)',
      'preferences': 'PREFERENCES',
      'dark_mode': 'Dark Mode',
      'dark_mode_sub': 'Follows your system setting',
      'notifications': 'Notifications',
      'notifications_sub': 'Calls and activity alerts',
      'privacy': 'PRIVACY & ACCESS',
      'camera': 'Camera Access',
      'camera_granted': 'Granted ✓',
      'camera_req': 'Required for video calls',
      'mic': 'Microphone',
      'mic_granted': 'Granted ✓',
      'mic_req': 'Required for all calls',
      'e2ee': 'End-to-End Encryption',
      'e2ee_sub': 'Your calls are always private',
      'account': 'ACCOUNT',
      'lang_title': 'Language',
      'help': 'Help Center',
      'help_sub': 'Get support and answers',
      'logout': 'Log Out',
    },
    'hi': {
      'language': 'हिंदी (Hindi)',
      'preferences': 'प्राथमिकताएं',
      'dark_mode': 'डार्क मोड',
      'dark_mode_sub': 'सिस्टम सेटिंग का पालन करता है',
      'notifications': 'सूचनाएं',
      'notifications_sub': 'कॉल और गतिविधि अलर्ट',
      'privacy': 'गोपनीयता और एक्सेस',
      'camera': 'कैमरा एक्सेस',
      'camera_granted': 'स्वीकृत ✓',
      'camera_req': 'वीडियो कॉल के लिए आवश्यक',
      'mic': 'माइक्रोफ़ोन',
      'mic_granted': 'स्वीकृत ✓',
      'mic_req': 'सभी कॉल के लिए आवश्यक',
      'e2ee': 'एंड-टू-एंड एन्क्रिप्शन',
      'e2ee_sub': 'आपकी कॉल्स हमेशा निजी हैं',
      'account': 'खाता',
      'lang_title': 'भाषा',
      'help': 'सहायता केंद्र',
      'help_sub': 'समर्थन और उत्तर प्राप्त करें',
      'logout': 'लॉग आउट',
    }
  };

  static String get(String langCode, String key) {
    return strings[langCode]?[key] ?? strings['en']?[key] ?? key;
  }
}
