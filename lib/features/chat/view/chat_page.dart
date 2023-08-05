import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:dash_gpt/features/chat/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_view.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    super.key,
    this.chatId,
  });

  static String route = 'chat_page';
  final String? chatId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        chatRoomId: chatId,
        aiChatRepository: context.read<AIChatRepository>(),
      )..add(ChatRoomInitRequested()),
      child: const ChatView(),
    );
  }
}
