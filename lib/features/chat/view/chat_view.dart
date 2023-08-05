import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: BlocSelector<ChatBloc, ChatState, String>(
          selector: (state) => state.chatRoomTitle,
          builder: (_, chatRoomTitle) => Text(chatRoomTitle),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocSelector<ChatBloc, ChatState, List<Message>>(
              selector: (state) => state.messages,
              builder: (context, messages) {
                final revMessages = messages.reversed.toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: revMessages.length,
                  itemBuilder: (context, index) {
                    final message = revMessages[index];
                    return ListTile(
                      title: Text(message.content),
                      subtitle: Text(message.sender.toString()),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Theme.of(context).secondaryHeaderColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: BlocListener<ChatBloc, ChatState>(
                      listener: (_, __) => textController.clear(),
                      listenWhen: (prev, curr) =>
                          prev.messageToSend.isNotEmpty &&
                          curr.messageToSend.isEmpty,
                      child: TextField(
                        controller: textController,
                        decoration:
                            const InputDecoration(hintText: 'Message here'),
                        onChanged: (val) => context
                            .read<ChatBloc>()
                            .add(ChatMessageChanged(message: val)),
                        onSubmitted: (_) =>
                            context.read<ChatBloc>().add(ChatMessageSent()),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        context.read<ChatBloc>().add(ChatMessageSent()),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
