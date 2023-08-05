import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:dash_gpt/features/chat/view/chat_page.dart';
import 'package:dash_gpt/features/chats_overview/bloc/chats_overview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatsOverviewView extends StatelessWidget {
  const ChatsOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocSelector<ChatsOverviewBloc, ChatsOverviewState,
          List<ChatRoomHeader>>(
        selector: (state) => state.chatRooms,
        builder: (context, chatRooms) {
          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoomHeader = chatRooms[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  tileColor: Colors.blue.shade100,
                  title: Text(chatRoomHeader.title ?? ''),
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
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(ChatPage.route),
        child: const Icon(Icons.add),
      ),
    );
  }
}
