import 'package:bodysnap/core/platform/widgets/adaptive_scaffold.dart';
import 'package:flutter/material.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Container(
        color: Colors.red,
        child: const Text("Hello"), // 상단에 붙어서 status bar에 겹칠 수 있음
      ),
    );
  }
}
