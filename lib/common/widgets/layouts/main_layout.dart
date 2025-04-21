import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fagame/core/utils/logger.dart';

/// 主布局组件，包含底部导航栏
class MainLayout extends StatefulWidget {
  /// 当前页面的索引
  final int currentIndex;

  /// 子组件（当前页面内容）
  final Widget child;

  const MainLayout({Key? key, required this.currentIndex, required this.child})
    : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.games), label: '游戏大厅'),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: '游戏'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '个人资料'),
        ],
      ),
    );
  }

  /// 处理底部导航栏点击事件
  void _onItemTapped(BuildContext context, int index) {
    // 如果点击的是当前页面，不做处理
    if (index == widget.currentIndex) {
      return;
    }

    // 根据点击的索引导航到不同页面
    switch (index) {
      case 0:
        _navigateTo(context, '/');
        break;
      case 1:
        _navigateTo(context, '/lobby');
        break;
      case 2:
        // 游戏页面需要ID参数，这里使用一个默认ID
        _navigateTo(context, '/game/default');
        break;
      case 3:
        _navigateTo(context, '/profile');
        break;
    }
  }

  /// 使用GoRouter导航到指定路径
  void _navigateTo(BuildContext context, String path) {
    try {
      AppLogger.d('导航到: $path');
      context.go(path);
    } catch (e) {
      AppLogger.e('导航错误: {0}', [e]);
    }
  }
}
