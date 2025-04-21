import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fagame/core/localization/app_localizations.dart';
import 'package:fagame/core/services/locale_service.dart';
import 'package:fagame/router.dart';
import 'package:get_it/get_it.dart';

/// 全局依赖注入实例
final GetIt sl = GetIt.instance;

/// 全局导航键，用于在拦截器等非widget上下文中进行导航
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// 应用的根组件
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _localeService = sl<LocaleService>();

  @override
  void initState() {
    super.initState();
    // 初始化语言服务
    _localeService.init();
  }

  @override
  Widget build(BuildContext context) {
    // 创建路由配置
    final router = createRouter(navigatorKey: navigatorKey);

    return ValueListenableBuilder<Locale?>(
      valueListenable: _localeService.localeNotifier,
      builder: (context, locale, child) {
        return MaterialApp.router(
          // 路由配置
          routerConfig: router,

          // 应用标题
          title: 'FA Game',

          // 关闭Debug标签
          debugShowCheckedModeBanner: false,

          // 主题配置
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            // 按钮主题
            elevatedButtonTheme:
                ElevatedButtonTheme.of(context).style != null
                    ? ElevatedButtonTheme.of(context)
                    : ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
            // 输入框主题
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),

          // 多语言支持
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale, // 使用语言服务管理的语言
        );
      },
    );
  }
}
