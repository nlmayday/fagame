# Flutter Project Architecture

## Directory Structure

```
lib/
├── main.dart                     # 应用入口，设置环境变量、初始化依赖注入等
├── app.dart                      # 根组件，配置 MaterialApp、主题、路由等
├── router.dart                   # 路由定义，使用 GoRouter 管理导航
├── core/                         # 核心功能模块
│   ├── config/                   # 全局配置（环境切换等）
│   │   ├── environment.dart      # 枚举 dev/staging/prod，统一管理 baseUrl 和是否使用 mock
│   │   └── app_config.dart       # 应用全局配置，如版本号、构建类型等
│
│   ├── network/                  # 网络通信层
│   │   ├── api/                  # REST API 封装
│   │   │   ├── api.dart          # API 配置，统一 baseUrl、timeout、dio 实例
│   │   │   ├── interceptors/     # 拦截器目录
│   │   │   │   ├── auth_interceptor.dart  # 处理认证相关
│   │   │   │   ├── error_interceptor.dart # 统一错误处理
│   │   │   │   ├── logging_interceptor.dart # 日志记录
│   │   │   │   └── mock_interceptor.dart  # Mock 数据拦截器
│   │   │   ├── endpoints/        # 按模块封装请求（如 auth_api.dart, user_api.dart）
│   │   │   └── mock/             # Mock 数据（Dart + JSON）
│   │   │       ├── auth.dart     # mock 数据 (Dart 版)
│   │   │       ├── user.dart
│   │   │       └── gameplay.dart
│   │   ├── ws/                   # WebSocket 通信
│   │   │   ├── client.dart
│   │   │   ├── channels/         # 按功能模块划分通道
│   │   │   │   ├── chat.dart
│   │   │   │   └── game.dart
│   │   │   ├── protocol/
│   │   │   │   ├── message.dart
│   │   │   │   ├── types.dart
│   │   │   │   └── codec.dart
│   │   │   └── reconnect_manager.dart  # 断线重连管理
│   │   └── connectivity/         # 网络连接状态管理
│   │       └── network_monitor.dart
│
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── theme_cubit.dart
│   │   └── theme_extensions/     # 主题扩展
│   │       ├── text_styles.dart
│   │       └── colors.dart
│
│   ├── localization/
│   │   ├── app_localizations.dart
│   │   ├── locale_cubit.dart
│   │   └── l10n/                 # 多语言资源文件
│   │       ├── intl_en.arb
│   │       └── intl_zh.arb
│
│   ├── constants/
│   │   ├── api.dart
│   │   ├── routes.dart
│   │   ├── ui.dart
│   │   └── error_codes.dart      # 错误码定义
│
│   ├── utils/
│   │   ├── format.dart
│   │   ├── logger.dart
│   │   ├── validators.dart
│   │   ├── date_time.dart
│   │   └── extensions/           # Dart 扩展方法
│   │       ├── string_extensions.dart
│   │       ├── date_extensions.dart
│   │       └── context_extensions.dart
│
│   ├── services/                 # 本地服务
│   │   ├── storage/              # 存储服务
│   │   │   ├── storage_service.dart  # 接口
│   │   │   ├── secure_storage.dart   # 安全存储实现
│   │   │   └── shared_prefs.dart     # SharedPreferences 实现
│   │   ├── device.dart
│   │   ├── auth.dart
│   │   ├── analytics.dart        # 数据分析服务
│   │   └── crash_reporting.dart  # 崩溃报告服务
│
│   ├── error/                    # 错误处理
│   │   ├── app_exception.dart    # 应用异常基类
│   │   ├── network_exceptions.dart  # 网络异常
│   │   ├── business_exceptions.dart # 业务逻辑异常
│   │   └── error_handler.dart    # 全局错误处理器
│
│   └── di.dart                   # 依赖注入配置（get_it）
│
├── common/
│   ├── widgets/
│   │   ├── buttons/              # 按钮组件
│   │   │   ├── primary_button.dart
│   │   │   └── icon_button.dart
│   │   ├── text_fields/          # 输入框组件
│   │   │   ├── app_text_field.dart
│   │   │   └── search_field.dart
│   │   ├── dialogs/              # 对话框组件
│   │   │   ├── alert_dialog.dart
│   │   │   └── confirm_dialog.dart
│   │   ├── loadings/             # 加载组件
│   │   │   ├── loading_indicator.dart
│   │   │   └── shimmer.dart
│   │   ├── toasts/               # 提示组件
│   │   │   ├── toast.dart
│   │   │   └── snackbar.dart
│   │   └── layouts/              # 布局组件
│   │       ├── responsive_layout.dart
│   │       └── app_scaffold.dart
│   ├── providers/
│   │   ├── connectivity.dart
│   │   └── settings.dart
│   └── mixins/                   # 混入
│       ├── loading_state_mixin.dart
│       └── validation_mixin.dart
│
├── features/                     # 功能模块（按业务分包）
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── user.dart
│   │   │   │   └── token.dart
│   │   │   ├── repository.dart          # 抽象类（interface）
│   │   │   ├── mock_repository.dart     # Mock 实现
│   │   │   └── real_repository.dart     # Real 实现
│   │   ├── domain/                      # 领域层（业务逻辑）
│   │   │   ├── usecases/                # 用例
│   │   │   │   ├── login_usecase.dart
│   │   │   │   ├── register_usecase.dart
│   │   │   │   └── logout_usecase.dart
│   │   │   └── entities/                # 领域实体
│   │   │       └── user_entity.dart
│   │   ├── presentation/                # 表现层
│   │   │   ├── cubit/                   # 状态管理
│   │   │   │   ├── auth_cubit.dart
│   │   │   │   └── auth_state.dart
│   │   │   ├── pages/
│   │   │   │   ├── login_page.dart
│   │   │   │   └── register_page.dart
│   │   │   └── widgets/
│   │   │       ├── login_form.dart
│   │   │       └── register_form.dart
│   │   └── di.dart                      # 模块依赖注入
│
│   ├── user/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── profile.dart
│   │   │   │   └── settings.dart
│   │   │   ├── repository.dart
│   │   │   ├── mock_repository.dart
│   │   │   └── real_repository.dart
│   │   ├── domain/
│   │   │   ├── usecases/
│   │   │   │   ├── get_profile_usecase.dart
│   │   │   │   └── update_profile_usecase.dart
│   │   │   └── entities/
│   │   │       └── profile_entity.dart
│   │   ├── presentation/
│   │   │   ├── cubit/
│   │   │   │   ├── user_cubit.dart
│   │   │   │   ├── settings_cubit.dart
│   │   │   │   ├── user_state.dart
│   │   │   │   └── settings_state.dart
│   │   │   ├── pages/
│   │   │   │   ├── profile_page.dart
│   │   │   │   ├── settings_page.dart
│   │   │   │   └── feedback_page.dart
│   │   │   └── widgets/
│   │   │       ├── profile_card.dart
│   │   │       └── settings_form.dart
│   │   └── di.dart
│
│   └── gameplay/
│       ├── lobby/
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   └── room.dart
│       │   │   ├── repository.dart
│       │   │   ├── mock_repository.dart
│       │   │   └── real_repository.dart
│       │   ├── domain/
│       │   │   ├── usecases/
│       │   │   │   ├── get_rooms_usecase.dart
│       │   │   │   └── join_room_usecase.dart
│       │   │   └── entities/
│       │   │       └── room_entity.dart
│       │   ├── presentation/
│       │   │   ├── cubit/
│       │   │   │   ├── lobby_cubit.dart
│       │   │   │   └── lobby_state.dart
│       │   │   ├── pages/
│       │   │   │   └── lobby_page.dart
│       │   │   └── widgets/
│       │   │       └── room_card.dart
│       │   └── di.dart
│       └── game/
│           ├── data/
│           │   ├── models/
│           │   │   ├── game.dart
│           │   │   └── player.dart
│           │   ├── repository.dart
│           │   ├── mock_repository.dart
│           │   └── real_repository.dart
│           ├── domain/
│           │   ├── usecases/
│           │   │   ├── start_game_usecase.dart
│           │   │   └── make_move_usecase.dart
│           │   └── entities/
│           │       ├── game_entity.dart
│           │       └── player_entity.dart
│           ├── presentation/
│           │   ├── cubit/
│           │   │   ├── game_cubit.dart
│           │   │   └── game_state.dart
│           │   ├── pages/
│           │   │   └── game_page.dart
│           │   └── widgets/
│           │       └── game_board.dart
│           └── di.dart
│
├── generated/                    # 自动生成的代码
│   ├── l10n/                     # 国际化生成代码
│   └── assets/                   # 资源生成代码
│
└── flavors/                      # 多环境配置
    ├── main_dev.dart
    ├── main_staging.dart
    └── main_prod.dart
``` 