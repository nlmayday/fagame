import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 语言服务，用于管理应用的语言设置
class LocaleService {
  static const String _localeKey = 'app_locale';

  // 支持的语言列表
  static const List<Locale> supportedLocales = [
    Locale('en'), // 英语
    Locale('zh'), // 中文
  ];

  // 单例实例
  static final LocaleService _instance = LocaleService._internal();
  factory LocaleService() => _instance;
  LocaleService._internal();

  // 当前语言
  Locale? _currentLocale;

  // 语言变化监听器
  final _localeController = ValueNotifier<Locale?>(null);
  ValueNotifier<Locale?> get localeNotifier => _localeController;

  /// 初始化，从存储中加载语言设置
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);

    if (languageCode != null &&
        supportedLocales.any((l) => l.languageCode == languageCode)) {
      _currentLocale = Locale(languageCode);
      _localeController.value = _currentLocale;
    }
  }

  /// 获取当前语言
  Locale? get currentLocale => _currentLocale;

  /// 设置语言
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale) &&
        !supportedLocales.any((l) => l.languageCode == locale.languageCode)) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);

    _currentLocale = locale;
    _localeController.value = locale;
  }

  /// 重置为系统默认语言
  Future<void> resetToSystemLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);

    _currentLocale = null;
    _localeController.value = null;
  }

  /// 获取语言名称
  String getLanguageName(Locale locale, BuildContext context) {
    switch (locale.languageCode) {
      case 'en':
        return '英文'; // English
      case 'zh':
        return '中文'; // Chinese
      default:
        return locale.languageCode;
    }
  }
}
