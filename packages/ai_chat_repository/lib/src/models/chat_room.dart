import 'package:equatable/equatable.dart';

import 'models.dart';

class ChatRoom extends Equatable {
  ChatRoom({
    this.messages = const <Message>[],
    required String title,
  }) : header = ChatRoomHeader(title: title);

  final ChatRoomHeader header;
  final List<Message> messages;

  @override
  List<Object?> get props => [header, messages];
}
