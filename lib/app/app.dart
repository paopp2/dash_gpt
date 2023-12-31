import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:dash_gpt/app/app_router.dart';
import 'package:dash_gpt/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App(this.aiChatRepository, {super.key});

  final AIChatRepository aiChatRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: aiChatRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: AppRouter.instance,
    );
  }
}
