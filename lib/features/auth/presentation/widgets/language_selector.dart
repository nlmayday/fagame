import 'package:flutter/material.dart';
import 'package:fagame/core/localization/app_localizations.dart';
import 'package:fagame/core/services/locale_service.dart';
import 'package:get_it/get_it.dart';

/// 语言选择器按钮
class LanguageSelector extends StatelessWidget {
  final bool isDense;

  const LanguageSelector({Key? key, this.isDense = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeService = GetIt.instance<LocaleService>();
    final l10n = AppLocalizations.of(context);

    return PopupMenuButton<Locale>(
      tooltip: l10n.language,
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.language, size: isDense ? 20 : 24),
          if (!isDense) ...[const SizedBox(width: 4), Text(l10n.language)],
        ],
      ),
      onSelected: (Locale locale) {
        localeService.setLocale(locale);
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<Locale>(
            value: const Locale('en'),
            child: Row(
              children: [
                const Text('🇺🇸 '),
                Text(l10n.english),
                const SizedBox(width: 8),
                if (localeService.currentLocale?.languageCode == 'en')
                  const Icon(Icons.check, size: 16),
              ],
            ),
          ),
          PopupMenuItem<Locale>(
            value: const Locale('zh'),
            child: Row(
              children: [
                const Text('🇨🇳 '),
                Text(l10n.chinese),
                const SizedBox(width: 8),
                if (localeService.currentLocale?.languageCode == 'zh')
                  const Icon(Icons.check, size: 16),
              ],
            ),
          ),
        ];
      },
    );
  }
}
