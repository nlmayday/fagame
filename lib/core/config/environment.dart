/// 应用环境配置枚举
enum EnvironmentType {
  /// 开发环境
  dev,

  /// 测试环境
  staging,

  /// 生产环境
  prod,
}

/// 环境配置类
class Environment {
  /// 环境类型
  final EnvironmentType type;

  /// 是否使用模拟数据
  final bool useMock;

  /// 基础URL
  final String baseUrl;

  /// 创建环境配置
  const Environment({
    required this.type,
    required this.useMock,
    required this.baseUrl,
  });

  /// 开发环境配置
  factory Environment.dev() {
    return const Environment(
      type: EnvironmentType.dev,
      useMock: true, // 默认使用模拟数据
      baseUrl: 'https://dev-api.example.com',
    );
  }

  /// 测试环境配置
  factory Environment.staging() {
    return const Environment(
      type: EnvironmentType.staging,
      useMock: false,
      baseUrl: 'https://staging-api.example.com',
    );
  }

  /// 生产环境配置
  factory Environment.prod() {
    return const Environment(
      type: EnvironmentType.prod,
      useMock: false,
      baseUrl: 'https://api.example.com',
    );
  }

  /// 创建实际API环境配置，方便切换
  factory Environment.realApi() {
    return const Environment(
      type: EnvironmentType.dev,
      useMock: false, // 使用真实API
      baseUrl: 'https://dev-api.example.com',
    );
  }

  /// 创建模拟API环境配置，方便切换
  factory Environment.mockApi() {
    return const Environment(
      type: EnvironmentType.dev,
      useMock: true, // 使用模拟数据
      baseUrl: 'https://dev-api.example.com',
    );
  }
}
