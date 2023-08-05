import 'package:ai_chat_repository/ai_chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required this.chatRoomId,
    required this.aiChatRepository,
  }) : super(const ChatState()) {
    on<ChatRoomInitRequested>(_onRoomInitRequested);
    on<ChatMessageChanged>(_onMessageChanged);
    on<ChatMessageSent>(_onMessageSent);
  }

  final AIChatRepository aiChatRepository;
  final String chatRoomId;

  Future<void> _onRoomInitRequested(
    ChatRoomInitRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatRoomStatus.loading));
    await aiChatRepository.createNewChatRoom(id: chatRoomId);

    await emit.forEach(
      aiChatRepository.chatRoomStream(chatRoomId),
      onData: (chatRoom) => state.copyWith(
        status: ChatRoomStatus.success,
        messages: chatRoom.messages,
      ),
    );
  }

  void _onMessageChanged(ChatMessageChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(messageToSend: event.message));
  }

  Future<void> _onMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    final messageToSend = state.messageToSend;
    emit(state.copyWith(messageToSend: ''));
    return aiChatRepository.sendMessage(
      chatRoomId: chatRoomId,
      message: messageToSend,
    );
  }
}