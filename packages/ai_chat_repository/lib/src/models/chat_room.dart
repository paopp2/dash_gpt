import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'models.dart';

@immutable
class ChatRoom extends Equatable {
  ChatRoom({
    ChatRoomHeader? header,
    this.messages = const <Message>[],
    String? title,
  }) : header = header ?? ChatRoomHeader(title: title);

  final ChatRoomHeader header;
  final List<Message> messages;

  ChatRoom withNewMessage(Message newMessage) {
    return copyWith(
      messages: [...messages, newMessage],
    );
  }

  ChatRoom copyWith({
    String? title,
    List<Message>? messages,
  }) {
    return ChatRoom(
      header: header.copyWith(title: title ?? header.title),
      messages: messages ?? this.messages,
    );
  }

  factory ChatRoom.from({String? id, String? title}) {
    return ChatRoom(
      header: ChatRoomHeader(id: id, title: title),
      title: title,
    );
  }

  @override
  List<Object?> get props => [header, messages];

  @override
  String toString() {
    return "ChatRoom {id: ${header.id}, title: ${header.title}, messages: $messages}";
  }
}
