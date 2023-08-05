part of 'chat_bloc.dart';

enum ChatRoomStatus { loading, success, error }

final class ChatState extends Equatable {
  const ChatState({
    this.chatRoomTitle = 'New chat',
    this.messageToSend = '',
    this.status = ChatRoomStatus.loading,
    this.messages = const <Message>[],
  });

  final String chatRoomTitle;
  final ChatRoomStatus status;
  final List<Message> messages;
  final String messageToSend;

  ChatState copyWith({
    ChatRoomStatus? status,
    String? chatRoomTitle,
    List<Message>? messages,
    String? messageToSend,
  }) {
    return ChatState(
      status: status ?? this.status,
      chatRoomTitle: chatRoomTitle ?? this.chatRoomTitle,
      messages: messages ?? this.messages,
      messageToSend: messageToSend ?? this.messageToSend,
    );
  }

  @override
  List<Object> get props => [status, chatRoomTitle, messages, messageToSend];
}
