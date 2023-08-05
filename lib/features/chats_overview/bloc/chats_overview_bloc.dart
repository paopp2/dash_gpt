import 'dart:async';

import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chats_overview_event.dart';
part 'chats_overview_state.dart';

class ChatsOverviewBloc extends Bloc<ChatsOverviewEvent, ChatsOverviewState> {
  ChatsOverviewBloc({
    required this.aiChatRepository,
  }) : super(const ChatsOverviewState()) {
    on<ChatsOverviewInitRequested>(_onInitRequested);
    on<ChatsOverviewRoomSelected>(_onRoomSelected);
  }

  final AIChatRepository aiChatRepository;

  Future<void> _onInitRequested(
    ChatsOverviewInitRequested event,
    Emitter<ChatsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: ChatsOverviewStatus.loading));

    emit.forEach(
      aiChatRepository.getChatRoomHeaders(),
      onData: (chatRooms) => state.copyWith(chatRooms: chatRooms),
    );
  }

  void _onRoomSelected(
    ChatsOverviewRoomSelected event,
    Emitter<ChatsOverviewState> emit,
  ) {
    emit(state.copyWith(selectedChatRoomId: event.chatRoomId));
  }
}
