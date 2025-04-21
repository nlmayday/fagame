import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fagame/l10n/app_localizations.dart' as gen;

export 'package:fagame/l10n/app_localizations.dart';

/// App本地化配置
class AppLocalizations {
  /// 支持的语言列表
  static const List<Locale> supportedLocales = [Locale('en'), Locale('zh')];

  /// 本地化代理
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    gen.AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// 从上下文获取本地化实例
  static gen.AppLocalizations of(BuildContext context) {
    return gen.AppLocalizations.of(context)!;
  }
}
