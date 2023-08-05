import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:dash_gpt/features/chats_overview/bloc/chats_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chats_overview_view.dart';

class ChatsOverviewPage extends StatelessWidget {
  const ChatsOverviewPage({super.key});
  static String route = 'chats_overview_page_route';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatsOverviewBloc(
        aiChatRepository: context.read<AIChatRepository>(),
      )..add(ChatsOverviewInitRequested()),
      child: const ChatsOverviewView(),
    );
  }
}
