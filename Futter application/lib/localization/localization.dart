// lib/localization/localization.dart

import 'package:flutter/foundation.dart';

/// Supported languages
enum AppLanguage { en, hi, pa }

/// All string keys in one place
class LocKeys {
  static const appName = 'app_name';
  static const welcomeUser = 'welcome_user';
  static const myEcoImpact = 'my_eco_impact';
  static const ecoScore = 'eco_score';
  static const wasteDiverted = 'waste_diverted';
  static const pollution = 'pollution';
  static const co2Saved = 'co2_saved';
  static const communityRank = 'community_rank';
  static const quickScan = 'quick_scan';
  static const binLocator = 'bin_locator';
  static const activitiesChallenges = 'activities_challenges';
  static const ecoNews = 'eco_news';
  static const featuredChallenges = 'featured_challenges';
  static const home = 'home';
  static const scan = 'scan';
  static const activities = 'activities';
  static const impact = 'impact';
  static const profile = 'profile';
  static const loading = 'loading';
  static const chooseLanguage = 'choose_language';
  static const english = 'english';
  static const hindi = 'hindi';
  static const punjabi = 'punjabi';
}

/// language -> key -> value
final Map<AppLanguage, Map<String, String>> _localizedValues = {
  AppLanguage.en: {
    LocKeys.appName: 'EcoBuddy',
    LocKeys.welcomeUser: 'Welcome, User!',
    LocKeys.myEcoImpact: 'My Eco Impact',
    LocKeys.ecoScore: 'Eco Score',
    LocKeys.wasteDiverted: 'Waste\nDiverted',
    LocKeys.pollution: '410K\nPollution',
    LocKeys.co2Saved: 'CO₂\nSaved',
    LocKeys.communityRank: 'Community\nRank',
    LocKeys.quickScan: 'Quick Scan',
    LocKeys.binLocator: 'Bin Locator',
    LocKeys.activitiesChallenges: 'Activities &\nChallenges',
    LocKeys.ecoNews: 'Eco News',
    LocKeys.featuredChallenges: 'Featured Challenges',
    LocKeys.home: 'Home',
    LocKeys.scan: 'Scan',
    LocKeys.activities: 'Activities',
    LocKeys.impact: 'Impact',
    LocKeys.profile: 'Profile',
    LocKeys.loading: 'Loading your eco world…',
    LocKeys.chooseLanguage: 'Choose Language',
    LocKeys.english: 'English',
    LocKeys.hindi: 'Hindi',
    LocKeys.punjabi: 'Punjabi',
  },

  AppLanguage.hi: {
    LocKeys.appName: 'EcoBuddy',
    LocKeys.welcomeUser: 'स्वागत है, उपयोगकर्ता!',
    LocKeys.myEcoImpact: 'मेरा इको प्रभाव',
    LocKeys.ecoScore: 'इको स्कोर',
    LocKeys.wasteDiverted: 'कचरा\nहटाया',
    LocKeys.pollution: '410K\nप्रदूषण',
    LocKeys.co2Saved: 'CO₂\nबचाया',
    LocKeys.communityRank: 'समुदाय\nरैंक',
    LocKeys.quickScan: 'तुरंत स्कैन',
    LocKeys.binLocator: 'डस्टबिन खोजें',
    LocKeys.activitiesChallenges: 'गतिविधियां और\nचैलेंज',
    LocKeys.ecoNews: 'इको समाचार',
    LocKeys.featuredChallenges: 'फ़ीचर्ड चैलेंज',
    LocKeys.home: 'होम',
    LocKeys.scan: 'स्कैन',
    LocKeys.activities: 'गतिविधियां',
    LocKeys.impact: 'प्रभाव',
    LocKeys.profile: 'प्रोफ़ाइल',
    LocKeys.loading: 'आपकी इको दुनिया लोड हो रही है…',
    LocKeys.chooseLanguage: 'भाषा चुनें',
    LocKeys.english: 'अंग्रेज़ी',
    LocKeys.hindi: 'हिन्दी',
    LocKeys.punjabi: 'पंजाबी',
  },

  AppLanguage.pa: {
    LocKeys.appName: 'EcoBuddy',
    LocKeys.welcomeUser: 'ਸਵਾਗਤ ਹੈ, ਯੂਜ਼ਰ!',
    LocKeys.myEcoImpact: 'ਮੇਰਾ ਈਕੋ ਇੰਪੈਕਟ',
    LocKeys.ecoScore: 'ਈਕੋ ਸਕੋਰ',
    LocKeys.wasteDiverted: 'ਕਚਰਾ\nਹਟਾਇਆ',
    LocKeys.pollution: '410K\nਪਾਲਿਊਸ਼ਨ',
    LocKeys.co2Saved: 'CO₂\nਬਚਾਇਆ',
    LocKeys.communityRank: 'ਕਮਿਊਨਟੀ\nਰੈਂਕ',
    LocKeys.quickScan: 'ਕੁਇਕ ਸਕੈਨ',
    LocKeys.binLocator: 'ਬਿਨ ਲੋਕੇਟਰ',
    LocKeys.activitiesChallenges: 'ਐਕਟਿਵਿਟੀਆਂ ਅਤੇ\nਚੈਲੇਂਜ',
    LocKeys.ecoNews: 'ਈਕੋ ਨਿਊਜ਼',
    LocKeys.featuredChallenges: 'ਫੀਚਰਡ ਚੈਲੇਂਜ',
    LocKeys.home: 'ਹੋਮ',
    LocKeys.scan: 'ਸਕੈਨ',
    LocKeys.activities: 'ਐਕਟਿਵਿਟੀਆਂ',
    LocKeys.impact: 'ਇੰਪੈਕਟ',
    LocKeys.profile: 'ਪ੍ਰੋਫ਼ਾਈਲ',
    LocKeys.loading: 'ਤੁਹਾਡੀ ਈਕੋ ਦੁਨੀਆਂ ਲੋਡ ਹੋ ਰਹੀ ਹੈ…',
    LocKeys.chooseLanguage: 'ਭਾਸ਼ਾ ਚੁਣੋ',
    LocKeys.english: 'ਅੰਗਰੇਜ਼ੀ',
    LocKeys.hindi: 'ਹਿੰਦੀ',
    LocKeys.punjabi: 'ਪੰਜਾਬੀ',
  },
};

/// Simple helper class you can pass around
class AppLocalization {
  final AppLanguage language;
  const AppLocalization(this.language);

  String t(String key) {
    final map = _localizedValues[language];
    if (map == null) {
      if (kDebugMode) {
        print('No localization map for $language');
      }
      return key;
    }
    return map[key] ?? key;
  }
}