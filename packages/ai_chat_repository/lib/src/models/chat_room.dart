import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'models.dart';

@immutable
class ChatRoom extends Equatable {
  ChatRoom({
    ChatRoomHeader? header,
    this.messages = const <Message>[],
    String title = '',
  }) : header = header ?? ChatRoomHeader(title: title);

  final ChatRoomHeader header;
  final List<Message> messages;

  ChatRoom copyWith({
    List<Message>? messages,
  }) {
    return ChatRoom(
      header: header,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [header, messages];

  @override
  String toString() {
    return "ChatRoom {id: ${header.id}, title: ${header.title}, messages: $messages}";
  }
}
