# Flutter Project Architecture Guidelines

## Project Structure

1. **严格遵循已定义的目录结构**，保持层次清晰
2. **新功能必须在features/目录下按业务分包**
3. **每个功能模块必须遵循data/domain/presentation分层**

## Architecture Principles

1. **Clean Architecture**
   - 数据流向: data → domain → presentation
   - 依赖方向: presentation → domain ← data
   - domain层不依赖框架实现

2. **SOLID原则**
   - 每个类/方法只有单一职责
   - 接口与实现分离
   - 依赖抽象而非具体实现

## Code Standards

1. **命名约定**
   - 文件: snake_case.dart
   - 类: PascalCase
   - 方法/变量: camelCase
   - 常量: UPPER_SNAKE_CASE

2. **分层职责**
   - data: 数据获取、转换、API交互
   - domain: 业务逻辑、用例定义
   - presentation: UI渲染、状态管理

3. **依赖注入**
   - 各模块通过di.dart注册依赖
   - 依赖注入使用get_it
   - 测试环境可替换为mock实现

4. **状态管理**
   - 使用Cubit/BLoC模式
   - 状态immutable
   - 事件驱动式UI更新

## Network & Async

1. **API请求**
   - 统一使用api.dart中的dio实例
   - 遵循endpoints/下的模块化API定义
   - 所有请求必须处理异常

2. **WebSocket**
   - 通过定义的通道处理特定功能
   - 实现断线重连机制

3. **Mock 数据与真实 API 切换**
   - 每个功能模块必须同时实现 mock_repository 和 real_repository
   - Mock 数据应存放在 core/network/api/mock/ 目录下
   - 在 environment.dart 中通过环境变量控制是否使用 mock 数据
   - 使用 mock_interceptor.dart 拦截真实请求并返回模拟数据
   - 开发初期优先使用 mock 数据，待后端 API 完成后切换至真实数据
   - Mock 数据应尽可能模拟真实数据结构和场景

## Localization & Internationalization

1. **多语言支持**
   - 所有用户可见的文本必须使用 app_localizations 进行国际化
   - 禁止在代码中硬编码字符串，应使用国际化 key
   - 所有国际化资源存放在 core/localization/l10n/ 目录下
   - 支持中文和英文作为基础语言

2. **错误消息与异常**
   - 所有错误消息必须国际化，包括后端返回的错误
   - 错误码与消息映射存放在 constants/error_codes.dart
   - 通过 error_handler.dart 统一处理并转换为本地化消息

3. **UI 文本**
   - 所有 UI 元素文本（按钮、标签、提示等）必须使用国际化资源
   - 日期、货币、数字等格式化显示需遵循本地化规则
   - 支持 RTL 语言布局（如阿拉伯语）的可能性

## Error Handling

1. **异常分类**
   - 网络异常：由 network_exceptions.dart 处理
   - 业务异常：由 business_exceptions.dart 处理 
   - 应用异常：由 app_exception.dart 处理

2. **异常展示**
   - 所有向用户展示的错误信息必须国际化
   - 使用统一的 Toast/Snackbar 组件展示错误
   - 严重错误使用对话框展示
   - 表单验证错误就近展示

3. **错误记录**
   - 所有异常必须记录日志
   - 关键错误需上报至崩溃分析服务

## Testing Strategy

1. **每个模块必有测试**
   - 单元测试: domain层逻辑
   - 组件测试: presentation层UI
   - 集成测试: 功能流程

2. **Mock测试**
   - 每个repository需有mock实现
   - 测试环境优先使用mock数据