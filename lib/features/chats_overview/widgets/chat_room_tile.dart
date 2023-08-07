import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:dash_gpt/features/chat/view/chat_page.dart';
import 'package:dash_gpt/features/chats_overview/bloc/chats_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatRoomTile extends StatelessWidget {
  const ChatRoomTile({
    super.key,
    required this.chatRoomHeader,
  });

  final ChatRoomHeader chatRoomHeader;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.blue.shade100,
      title: Text(chatRoomHeader.title ?? ''),
      trailing: BlocSelector<ChatsOverviewBloc, ChatsOverviewState, bool>(
        selector: (state) {
          return state.chatRoomsDeletionInProgress.contains(
            chatRoomHeader.id,
          );
        },
        builder: (context, isDeleteInProgress) {
          return isDeleteInProgress
              ? const CircularProgressIndicator()
              : IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => context
                      .read<ChatsOverviewBloc>()
                      .add(ChatsOverviewRoomDeleteRequested(
                        chatRoomId: chatRoomHeader.id,
                      )),
                );
        },
      ),
      onTap: () {
        context
          ..read<ChatsOverviewBloc>().add(ChatsOverviewRoomSelected(
            chatRoomId: chatRoomHeader.id,
          ))
          ..goNamed(
            ChatPage.route,
            queryParameters: {'id': chatRoomHeader.id},
          );
      },
    );
  }
}
