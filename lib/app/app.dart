import 'package:dash_gpt/features/chat/view/chat_page.dart';
import 'package:dash_gpt/theme/theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const ChatPage(),
    );
  }
}
