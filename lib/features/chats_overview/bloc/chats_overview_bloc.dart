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
    on<ChatsOverviewRoomDeleteRequested>(_onRoomDeleteRequested);
  }

  final AIChatRepository aiChatRepository;

  Future<void> _onInitRequested(
    ChatsOverviewInitRequested event,
    Emitter<ChatsOverviewState> emit,
  ) async {
    await emit.forEach(
      aiChatRepository.getChatRoomHeaders(),
      onData: (chatRooms) => state.copyWith(
        chatRooms: chatRooms,
        status: ChatsOverviewStatus.success,
      ),
    );
  }

  void _onRoomSelected(
    ChatsOverviewRoomSelected event,
    Emitter<ChatsOverviewState> emit,
  ) {
    emit(state.copyWith(selectedChatRoomId: event.chatRoomId));
  }

  Future<void> _onRoomDeleteRequested(
    ChatsOverviewRoomDeleteRequested event,
    Emitter<ChatsOverviewState> emit,
  ) async {
    emit(state.withChatRoomDeleteInProgress(event.chatRoomId));
    await aiChatRepository.deleteChatRoom(event.chatRoomId);
    emit(state.withChatRoomDeleteInProgressRemoved(event.chatRoomId));
  }
}
