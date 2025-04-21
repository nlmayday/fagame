import 'package:flutter/material.dart';
import 'package:fagame/core/localization/app_localizations.dart';

/// Token过期对话框
///
/// 当用户token过期时显示的对话框，提示用户重新登录
class TokenExpiredDialog extends StatelessWidget {
  const TokenExpiredDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('登录已过期'),
      content: Text('您的登录信息已过期，请重新登录后继续使用。'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actions: [
        TextButton(
          onPressed: () {
            // 返回true表示用户确认要重新登录
            Navigator.of(context).pop(true);
          },
          child: Text('重新登录'),
        ),
      ],
    );
  }
}
