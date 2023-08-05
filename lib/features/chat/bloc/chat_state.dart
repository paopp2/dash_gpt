part of 'chat_bloc.dart';

enum ChatRoomStatus { loading, success, error }

final class ChatState extends Equatable {
  const ChatState({
    this.messageToSend = '',
    this.status = ChatRoomStatus.loading,
    this.messages = const <Message>[],
  });

  final ChatRoomStatus status;
  final List<Message> messages;
  final String messageToSend;

  ChatState copyWith({
    ChatRoomStatus? status,
    List<Message>? messages,
    String? messageToSend,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      messageToSend: messageToSend ?? this.messageToSend,
    );
  }

  @override
  List<Object> get props => [status, messages, messageToSend];
}
