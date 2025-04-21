import 'package:fagame/features/auth/data/repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// 执行登出操作
  Future<void> execute() async {
    await repository.logout();
  }
}
